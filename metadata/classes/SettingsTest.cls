@IsTest
public class SettingsTest {
    
    private static Settings settings = Sf.settings;
    private static final String testKey = 'testKey';

    private static String createString(Integer length) {
        String value = '';
        while (value.length() < length) {
            value += '0';
        }
        
        return value;
    }

    private static Integer countKeys(String key) {
        Integer keysCount = 0;
        for (Integer i = 0; i <= 99; i++) {
            String splitKey = settings.getSplitKey(key, i);
        	Settings__c setting = Settings__c.getValues(splitKey);
            if (setting != null) {
                keysCount++;
            }
        }        
        
        return keysCount;
    }
    
    testmethod public static void test_invalidKeysAndValues() {
        try {
            //Key cannot be more than 38 chars
	        settings.setString(createString(39), 'value');
    		System.assert(false, 'Expected exception');      
        } catch (Exception e) {
        }

        try {
            //If value contains more than 255 bytes, then key length cannnot be more than 34
	        settings.setString(createString(35), createString(256));
    		System.assert(false, 'Expected exception');      
        } catch (Exception e) {
        }

        try {
            //Key cannot contain two double underscores
	        settings.setString('Setting__value', 'value');
    		System.assert(false, 'Expected exception');      
        } catch (Exception e) {
        }

        try {
            //Key cannot be null
	        settings.setString(null, 'value');
    		System.assert(false, 'Expected exception');      
        } catch (Exception e) {
        }

        try {
            //Key cannot be blank
	        settings.setString('', 'value');
    		System.assert(false, 'Expected exception');      
        } catch (Exception e) {
        }

        try {
            //Key cannot be blank
	        settings.setString(' ', 'value');
    		System.assert(false, 'Expected exception');      
        } catch (Exception e) {
        }
        
        try {
            //Value cannot be more than 25500 chars
	        settings.setString('test', createString(25501));
    		System.assert(false, 'Expected exception');      
        } catch (Exception e) {
        }
        
    }

    testmethod public static void test_setString() {
        settings.setString(testKey, 'foo');
        System.assertEquals('foo', settings.getString(testKey));

        settings.setString(testKey, 'bar');
        System.assertEquals('bar', settings.getString(testKey));

        settings.setString(testKey, null);
        System.assertEquals('bob', settings.getString(testKey, 'bob'));
    }
    
    testmethod public static void test_getString() {
        
        try {
            settings.getString(testKey);            
            System.assert(false, 'Expected an exception to be thrown');
        } catch (SettingsException e) {
        }
		
        settings.setString(testKey, 'StringValue');
        System.assertEquals('StringValue', settings.getString(testKey));
        System.assertEquals('StringValue', settings.getString(testKey, 'DefaultValue'));
		
        //Make sure value returned is trimmed.
        settings.setString(testKey, ' StringValue ');
        System.assertEquals('StringValue', settings.getString(testKey));
    }

    testmethod public static void test_setInteger() {
        settings.setInteger(testKey, 10);
        System.assertEquals(10, settings.getInteger(testKey));

        settings.setInteger(testKey, 20);
        System.assertEquals(20, settings.getInteger(testKey));

        settings.setInteger(testKey, null);
        System.assertEquals(30, settings.getInteger(testKey, 30));
    }

    testmethod public static void test_getInteger() {
        
        try {
            settings.getInteger(testKey);
            System.assert(false, 'Expected an exception');
        } catch (SettingsException e) {
        }
        
        System.assertEquals(10, settings.getInteger(testKey, 10));
		
		settings.setInteger(testKey, 115);
        System.assertEquals(115, settings.getInteger(testKey));
        System.assertEquals(115, settings.getInteger(testKey, 10));
    }

