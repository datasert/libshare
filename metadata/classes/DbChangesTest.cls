@IsTest 
public with sharing class DbChangesTest {

	testmethod static public void testEmptyNoError() {
		List<SObject> sobjs = null;
		new DbChanges().save();
		new DbChanges().addInsert(sobjs).addUpdate(sobjs).addDelete(sobjs).save();
	}

	testmethod static public void testChanges() {
		Contact contact = new Contact();
		contact.Firstname = 'Test First';
		contact.Lastname = 'Test Last';

		new DbChanges().add(contact).save();

		System.assert(contact.id != null);
	
		contact.firstName ='First Name Updated';		

		new DbChanges().addUpdate(contact).save();
		
		Contact contact2 = [select firstName from contact where id = :contact.id limit 1];
		System.assertEquals('First Name Updated', contact2.firstName);
		
		new DbChanges().addDelete(contact).save();
		List<Contact> contacts = [select firstName from contact where id = :contact.id];
		System.assert(contacts.isEmpty());
	}
	
	testmethod static public void testDuplicateChanges() {
		Contact contact = new Contact();
		contact.Firstname = 'Test First';
		contact.Lastname = 'Test Last';
		
		new DbChanges().addInsert(contact).addInsert(contact).save();				
		System.assert(contact.id != null);
		
		contact.firstName ='First Name Updated';		
		new DbChanges().add(contact).addUpdate(contact).save();

		Contact contact2 = [select firstName from contact where id = :contact.id limit 1];
		System.assertEquals('First Name Updated', contact2.firstName);

		new DbChanges().addDelete(contact).addDelete(contact).save();
		List<Contact> contacts = [select firstName from contact where id = :contact.id];
		System.assert(contacts.isEmpty());
	}
	
	testmethod static public void testMultipleChanges() {
		Contact contact = new Contact();
		contact.Firstname = 'Test First';
		contact.Lastname = 'Test Last';

		Account account = new Account();
		account.Name = 'Test Account';
		
		List<SObject> objs = new List<SObject>();
		objs.add(contact);
		objs.add(account);
				
		new DbChanges().addInsert(objs).save();				
		System.assert(contact.id != null);
		System.assert(account.id != null);
		
		contact.firstName ='First Name Updated';		
		account.Name ='Account Name Updated';		
		new DbChanges().addUpdate(objs).save();
		new DbChanges().add(objs).save();

		Contact contact2 = [select firstName from contact where id = :contact.id limit 1];
		System.assertEquals('First Name Updated', contact2.firstName);

		Account account2 = [select Name from Account where id = :account.id limit 1];
		System.assertEquals('Account Name Updated', account.name);

		new DbChanges().addDelete(objs).save();
		List<Contact> contacts = [select firstName from contact where id = :contact.id];
		System.assert(contacts.isEmpty());
		
		List<Account> accounts = [select Name from Account where id = :account.id];
		System.assert(accounts.isEmpty());
	}

	testmethod static public void testMultipleChanges_WoSharing() {
		Contact contact = new Contact();
		contact.Firstname = 'Test First';
		contact.Lastname = 'Test Last';

		Account account = new Account();
		account.Name = 'Test Account';
		
		List<SObject> objs = new List<SObject>();
		objs.add(contact);
		objs.add(account);
				
		new DbChanges().addInsert(objs).save();				
		System.assert(contact.id != null);
		System.assert(account.id != null);
		
		contact.firstName ='First Name Updated';		
		account.Name ='Account Name Updated';		
		new DbChanges().addUpdate(objs).save();

		Contact contact2 = [select firstName from contact where id = :contact.id limit 1];
		System.assertEquals('First Name Updated', contact2.firstName);

		Account account2 = [select Name from Account where id = :account.id limit 1];
		System.assertEquals('Account Name Updated', account.name);

		new DbChanges().addDelete(objs).save();
		List<Contact> contacts = [select firstName from contact where id = :contact.id];
		System.assert(contacts.isEmpty());
		
		List<Account> accounts = [select Name from Account where id = :account.id];
		System.assert(accounts.isEmpty());
	}
    
	testmethod static public void testInvalidUpdateDeletes() {
		Account account = new Account();
		account.Name = 'Test Account';
		
		try {
			new DbChanges().addUpdate(account);
			System.assert(false, 'Expected a exception due to invalid update');
		} catch (Exception e) {
			//Ignore
		}		

		try {
			new DbChanges().addDelete(account);
			System.assert(false, 'Expected a exception due to invalid update');
		} catch (Exception e) {
			//Ignore
		}		
	}
	testmethod static public void testIdUpdates() {
		Contact contact1 = new Contact();
		Contact contact2 = new Contact();

		Account account = new Account();
		account.Name = 'Test Account';

		new DbChanges().addInsert(account, contact1, 'AccountId').save();
		new DbChanges().addIdUpdate(account, contact2, 'AccountId').save();
		System.assertNotEquals(null, contact1.accountId);
		System.assertNotEquals(null, contact2.accountId);
	}
	
	testmethod static public void testChunking() {
		new DbChanges()
            .chunking(true)
            .chunkingSize(1)
			.addInsert(new Contact(FirstName='First1',LastName='Last1'))
			.addInsert(new Account(Name='Account'))
		.save();
	}
	
    testmethod static public void testStaticSave() {
		Contact contact = new Contact();
		contact.Firstname = 'Test First';
		contact.Lastname = 'Test Last';
		DbChanges.save(contact);
		DbChanges.save(contact);
        
        Contact contact2 = new Contact();
		contact2.Firstname = 'Test First';
		contact2.Lastname = 'Test Last';
        DbChanges.save(new Contact[]{contact, contact2});
        DbChanges.save(new Contact[]{contact, contact2});
    }
    
    testmethod static void testDeleteExceptionHandling() {
        //We will insert two accounts. Add both of them for delete. But delete one account
        //before calling save and see what happens.
        Account acct1 = new Account(Name='Foo', BillingCity='Dublin');
        insert acct1;
        
        Account acct2 = new Account(Name='Foo', BillingCity='Dublin');
        insert acct2;
        
        DbChanges dbChangesWoSharing = new DbChanges();
        dbChangesWoSharing.addDelete(acct1);
        dbChangesWoSharing.addDelete(acct2);
        
        delete acct1;
        
        dbChangesWoSharing.save();
        
        //Make sure two records are deleted.
        System.assertEquals(0, [select id from account where id in (:acct1.id, :acct2.id)].size());
        
		acct1 = new Account(Name='Foo', BillingCity='Dublin');
        insert acct1;
        
        acct2 = new Account(Name='Foo', BillingCity='Dublin');
        insert acct2;
        
        DbChanges dbChanges = new DbChanges();
        dbChanges.addDelete(acct1);
        dbChanges.addDelete(acct2);
        
        delete acct1;
        
        dbChanges.save();
        
        //Make sure two records are deleted.
        System.assertEquals(0, [select id from account where id in (:acct1.id, :acct2.id)].size());        
    }
}