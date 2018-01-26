@IsTest
public class JsonMapperTest {
    private static Utils u = new Utils();
    
	static Assert assert = sf.assert;
    static String contactJson = '{' +
        '  "firstName": "John",' +
        '  "lastName": "Doe",' +
        '  "profile": {' +
        '    "avatar": "someavatar",' +
        '    "dob": "1975-01-01"' +
        '  },' +
        '  "education": [' +
        '    {' +
        '      "name": "Bachelour",' +
        '      "city": "Dallas"' +
        '    },' +
        '    {' +
        '      "name": "MBA",' +
        '      "city": "New York"' +
        '    }' +
        '  ],' +
        '  "email": [' +
        '    "foo@bar.com",' +
        '    "bob@alice.com"' +
        '  ],' +
        '  "account": {' +
        '    "name": "Datasert",' +
        '    "address": "150 Spear",' +
        '    "parent": {' +
        '      "name": "Datasert Inc",' +
        '      "address": "1 Main St"' +
        '    },' +
        '    "location": {' +
        '      "city": "San Francisco",' +
        '      "uses": [' +
        '        "all",' +
        '        "some"' +
        '      ]' +
        '    }' +
        '  }' +
        '}';
	    
    testmethod public static void test_jsonReader() {
        System.assertEquals(null, new JsonMapper('{}').getString('key1'));
        System.assertEquals(null, new JsonMapper('{}').getString('key1.key2'));
        System.assertEquals(null, new JsonMapper('{}').getString('key[0].value'));
        System.assertEquals(null, new JsonMapper('{}').getString('[0].value'));
        System.assertEquals(null, new JsonMapper('{}').getString('key.value[0]'));
        System.assertEquals(null, new JsonMapper('[]').getString('key.value[0]'));
        System.assertEquals(null, new JsonMapper('{"key1":["value1","value2"]}').getString('key1.value[0]'));
        
        System.assertEquals('value1', new JsonMapper('{"key1":"value1"}').getString('key1'));
        System.assertEquals('value2', new JsonMapper('{"key1":"value1", "key2":"value2"}').getString('key2'));
        System.assertEquals('value3', new JsonMapper('{"key1":"value1", "key2":"value2", "key3": {"key4":"value3"}}').getString('key3.key4'));
        System.assertEquals('value4', new JsonMapper('{"key1":"value1", "key2":"value2", "key3": {"key4":"value3"}, "key5": ["value4", "value5"]}')
                            .getString('key5[0]'));
        
        System.assertEquals('value6', new JsonMapper('{"key1":"value1", "key2":"value2", "key3": {"key4":"value3"}, "key5": ["value4", "value5", {"key6": "value6"}]}')
                            .getString('key5[2].key6'));

        System.assertEquals('value1', new JsonMapper('["value1", "value2"]').getString('[0]'));
        System.assertEquals('value2', new JsonMapper('["value1", "value2"]').getString('[1]'));
        
        JsonMapper reader = new JsonMapper('{"key0":true, "key1":"value1", "key2":"value2", "key3": {"key4":"value3"}, "key5": ["value4", "value5", {"key6": "value6"}], "key7": 123, "key8": 123.45}');
        JsonMapper reader2 = reader.getMapper('key3');
        System.assertEquals('value3', reader2.getString('key4'));
        System.assertEquals(3, reader.getList('key5').size());
        System.assertEquals(true, reader.getMapper('key5').isArray());
        System.assertEquals('value3', reader.getMap('key3').get('key4'));
        
        //System.assertEquals(null, reader.getBoolean('keynotexist'));
        System.assertEquals(true, reader.getBoolean('key0'));

        System.assertEquals(null, reader.getInteger('keynotexist'));
        System.assertEquals(123, reader.getInteger('key7'));

        System.assertEquals(null, reader.getDecimal('keynotexist'));
        System.assertEquals(123.45, reader.getDecimal('key8'));
        
        System.assert(reader.getObject() != null);
    }

    testmethod public static void test_readDates() {
        JsonMapper reader = new JsonMapper('{"dateTimeKey": "2015-12-20T09:20:30Z", "date": "2017-01-01"}');
        System.assertEquals(DateTime.newInstanceGmt(2015, 12, 20, 09, 20, 30), reader.getDateTime('dateTimeKey'));
        System.assertEquals(Date.newInstance(2017, 01, 01), reader.getDate('date'));
    }
    