    testmethod public static void test_setDecimal() {
        settings.setDecimal(testKey, 10.99);
        System.assertEquals(10.99, settings.getDecimal(testKey));

        settings.setDecimal(testKey, 20.05);
        System.assertEquals(20.05, settings.getDecimal(testKey));

        settings.setDecimal(testKey, null);
        System.assertEquals(30.34, settings.getDecimal(testKey, 30.34));
    }

    testmethod public static void test_getDecimal() {
        
        try {
            settings.getDecimal(testKey);
            System.assert(false, 'Expected an exception');
        } catch (SettingsException e) {
        }
        
        System.assertEquals(10.99, settings.getDecimal(testKey, 10.99));
		
		settings.setDecimal(testKey, 115.23);
        System.assertEquals(115.23, settings.getDecimal(testKey));
        System.assertEquals(115.23, settings.getDecimal(testKey, 10.99));
    }

    testmethod public static void test_setBoolean() {
        settings.setBoolean(testKey, true);
        System.assertEquals(true, settings.getBoolean(testKey));

        settings.setBoolean(testKey, false);
        System.assertEquals(false, settings.getBoolean(testKey));

        settings.setBoolean(testKey, null);
        System.assertEquals(false, settings.getBoolean(testKey, false));
    }

    testmethod public static void test_getBoolean() {        
        try {
            settings.getBoolean(testKey);
            System.assert(false);
        } catch (SettingsException e) {
        }
        
        System.assertEquals(true, settings.getBoolean(testKey, true));
        settings.setBoolean(testKey, false);
        System.assertEquals(false, settings.getBoolean(testKey));
        System.assertEquals(false, settings.getBoolean(testKey, true));
    }

    testmethod public static void test_setDate() {
        settings.setDate(testKey, Date.valueOf('2014-11-20'));
        System.assertEquals(Date.valueOf('2014-11-20'), settings.getDate(testKey));

        settings.setDate(testKey, Date.valueOf('2015-11-20'));
        System.assertEquals(Date.valueOf('2015-11-20'), settings.getDate(testKey));

        settings.setDate(testKey, null);
        System.assertEquals(Date.valueOf('2014-11-20'), settings.getDate(testKey, Date.valueOf('2014-11-20')));
    }
    
    testmethod public static void test_getDate() {
        
        try {
            settings.getDate(testKey);
            System.assert(false);
        } catch (SettingsException e) {
        }
        
        System.assertEquals(Date.valueOf('2014-11-20'), settings.getDate(testKey, Date.valueOf('2014-11-20')));
		settings.setDate(testKey, Date.valueOf('2010-09-28'));        
        
        System.assertEquals(Date.valueOf('2010-09-28'), settings.getDate(testKey));
        System.assertEquals(Date.valueOf('2010-09-28'), settings.getDate(testKey, Date.valueOf('2014-11-20')));
    }
    
    testmethod public static void test_setDateTime() {
        DateTime dt = DateTime.now();
        settings.setDateTime(testKey, dt);
        System.assertEquals(dt, settings.getDateTime(testKey));

        settings.setDateTime(testKey, null);
        System.assertEquals(null, settings.getDateTime(testKey, null));
    }

    testmethod public static void test_getDateTime() {
        
        try {
            settings.getDatetime(testKey);
            System.assert(false);
        } catch (SettingsException e) {
        }
        
        DateTime currentTime = DateTime.now();
        System.assertEquals(currentTime, settings.getDateTime(testKey, currentTime));
        
		settings.setDateTime(testKey, parseIsoDateTime('2015-11-26T05:52:39Z'));
        System.assertEquals(parseIsoDateTime('2015-11-26T05:52:39Z'), settings.getDateTime(testKey));
    }

    testmethod public static void test_setList() {
        settings.setList(testKey, new List<String>{'Value1', 'Value2'});
  		List<String> values = settings.getList(testKey);
        System.assertEquals(2, values.size());
        System.assertEquals('Value1', values.get(0));
        System.assertEquals('Value2', values.get(1));
		
		//Set values with ,        
        settings.setList(testKey, new List<String>{' Value1,foo ', ' Value2,bar '});
  		values = settings.getList(testKey);
        System.assertEquals(2, values.size());
        
        //Comma should be preserved and values must be trimmed
        System.assertEquals('Value1,foo', values.get(0));
        System.assertEquals('Value2,bar', values.get(1));
    }

