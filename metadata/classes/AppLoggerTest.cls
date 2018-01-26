@IsTest
public class AppLoggerTest {
	static Assert assert = sf.assert;
	
    testmethod public static void test_logError() {
        TestUtils.setCurrentDateTime(DateTime.newInstance(2017, 01, 01));
        
        Sf.appLogger.saveError('Module', 'Action', 'Something terrible happened.', new Utils().createTestException());
        
        App_Log__c alObj = queryAppLogs().get(0);
        assert.that(alObj.Module__c).isEqualsTo('Module');
        assert.that(alObj.Action__c).isEqualsTo('Action');
        assert.that(alObj.Type__c).isEqualsTo('Error');
        assert.that(alObj.Message__c).isEqualsTo('Something terrible happened.');
        assert.that(alObj.Details1__c).isNotBlank();
        
    }
    
    private static List<App_Log__c> queryAppLogs() {
        return [select Id, Name, Action__c, App_Task_Id__c, Details1__c, Details2__c, Details3__c, Details4__c, Details5__c, 
            External_Id__c, Message__c, Module__c, Record__c, Record_Id__c, Sobject__c, Type__c, Value1__c, 
            Value2__c, Value3__c, Value4__c, Value5__c, OwnerId from App_Log__c];
    }
    
}