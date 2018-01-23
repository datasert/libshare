@IsTest
public class JsonReaderTest {
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
	    
    testmethod public static void testJsonReader() {
        System.assertEquals(null, new JsonReader('{}').getString('key1'));
        System.assertEquals(null, new JsonReader('{}').getString('key1.key2'));
        System.assertEquals(null, new JsonReader('{}').getString('key[0].value'));
        System.assertEquals(null, new JsonReader('{}').getString('[0].value'));
        System.assertEquals(null, new JsonReader('{}').getString('key.value[0]'));
        System.assertEquals(null, new JsonReader('[]').getString('key.value[0]'));
        System.assertEquals(null, new JsonReader('{"key1":["value1","value2"]}').getString('key1.value[0]'));
        
        System.assertEquals('value1', new JsonReader('{"key1":"value1"}').getString('key1'));
        System.assertEquals('value2', new JsonReader('{"key1":"value1", "key2":"value2"}').getString('key2'));
        System.assertEquals('value3', new JsonReader('{"key1":"value1", "key2":"value2", "key3": {"key4":"value3"}}').getString('key3.key4'));
        System.assertEquals('value4', new JsonReader('{"key1":"value1", "key2":"value2", "key3": {"key4":"value3"}, "key5": ["value4", "value5"]}')
                            .getString('key5[0]'));
        
        System.assertEquals('value6', new JsonReader('{"key1":"value1", "key2":"value2", "key3": {"key4":"value3"}, "key5": ["value4", "value5", {"key6": "value6"}]}')
                            .getString('key5[2].key6'));

        System.assertEquals('value1', new JsonReader('["value1", "value2"]').getString('[0]'));
        System.assertEquals('value2', new JsonReader('["value1", "value2"]').getString('[1]'));
        
        JsonReader reader = new JsonReader('{"key0":true, "key1":"value1", "key2":"value2", "key3": {"key4":"value3"}, "key5": ["value4", "value5", {"key6": "value6"}], "key7": 123, "key8": 123.45}');
        JsonReader reader2 = reader.getReader('key3');
        System.assertEquals('value3', reader2.getString('key4'));
        System.assertEquals(3, reader.getList('key5').size());
        System.assertEquals(true, reader.getReader('key5').isArray());
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
        JsonReader reader = new JsonReader('{"dateTimeKey": "2015-12-20T09:20:30Z", "date": "2017-01-01"}');
        System.assertEquals(DateTime.newInstanceGmt(2015, 12, 20, 09, 20, 30), reader.getDateTime('dateTimeKey'));
        System.assertEquals(Date.newInstance(2017, 01, 01), reader.getDate('date'));
    }
    
    testmethod public static void testRootList() {
        System.assertEquals(0, new JsonReader('[]').getList(null).size());
        System.assertEquals(1, new JsonReader('[""]').getList(null).size());
    }

    testmethod public static void test_hasKey() {
        JsonReader reader = new JsonReader('{"foo":"bar"}');
        System.assertEquals(true, reader.hasKey('foo'));
        System.assertEquals(false, reader.hasKey('bar'));
        System.assertEquals(false, reader.hasKey('foo.bar'));
		
        reader = new JsonReader(contactJson);
        assert.that(reader.hasKey('education[0].name')).isEqualsTo(true);
        assert.that(reader.hasKey('education[1].name')).isEqualsTo(true);
        assert.that(reader.hasKey('education[2].name')).isEqualsTo(false);
    }

    testmethod public static void testToJson() {
        JsonReader reader = new JsonReader('{"foo":"bar"}');
        System.assertEquals('{"foo":"bar"}', reader.toJson());
        System.assertEquals('{\n  "foo" : "bar"\n}', reader.toPrettyJson());

        reader = new JsonReader((Object) null);
        System.assertEquals('{ }', reader.toPrettyJson());
    }

    testmethod public static void testGetBoolean() {
        JsonReader reader = new JsonReader('{"foo":true}');
        System.assertEquals(false, reader.getBoolean('foo1'));
        System.assertEquals(true, reader.getBoolean('foo'));
    }
    
    testmethod public static void testWith() {
        JsonReader reader = new JsonReader('{"foo":"bar"}');
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
        JsonReader reader = new JsonReader('{"foo":"bar", "bob":"alice"}');
        System.assertEquals('bar', reader.getString('foo'));
        System.assertEquals('foo2', reader.getString('foo2', 'foo2'));
    }

    testmethod public static void test_getStringList() {
        JsonReader reader = new JsonReader('{"foo":["foo1", "foo2"]}');
        System.assertEquals(2, reader.getStringList('foo').size());
        
        reader = new JsonReader('["foo1", "foo2"]');
        System.assertEquals(2, reader.getStringList('').size()); 
    }

    testmethod public static void test_prefixes() {
 		JsonReader reader = new JsonReader(contactJson);
        assert.that(reader.with('account').getString('name')).isEqualsTo('Datasert');
        
        reader.clearWith();
        assert.that(reader.with('account').endWith().with('profile').getString('dob')).isEqualsTo('1975-01-01');

        reader.clearWith();
        assert.that(reader.with('education[0]').getString('name')).isEqualsTo('Bachelour');
        assert.that(reader.newWith('education[1]').getString('name')).isEqualsTo('MBA');
        
        reader = new JsonReader('[{"name": "BA"}, {"name": "MA"}]');
        assert.that(reader.newWith('[0]').getString('name')).isEqualsTo('BA');
        assert.that(reader.newWith('[1]').getString('name')).isEqualsTo('MA');
        
    }
}