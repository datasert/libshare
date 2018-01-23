global class JsonWriter {
    private static Utils u = new Utils();
	private static Logger logger = new Logger();

    private Object jsonObj;
    private Boolean ignoreNulls;
    private List<String> withs = new List<String>();
    private Boolean isRootArray;
    
    global JsonWriter() {
		this(false);
    }
    
    global JsonWriter(Boolean isRootArray) {
        this.isRootArray = isRootArray;
        this.ignoreNulls = false;
    }
    
    global JsonWriter ignoreNulls(boolean ignoreNulls) {
        this.ignoreNulls = ignoreNulls;
        return this;
    }
    
    global String toJson() {
        return toJson(false);
    }
    
    global String toJson(Boolean pretty) {
        if (jsonObj == null) {
            if (isRootArray) {
                jsonObj = new List<Object>();
            } else {
                jsonObj = new Map<String, Object>();
            }
        }
        
        if (pretty) {
			return Json.serializePretty(jsonObj);
        } else {
			return Json.serialize(jsonObj);
        }
    }
    
    global String toPrettyJson() {
		return toJson(true);
    }

    global JsonWriter newWith(String with) {
		withs.clear();
        return with(with);
    }
    
    global JsonWriter with(String with) {
        withs.add(with);
        return this;
    }
    
    global JsonWriter endWith() {
        if (!withs.isEmpty()) {
			withs.remove(withs.size() - 1);
        }

        return this;
    }
    
    global JsonWriter clearWith() {
        withs.clear();
        return this;
    }
    
    global JsonWriter writeIfNotBlank(String key, String value) {
        if (String.isNotBlank(value)) {
			return write(key, value);
        }
        
        return this;
    }
    
    global JsonWriter writeIfNotNull(String key, Object value) {
        if (value != null) {
	        write(key, value);
        }
        
        return this;
    }
    
    global JsonWriter write(String key, Object value) {
        //System.debug('Writing ' + key + '=' + value);
        
        if (ignoreNulls && value == null) {
            return this;
        }
        
        if (value instanceof DateTime || value instanceof Date) {
            value = u.toString(value);
        }
        
        try {
            Object currentObj = null;
            
			key = getWithKey(key);
            
            //We need to get the object corresponding to the key. If object not there, we will need to create it.
            String[] segments = key.split('\\.');
            
            //We will process all segments except the last as last one is the actual field within the 
            //object.
            for (Integer segmentIndex = 0; segmentIndex < segments.size(); segmentIndex++) {
                String segment = segments.get(segmentIndex);
                if (segment.indexOf('[') < 0) {
                    
                    //This is not any array so we should look for an object.
                    //If current object is null, then we will use the root object, jsonObj. If jsonObject is null, then we will create one.
                    if (currentObj == null) {
                        if (jsonObj == null) {
                            jsonObj = new Map<String, Object>();
                        }
                        
                        currentObj = jsonObj;
                    }
                    
                    Map<String, Object> mapObj = (Map<String, Object>) currentObj;
                    
                    if (segmentIndex == segments.size() - 1) {
                        ((Map<String, Object>) currentObj).put(segment, value);
                       } else {
                        if (mapObj.get(segment) == null) {
                            mapObj.put(segment, new Map<String, Object>());
                        }
                        
                        currentObj = mapObj.get(segment);
                    }
                } else {
                    
                    //Segment is an array. So we will have to look for particular item within the object.
                    String arrayKey = segment.substringBefore('[');
                    Integer arrayIndex = Integer.valueOf(segment.substringBetween('[', ']'));
                    
                    if (String.isBlank(arrayKey)) {
                        
                        //If array key is null, then we are dealing with just an array.
                        if (currentObj == null) {
                            if (jsonObj == null) {
                                jsonObj = new List<Object>();
                                isRootArray = true;
                            }
                        
                            currentObj = jsonObj;
                        }
                        
                        //Get the array within the current object by the segment key.
                        List<Object> listObj = (List<Object>) currentObj;
                        
                        //If array object is smaller than index, then grow till index
                        for (Integer i = listObj.size(); i < arrayIndex + 1; i++) {
                            listObj.add(null);                    
                        }
                        
                        //If it is the last segment, then we are looking at setting primitive value at array index. If not,
                        //then we are looking at setting object as array index.
                        if (segmentIndex == segments.size() - 1) {
                            listObj.set(arrayIndex, value);
                        } else {
                            if (listObj.get(arrayIndex) == null) {
                                listObj.set(arrayIndex, new Map<String, Object>());
                            }
                            
                            currentObj = listObj.get(arrayIndex);
                        }
                        
                    } else {
                        //If current object is null, then we will use the root object, jsonObj. If jsonObject is null, then we will create one.
                        if (currentObj == null) {
                            if (jsonObj == null) {
                                jsonObj = new Map<String, Object>();
                            }
                            
                            currentObj = jsonObj;
                        }
                        
                        //Get the array within the current object by the segment key.
                        Map<String, Object> mapObj = (Map<String, Object>) currentObj;
                        
                        List<Object> listObj = (List<Object>) mapObj.get(arrayKey);
                        if (listObj == null) {
                            listObj = new List<Object>();
                            mapObj.put(arrayKey, listObj);
                        }
                        
                        //If array object is smaller than index, then grow till index
                        for (Integer i = listObj.size(); i < arrayIndex + 1; i++) {
                            listObj.add(null);                    
                        }
                        
                        if (segmentIndex == segments.size() - 1) {
                            listObj.set(arrayIndex, value);
                            
                        } else {
                            if (listObj.get(arrayIndex) == null) {
                                listObj.set(arrayIndex, new Map<String, Object>());
                            }
                            
                            currentObj = listObj.get(arrayIndex);
                        }
                    }
                }
            }

            return this;
        } catch (Exception e) {
            throw new LibshareException('Exception while writing \'' + key + '=' + value + '\' to Json object. Error [' + e.getMessage() + ']', e);
        }
    }
    
    /**
     * Adds the given link to current document in HAL spec. See this link for more info
     * https://phlyrestfully.readthedocs.io/en/latest/halprimer.html
     */
    global JsonWriter writeLink(String name, String url) {
 	    write('_links.' + name + '.href', url);
        return this;
    }

    /**
     * Adds the self link to current document in HAL spec. See this link for more info
     * https://phlyrestfully.readthedocs.io/en/latest/halprimer.html
     */
    global JsonWriter writeSelfLink(String url) {
 	    write('_links.self.href', url);
        return this;
    }
    
    @TestVisible
    private String getWithKey(String key) {
        if (!withs.isEmpty()) {
            key = u.join('.', withs) + '.' + key;
        }
        
        return key;
    }
}