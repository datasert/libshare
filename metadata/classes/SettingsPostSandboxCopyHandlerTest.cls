@IsTest
public class SettingsPostSandboxCopyHandlerTest {
    testmethod public static void test_postcopy() {
		Settings__c setting = new Settings__c();
        setting.name = 'envtest';
        setting.Value__c = 'value1';
        setting.Env_Specific__c = true;
		
		insert setting;

		setting = new Settings__c();
        setting.name = 'test';
        setting.Value__c = 'value2';
        setting.Env_Specific__c = false;
		
		insert setting;

        new SettingsPostSandboxCopyHandler().runApexClass(null);
        
        Sf.assert.that(Sf.settings.getString('envtest', null)).isNull();

        Sf.assert.that(Sf.settings.getString('test', null)).isEqualsTo('value2');
    }
}