    testmethod public static void testRootList() {
        System.assertEquals(0, new JsonMapper('[]').getList(null).size());
        System.assertEquals(1, new JsonMapper('[""]').getList(null).size());
    }

    testmethod public static void test_hasKey() {
        JsonMapper reader = new JsonMapper('{"foo":"bar"}');
        System.assertEquals(true, reader.hasKey('foo'));
        System.assertEquals(false, reader.hasKey('bar'));
        System.assertEquals(false, reader.hasKey('foo.bar'));
		
        reader = new JsonMapper(contactJson);
        assert.that(reader.hasKey('education[0].name')).isEqualsTo(true);
        assert.that(reader.hasKey('education[1].name')).isEqualsTo(true);
        assert.that(reader.hasKey('education[2].name')).isEqualsTo(false);
    }

    testmethod public static void testToJson() {
        JsonMapper reader = new JsonMapper('{"foo":"bar"}');
        System.assertEquals('{"foo":"bar"}', reader.toJson());
        System.assertEquals('{\n  "foo" : "bar"\n}', reader.toPrettyJson());

        reader = new JsonMapper((Object) null);
        System.assertEquals('{ }', reader.toPrettyJson());
    }

    testmethod public static void testGetBoolean() {
        JsonMapper reader = new JsonMapper('{"foo":true}');
        System.assertEquals(false, reader.getBoolean('foo1'));
        System.assertEquals(true, reader.getBoolean('foo'));
    }
    
    testmethod public static void testWith() {
        JsonMapper reader = new JsonMapper('{"foo":"bar"}');
        System.assertEquals('bar', reader.getWithKey('bar'));
        
        reader.with(0);
        System.assertEquals('[0].bar', reader.getWithKey('bar'));

        reader.with(1);
        System.assertEquals('[0].[1].bar', reader.getWithKey('bar'));
		
        reader.endWith();
        System.assertEquals('[0].bar', reader.getWithKey('bar'));
        
        reader.newWith(1);
        System.assertEquals('[1].bar', reader.getWithKey('bar'));

        reader.newWith('foo');
        System.assertEquals('foo.bar', reader.getWithKey('bar'));

        reader.clearWith();
        System.assertEquals('bar', reader.getWithKey('bar'));
    }
    
    testmethod public static void testGetString() {
        JsonMapper reader = new JsonMapper('{"foo":"bar", "bob":"alice"}');
        System.assertEquals('bar', reader.getString('foo'));
        System.assertEquals('foo2', reader.getString('foo2', 'foo2'));
    }

    testmethod public static void test_getStringList() {
        JsonMapper reader = new JsonMapper('{"foo":["foo1", "foo2"]}');
        System.assertEquals(2, reader.getStringList('foo').size());
        
        reader = new JsonMapper('["foo1", "foo2"]');
        System.assertEquals(2, reader.getStringList('').size()); 
    }

    testmethod public static void test_prefixes() {
 		JsonMapper reader = new JsonMapper(contactJson);
        assert.that(reader.with('account').getString('name')).isEqualsTo('Datasert');
        
        reader.clearWith();
        assert.that(reader.with('account').endWith().with('profile').getString('dob')).isEqualsTo('1975-01-01');

        reader.clearWith();
        assert.that(reader.with('education[0]').getString('name')).isEqualsTo('Bachelour');
        assert.that(reader.newWith('education[1]').getString('name')).isEqualsTo('MBA');
        
        reader = new JsonMapper('[{"name": "BA"}, {"name": "MA"}]');
        assert.that(reader.newWith('[0]').getString('name')).isEqualsTo('BA');
        assert.that(reader.newWith('[1]').getString('name')).isEqualsTo('MA');
        
    }
    
