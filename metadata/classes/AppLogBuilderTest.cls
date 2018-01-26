@IsTest
public class AppLogBuilderTest {
	static Assert assert = sf.assert;
    
    testmethod public static void test_appLogBuilder() {
        TestUtils.setCurrentDateTime(DateTime.newInstance(2017, 10, 01));
        
        App_Task__c appTask = new App_Task__c(Module__c='test', Action__c='test');
        insert appTask;
        
        AppLogBuilder appLog = Sf.newAppLog()
            .module('UnitTest')
            .action('LogTest')
            .typeDebug()
            .message('Testing')
            .value1('value1')
            .value2('value2')
            .value3('value3')
            .value4('value4')
            .value5('value5')
            .appTask(appTask)
            .externalId('some external id')
            .record(appTask)
			.log('Starting processing')
            .log('Some error', new LibshareException())
            .typeError();
            
        App_Log__c alObj = appLog.getLogRecord();
		appLog.setLogRecord(alObj);
        
        assert.that(alObj.Action__c).isEqualsTo('LogTest');
        assert.that(alObj.Module__c).isEqualsTo('UnitTest');
        assert.that(alObj.Type__c).isEqualsTo('Error');
        assert.that(alObj.Message__c).isEqualsTo('Some error');
        assert.that(alObj.Value1__c).isEqualsTo('value1');
        assert.that(alObj.Value2__c).isEqualsTo('value2');
        assert.that(alObj.Value3__c).isEqualsTo('value3');
        assert.that(alObj.Value4__c).isEqualsTo('value4');
        assert.that(alObj.Value5__c).isEqualsTo('value5');
        assert.that(alObj.External_Id__c).isEqualsTo('some external id');
        assert.that(alObj.App_Task_Id__c).isEqualsTo(appTask.id);
        assert.that(alObj.Record_Id__c).isEqualsTo(appTask.id);
        assert.that(alObj.Sobject__c).isEqualsTo('lib__App_Task__c');
        assert.that(alObj.Details1__c).isNotBlank();
        
		appLog.stash();
        assert.that([select id from app_log__c].size()).isEqualsTo(0);
        
		appLog.save();
        assert.that([select id from app_log__c].size()).isEqualsTo(1);
    }
}