/**
 * Utility class provides the functionality of collecting the db changes and save them at one time.
 * 
 * Along with providing basic container functionality, it also provides following enhancements.
 * 
 * 1. Clients don't have to worry about if there are any records to insert/update/delete. 
 * 2. Duplicate objects in the update/delete queue are automatically deduped
 * 3. Provides the chunking capability to group records of similar type
 * 4. Provides the capability to update records with newly generated Ids.
 */ 
global class DbChanges {
    
    private static Logger log = new Logger('DbChanges');
	private static Utils utils = new Utils();
    
	private Map<Id, SObject> updatesMap = new Map<Id, SObject>();
	private Map<Id, SObject> deletesMap = new Map<Id, SObject>();
	private Set<SObject> updates {get;set;} 
	private Set<SObject> deletes {get;set;} 
	private Set<SObject> inserts {get;set;}
	private List<DbChangesIdUpdate> idUpdates {get;set;}
	private Integer retryAttempts = 3;
	private Integer retryInterval = 150;
	private Boolean chunking = false;
	private Integer chunkingSize = 5;

	global DbChanges () {
		updates = new Set<Sobject>();
		deletes = new Set<Sobject>();
		inserts = new Set<Sobject>();
		idUpdates = new List<DbChangesIdUpdate>();
	}
    
    global Integer retryAttempts() {
        return retryAttempts;
    }
	
    global DbChanges retryAttempts(Integer retryAttempts) {
        this.retryAttempts = retryAttempts;
        return this;
    }

    global Integer retryInterval() {
        return retryInterval;
    }
	
    global DbChanges retryInterval(Integer retryInterval) {
        this.retryInterval = retryInterval;
        return this;
    }

    global Boolean chunking() {
        return chunking;
    }
	
    global DbChanges chunking(Boolean chunking) {
        this.chunking = chunking;
        return this;
    }

    global Integer chunkingSize() {
        return chunkingSize;
    }
	
    global DbChanges chunkingSize(Integer chunkingSize) {
        this.chunkingSize = chunkingSize;
        return this;
    }

    /**
     * Returns the number of records added to insert, update and delete queue.
     */
    global Integer size() {
        return inserts.size() + updates.size() + deletes.size();
    }

    /**
     * Adds the given set of objects to be inserted/updated based on their id.
     */
	global DbChanges add(List<SObject> sobjs) {
        for(Sobject sobj : sobjs) {
            if (sobj.id == null) {
                addInsert(sobj);
            } else {
                addUpdate(sobj);
            }
        }
        
        return this;
    }
    
    /**
     * Adds the given sobject to be inserted/updated based on its id.
     */
	global DbChanges add(SObject sobj) {
        if (sobj.id == null) {
            addInsert(sobj);
        } else {
            addUpdate(sobj);
        }
        
        return this;
    }

    global DbChanges addInsert(List<SObject> sobjs) {
		if (sobjs == null) {
			return this;
		}
		
		inserts.addAll(sobjs);
		return this;
	}
	
	global DbChanges addInsert(SObject sobj) {
        inserts.add(sobj);
		return this;
	}
	
	public DbChanges addInsert(SObject sobj, SObject toObj, String toField) {
		addInsert(sobj, 'Id', toObj, toField);
		return this;
	}
	
	public DbChanges addInsert(SObject sobj, String fromField, SObject toObj, String toField) {
		inserts.add(sobj);
		addIdUpdate(sobj, fromField, toObj, toField);
		return this;
	}

	public DbChanges addIdUpdate(SObject fromSobj, SObject toSobj, String toField) {
		addIdUpdate(fromSobj, 'Id', toSobj, toField);
		return this;
	}

	private DbChanges addIdUpdate(SObject fromSobj, String fromField, SObject toSobj, String toField) {
		DbChangesIdUpdate idUpdate = new DbChangesIdUpdate();
		idUpdate.fromObj = fromSobj;
		idUpdate.toObj = toSobj;
		idUpdate.fromField = fromField;
		idUpdate.toField = toField;

		idUpdates.add(idUpdate);
		return this;
	}

	global DbChanges addUpdate(List<SObject> sobjs) {
		if (sobjs == null) {
			return this;
		}

		for (Sobject sobj : sobjs) {
			addUpdate(sobj);
		}
		return this;
	}

	global DbChanges addUpdate(SObject sobj) {
		Id id = (Id) sobj.get('id');
		if (id == null) {
			throw new LibshareException('SObject ' + sobj + ' is missing id field to update');
		}
		
		if (updatesMap.get(id) == null) {
			updates.add(sobj);
			updatesMap.put(id, sobj);
		}
		return this;
	}

	global DbChanges addDelete(List<SObject> sobjs) {
		if (sobjs == null) {
			return this;
		}

		for (Sobject sobj : sobjs) {
			addDelete(sobj);
		}
		return this;
	}

	global DbChanges addDelete(SObject sobj) {
		Id id = (Id) sobj.get('id');
		if (id == null) {
			throw new LibshareException('SObject ' + sobj + ' is missing id field to delete');
		}
		
		if (deletesMap.get(id) == null) {
			deletes.add(sobj);
			deletesMap.put(id, sobj);
		}
		return this;
	}

	private void processIdUpdates() {
		if (idUpdates == null || idUpdates.isEmpty()) {
			return;
		}
		for (DbChangesIdUpdate idUpdate : idUpdates) {
			idUpdate.toObj.put(idUpdate.toField, idUpdate.fromObj.get(idUpdate.fromField));
		}
	}

    public void saveIgnoreExceptions() {
        try {
			save();            
        } catch (Exception e) {
            System.debug('Exception while saving the records inserts=' + inserts +', updates=' + updates +', deletes=' + deletes + ' ' + e.getStackTraceString());
        }
    }
    
    global void save() {
        
        log.info('Saving ' + size() + ' records [inserts=' + inserts.size() +', updates=' + updates.size() + ', deletes=' + deletes.size());
        
    	if (chunking) {
    		chunkChanges(inserts, 'Insert', chunkingSize);
    		chunkChanges(updates, 'Update', chunkingSize);
    		chunkChanges(deletes, 'Delete', chunkingSize);
    	} else {
            saveChanges(new List<SObject>(inserts), 'Insert');
            saveChanges(new List<SObject>(updates), 'Update');
            saveChanges(new List<SObject>(deletes), 'Delete');
    	}

		processIdUpdates();    	
    }
	
	private void chunkChanges(Set<SObject> changes, String action, Integer chunkingSize) {
		if (changes.size() == 0) {
			return;
		}
		
		log.debug('Chunking records of size ' + changes.size() + ' with chunking size ' + chunkingSize + ' for ' + action + ' action');
		
		Map<String, List<SObject>> chunks = groupSobjectsByType(changes);
		log.debug('Changes grouped by type ' + chunks);
		
		Integer chunked = 0;
		List<SObject> chunkedChanges = new List<SObject>();
		for (String objectType : chunks.keyset()) {
			chunked++;
			chunkedChanges.addAll(chunks.get(objectType));
			
			if (chunked >= chunkingSize) {
				saveChanges(chunkedChanges, action);
				chunked = 0;
				chunkedChanges = new List<SObject>();
			}
		}
		
		if (chunkedChanges.size() > 0) {
			saveChanges(chunkedChanges, action);
		}
	}
	
	private Map<String, List<SObject>> groupSobjectsByType(Set<SObject> changes) {
		Map<String, List<SObject>> chunks = new Map<String, List<SObject>>();
		for (SObject sobj : changes) {
			String objectType = String.valueOf(sobj.getsObjectType());
			List<SObject> sobjs = chunks.get(objectType);
			if (sobjs == null) {
				sobjs = new List<SObject>();
				chunks.put(objectType, sobjs);
			}
			
			sobjs.add(sobj);
		}
		
		return chunks;
	}

	private void saveChanges(List<SObject> changes, String action) {
        saveChanges(changes, action, 0);
    }
    
	private void saveChanges(List<SObject> changes, String action, Integer retryCount) {
        try {
            log.debug('Saving records ' + changes + ' with action ' + action);
            
            if (action == 'Update') {
                if (!changes.isEmpty()) {
                    log.debug('Updating' + changes);
                    updateChanges(changes);
                }
                
            } else if (action == 'Insert') {
                if (!changes.isEmpty()) {
                    log.debug('Inserting ' + changes);
					insertChanges(changes);
                }
                
            } else if (action == 'Delete') {
                if (!changes.isEmpty()) {
                    log.debug('Deleting ' + changes);
					deleteChanges(changes);
                }
            }
        } catch (System.DmlException e) {
            String message = e.getMessage();
            if (message != null && message.indexOf('UNABLE_TO_LOCK_ROW') >= 0 && retryCount < retryAttempts) {
                System.debug('Failed with re-triable error. ' + e.getMessage() + ' going to retry after sleeping for ' + RetryInterval + '. Retry count ' + (retryCount + 1));
                utils.sleep(RetryInterval);
                saveChanges(changes, action, retryCount + 1);
            } else {
                throw e;
            }
        }
	}
	
    /**
     * This class would be used to keep reference to an object which is not inserted but whose generatred
     * id needs to be updated to other objects.
     */
    public class DbChangesIdUpdate {
    	public SObject fromObj {get;set;}
    	public SObject toObj {get;set;}
    	public String fromField {get;set;}
    	public String toField {get;set;}
    }
    
    private void updateChanges(List<Sobject> sobjs) {
        FlsUtils.ensureUpdateable(sobjs.get(0));
		Database.update(sobjs, true);
    }

    private void insertChanges(List<Sobject> sobjs) {
        FlsUtils.ensureCreateable(sobjs.get(0));
        Database.insert(sobjs, true);
    }

    private void deleteChanges(List<Sobject> sobjs) {
        FlsUtils.ensureDeletable(sobjs.get(0));
        //For delete we will go with partial success as it can errors out if entity is already delete.
		Database.delete(sobjs, false);
    }
    
    global static void save(List<Sobject> sobjs) {
        new DbChanges().add(sobjs).save();
    }
    
    global static void save(Sobject sobj) {
        new DbChanges().add(sobj).save();
    }
    
    //We cannot update setup and non-setup object in same txn. If we do we get into wrath of salesforce with this message.
    //System.DmlException: Update failed. First exception on row 0 with id a9f630000008UPCAA2; first error: MIXED_DML_OPERATION, DML operation on setup object is not permitted after you have updated a non-setup object (or vice versa): Employee__c, original object: User: []
	//To overcome that, we update users in main txn and call this job to update employees.
    public static void saveAsync(DbChanges dbChanges) {
        System.enqueueJob(new DbChangesSaveJob(dbChanges));
    }
    
	public class DbChangesSaveJob implements Queueable {
		DbChanges dbChanges = null;
        
        public DbChangesSaveJob (DbChanges dbChanges) {
			this.dbChanges = dbChanges;    
        }
        
        public void execute(QueueableContext ctx) {
			dbChanges.save();
        }
	}    
}