@IsTest
public class JsonWriterTest {
    private static Utils u = new Utils();
	static Assert assert = sf.assert;
    
    testmethod public static void testJsonWriter() {
        System.assertEquals('{}', new JsonWriter().toJson());
        System.assertEquals('[]', new JsonWriter(true).toJson());
        System.assertEquals('{"key1":"value1"}', new JsonWriter().write('key1', 'value1').toJson());
        System.assertEquals('{"key1":{"key2":["value2"]}}', new JsonWriter().write('key1.key2[0]', 'value2').toJson());
        System.assertEquals('["value1","value2"]', new JsonWriter().write('[0]', 'value1').write('[1]', 'value2') .toJson());
        System.assertEquals('{\n  "key1" : "value1"\n}', new JsonWriter().write('key1', 'value1').toPrettyJson());
        //System.assertEquals('{"foo":{"bar":{"bob":"alice"},"fred":"velma"},"tom":"jerry"}', new JsonWriter().with('foo').with('bar').write('bob', 'alice').endWith().write('fred', 'velma').endWith().write('tom', 'jerry').toJson());
        
        try {
            //This should generate an error as first level we are trying to make an arry as well as object
            new JsonWriter().write('[0]', 'foo').write('foo', 'bar');
            System.assert(false, 'Supposed to throw an exception!');
        } catch (LibshareException e) {
            //ignore
        }
    }
    
    testmethod public static void testWriteLink() {
        System.assertEquals('{"_links":{"self":{"href":"http://www.example.org"}},"foo":"bar"}', 
                            new JsonWriter().write('foo', 'bar').writeSelfLink('http://www.example.org').toJson());        
        System.assertEquals('{"_links":{"partnerPortal":{"href":"http://www.example.org"}},"foo":"bar"}', 
                            new JsonWriter().write('foo', 'bar').writeLink('partnerPortal', 'http://www.example.org').toJson());        
    }
    
    testmethod public static void test_with() {
    	JsonWriter writer = new JsonWriter();
        writer.with('account').write('name', 'Boing');
        assert.that(writer.toJson()).isEqualsTo('{"account":{"name":"Boing"}}');
        
		writer = new JsonWriter();
        writer.with('account[0]').write('name', 'Boing');
        assert.that(writer.toJson()).isEqualsTo('{"account":[{"name":"Boing"}]}');
        
        writer.clearWith();
        writer.with('account[0]').write('name', 'Boing').endwith().write('email', 'foo@bar.com');
        assert.that(writer.toJson()).isEqualsTo('{"email":"foo@bar.com","account":[{"name":"Boing"}]}');

        writer = new JsonWriter();
        writer.with('account[0]').newWith('email[0]').write('email', 'foo@bar.com');
        assert.that(writer.toJson()).isEqualsTo('{"email":[{"email":"foo@bar.com"}]}');
    }
    
    testmethod public static void test_ignoreNulls() {
     	JsonWriter writer = new JsonWriter();
        writer.write('name', null);
        assert.that(writer.toJson()).isEqualsTo('{"name":null}');
        
        writer = new JsonWriter().ignoreNulls(true);
        writer.write('name', null);
        assert.that(writer.toJson()).isEqualsTo('{}');
	}
	
    testmethod public static void test_writeIfNotBlank() {
        JsonWriter writer = new JsonWriter().ignoreNulls(false);
        writer.writeIfNotBlank('name', null);
        assert.that(writer.toJson()).isEqualsTo('{}');

        writer.writeIfNotBlank('name', '');
        assert.that(writer.toJson()).isEqualsTo('{}');

        writer.writeIfNotBlank('name', ' ');
        assert.that(writer.toJson()).isEqualsTo('{}');

        writer.writeIfNotBlank('name', 'abc');
        assert.that(writer.toJson()).isEqualsTo('{"name":"abc"}');
        writer.write('name', ' ');
        assert.that(writer.toJson()).isEqualsTo('{"name":" "}');            
    }

    testmethod public static void test_writeIfNotNull() {
        JsonWriter writer = new JsonWriter().ignoreNulls(false);
        writer.writeIfNotNull('name', null);
        assert.that(writer.toJson()).isEqualsTo('{}');

        writer.writeIfNotNull('name', '');
        assert.that(writer.toJson()).isEqualsTo('{"name":""}');            

        writer.writeIfNotNull('name', ' ');
        assert.that(writer.toJson()).isEqualsTo('{"name":" "}');
    }

    testmethod public static void test_writeDates() {
        JsonWriter writer = new JsonWriter();
        writer.write('date', u.parseIsoDate('2017-01-01'));
        writer.write('datetime', u.parseIsoDateTime('2017-01-01T01:02:03Z'));
        assert.that(writer.toJson()).isEqualsTo('{"datetime":"2017-01-01T01:02:03Z","date":"2017-01-01"}');
    }
}