    testmethod public static void test_getList() {
        try {
            settings.getList(testKey);
            System.assert(false);
        } catch (SettingsException e) {
        }
        
        System.assertEquals('Value1', settings.getList(testKey, new String[]{'Value1'}).get(0));
        settings.setList(testKey, new List<String>{'Value1', 'Value2'});
        
        System.assertEquals(2, settings.getList(testKey).size());
        System.assertEquals('Value2', settings.getList(testKey).get(1));
    }
    
    testmethod public static void test_setSet() {
        settings.setSet(testKey, new Set<String>{'Value1', 'Value2', 'Value2'});
  		Set<String> values = settings.getSet(testKey);
        System.assertEquals(2, values.size());
        System.assertEquals(true, values.contains('Value1'));
        System.assertEquals(true, values.contains('Value2'));
		
		//Set values with comma and spaces
        settings.setSet(testKey, new Set<String>{' Value1,foo ', ' Value2,bar '});
  		values = settings.getSet(testKey);
        System.assertEquals(2, values.size());
        
        //Comma should be preserved and values must be trimmed
        System.assertEquals(true, values.contains('Value1,foo'));
        System.assertEquals(true, values.contains('Value2,bar'));
    }

    testmethod public static void test_getSet() {
        try {
            settings.getSet(testKey);
            System.assert(false);
        } catch (SettingsException e) {
        }
        
        System.assertEquals(true, settings.getSet(testKey, new Set<String>{'Value1'}).contains('Value1'));
        settings.setSet(testKey, new Set<String>{'Value1', 'Value2'});
        
        System.assertEquals(2, settings.getSet(testKey).size());
        System.assertEquals(true, settings.getSet(testKey).contains('Value2'));
    }

    testmethod public static void test_getStringMap() {
        try {
            settings.getMap(testKey);
            System.assert(false);
        } catch (SettingsException e) {
        }
        
        System.assertEquals('Value1', settings.getMap(testKey, new Map<String,String>{'testKey1'=>'Value1'}).get('testKey1'));
        settings.setMap(testKey, new Map<String, String>{'testKey1'=>'Value1', 'testKey2' => 'Value2'});

        System.assertEquals(2, settings.getMap(testKey).size());
        System.assertEquals('Value2', settings.getMap(testKey).get('testKey2'));
        
        //Test getting partial map foo=>bar|bob=>
        Settings__c sett = Settings__c.getValues(testKey);
        sett.Value__c = 'foo=>bar|bob=>|test=>value';
        update sett;
            
        System.assertEquals(3, settings.getMap(testKey).size());
        System.assertEquals('bar', settings.getMap(testKey).get('foo'));
        System.assertEquals(null, settings.getMap(testKey).get('bob'));
        System.assertEquals('value', settings.getMap(testKey).get('test'));
    }
    
    public class TestBean {
        public String name {get;set;}
        public Integer age {get;set;}
        public Date dob {get;set;}
        public boolean citizen {get;set;}
        public Decimal salary {get;set;}
    }
    