    testmethod public static void test_jsonMapper() {
        System.assertEquals('{}', new JsonMapper().toJson());
        System.assertEquals('[]', new JsonMapper(new List<Object>()).toJson());
        System.assertEquals('{"key1":"value1"}', new JsonMapper().set('key1', 'value1').toJson());
        System.assertEquals('{"key1":{"key2":["value2"]}}', new JsonMapper().set('key1.key2[0]', 'value2').toJson());
        System.assertEquals('["value1","value2"]', new JsonMapper().set('[0]', 'value1').set('[1]', 'value2') .toJson());
        System.assertEquals('{\n  "key1" : "value1"\n}', new JsonMapper().set('key1', 'value1').toPrettyJson());
        //System.assertEquals('{"foo":{"bar":{"bob":"alice"},"fred":"velma"},"tom":"jerry"}', new JsonMapper().with('foo').with('bar').set('bob', 'alice').endWith().set('fred', 'velma').endWith().set('tom', 'jerry').toJson());
        
        try {
            //This should generate an error as first level we are trying to make an arry as well as object
            new JsonMapper().set('[0]', 'foo').set('foo', 'bar');
            System.assert(false, 'Supposed to throw an exception!');
        } catch (LibshareException e) {
            //ignore
        }
    }
    
    testmethod public static void testWriteLink() {
        System.assertEquals('{"_links":{"self":{"href":"http://www.example.org"}},"foo":"bar"}', 
                            new JsonMapper().set('foo', 'bar').setSelfLink('http://www.example.org').toJson());        
        System.assertEquals('{"_links":{"partnerPortal":{"href":"http://www.example.org"}},"foo":"bar"}', 
                            new JsonMapper().set('foo', 'bar').setLink('partnerPortal', 'http://www.example.org').toJson());        
    }
    
    testmethod public static void test_with() {
    	JsonMapper writer = new JsonMapper();
        writer.with('account').set('name', 'Boing');
        assert.that(writer.toJson()).isEqualsTo('{"account":{"name":"Boing"}}');
        
		writer = new JsonMapper();
        writer.with('account[0]').set('name', 'Boing');
        assert.that(writer.toJson()).isEqualsTo('{"account":[{"name":"Boing"}]}');
        
        writer.clearWith();
        writer.with('account[0]').set('name', 'Boing').endwith().set('email', 'foo@bar.com');
        assert.that(writer.toJson()).isEqualsTo('{"email":"foo@bar.com","account":[{"name":"Boing"}]}');

        writer = new JsonMapper();
        writer.with('account[0]').newWith('email[0]').set('email', 'foo@bar.com');
        assert.that(writer.toJson()).isEqualsTo('{"email":[{"email":"foo@bar.com"}]}');
    }
    
    testmethod public static void test_ignoreNulls() {
     	JsonMapper writer = new JsonMapper();
        writer.set('name', null);
        assert.that(writer.toJson()).isEqualsTo('{"name":null}');
        
        writer = new JsonMapper().ignoreNulls(true);
        writer.set('name', null);
        assert.that(writer.toJson()).isEqualsTo('{}');
	}
	
    testmethod public static void test_setIfNotBlank() {
        JsonMapper writer = new JsonMapper().ignoreNulls(false);
        writer.setIfNotBlank('name', null);
        assert.that(writer.toJson()).isEqualsTo('{}');

        writer.setIfNotBlank('name', '');
        assert.that(writer.toJson()).isEqualsTo('{}');

        writer.setIfNotBlank('name', ' ');
        assert.that(writer.toJson()).isEqualsTo('{}');

        writer.setIfNotBlank('name', 'abc');
        assert.that(writer.toJson()).isEqualsTo('{"name":"abc"}');
        writer.set('name', ' ');
        assert.that(writer.toJson()).isEqualsTo('{"name":" "}');            
    }

    testmethod public static void test_writeIfNotNull() {
        JsonMapper writer = new JsonMapper().ignoreNulls(false);
        writer.setIfNotNull('name', null);
        assert.that(writer.toJson()).isEqualsTo('{}');

        writer.setIfNotNull('name', '');
        assert.that(writer.toJson()).isEqualsTo('{"name":""}');            

        writer.setIfNotNull('name', ' ');
        assert.that(writer.toJson()).isEqualsTo('{"name":" "}');
    }

    testmethod public static void test_writeDates() {
        JsonMapper writer = new JsonMapper();
        writer.set('date', u.parseIsoDate('2017-01-01'));
        writer.set('datetime', u.parseIsoDateTime('2017-01-01T01:02:03Z'));
        assert.that(writer.toJson()).isEqualsTo('{"datetime":"2017-01-01T01:02:03Z","date":"2017-01-01"}');
    }
    
    testmethod public static void test_readAndWrite() {
        JsonMapper writer = new JsonMapper();
        writer.set('[0].foo', 'bar');
        assert.that(writer.getString('[0].foo')).isEqualsTo('bar');
    }
}