    testmethod public static void test_setJson() {
		TestBean bean = new TestBean();
        bean.name = 'John';
        bean.age = 30;
        bean.dob = Date.newInstance(2010, 07, 23);
        bean.citizen = true;
        bean.salary = 100.45;
        
        settings.setJson(testKey, bean);
        TestBean bean2 = (TestBean) settings.getJson(testKey, TestBean.class);
        System.assertEquals(bean.name, bean2.name);
        System.assertEquals(bean.age, bean2.age);
        System.assertEquals(bean.dob, bean2.dob);
        System.assertEquals(bean.citizen, bean2.citizen);
        System.assertEquals(bean.salary, bean2.salary);
		
        Map<String, Object> jsonMap = settings.getJson(testKey);
        System.assertEquals('John', jsonMap.get('name'));
        System.assertEquals(30, jsonMap.get('age'));
        System.assertEquals('2010-07-23', jsonMap.get('dob'));
        System.assertEquals(true, jsonMap.get('citizen'));
        System.assertEquals(100.45, jsonMap.get('salary'));

        settings.setJson(testKey, null);
        System.assertEquals(null, settings.getJson(testKey, (Map<String, Object>) null));
        System.assertEquals(null, settings.getJson(testKey, TestBean.class, null));
    }

    testmethod public static void test_getJson() {
        
        try {
            settings.getJson(testKey);
            System.assert(false);
        } catch (SettingsException e) {
        }
        
        try {
            settings.getJson(testKey, TestBean.class);
            System.assert(false);
        } catch (SettingsException e) {
        }
    }
    
    testmethod public static void test_bigJson() {
       	TestBean bean = new TestBean();
        bean.name = createText('0', 500);
        bean.age = 30;
        bean.dob = Date.newInstance(2010, 07, 23);
        bean.citizen = true;
        bean.salary = 100.45;
        
        settings.setJson(testKey, bean);
        TestBean bean2 = (TestBean) settings.getJson(testKey, TestBean.class);
        System.assertEquals(bean.name, bean2.name);
        System.assertEquals(bean.age, bean2.age);
        System.assertEquals(bean.dob, bean2.dob);
        System.assertEquals(bean.citizen, bean2.citizen);
        System.assertEquals(bean.salary, bean2.salary);

    }

    testmethod public static void test_clearEnvSpecificSettings() {
        
        Settings__c setting = new Settings__c(Name=testKey, Value__c='Value', Env_Specific__c=true);
        insert setting;
        
        settings.clearEnvSpecificValues();
        
        System.assertEquals(null, settings.getString(testKey, null));
    }
    
    testmethod public static void testRemoveNullValues() {
        Settings__c setting = new Settings__c(Name='Test', Value__c='null');
        insert setting;
        
        settings.clearNullValues();
		
        System.assertEquals(null, settings.getString('Test', null));
		
    }

    testmethod public static void test_setLongString() {
        String longString = createString(25500);
		settings.setString(testKey, longString);
        System.assertEquals(longString, settings.getString(testKey));
		sf.assert.that(countKeys(testKey)).isEqualsTo(100);
        settings.setString(testKey, null);
        
        //By setting to short key now, we are ensuring that split keys are handled appropriately
        String shortString = 'MIIFDjBABgkqhkiG9w0BBQ0wMzAbBgkq';
		settings.setString(testKey, shortString);
        System.assertEquals(shortString, settings.getString(testKey));
        sf.assert.that(countKeys(testKey)).isEqualsTo(1);
    }

    testmethod public static void test_setVariousKeyLength() {
        for (Integer i = 1; i <= 150; i+=150) {
            String longString = createString(i);
            settings.setString(testKey + i, longString);
            System.assertEquals(longString, settings.getString(testKey + i));
        }
    }

    testmethod public static void test_setLongMap() {
        settings.setMap(testKey, new Map<String, String>{'first' => createText('1', 400), 'second' => createText('0', 200)});
		Map<String, String> newMap = settings.getMap(testKey);
        System.assertEquals(createText('1', 400), newMap.get('first'));
        System.assertEquals(createText('0', 200), newMap.get('second'));
    }

    public static String createText(String input, Integer length) {
        String text = input;
        while(text.length() < length) {
            text += input;
        }
        
        return text.substring(0, length);
    }

    public static DateTime parseIsoDateTime(String dateTimeString) {
        if (String.isBlank(dateTimeString)) {
            return null;
        }
        return (DateTime)json.deserialize('"' + dateTimeString + '"', DateTime.class);
    }
}