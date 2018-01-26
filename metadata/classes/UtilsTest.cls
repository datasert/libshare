@IsTest
public class UtilsTest {
	static Utils u = new Utils();
    static Assert assert = sf.assert;

    testmethod public static void test_getStackTrace() {
        assert.that(u.getStackTrace(null)).isequalsTo(null);
        try {
            throwEx0();
        } catch (Exception e) {
			assert.that(u.getStackTrace(e)).isNotNull();
            assert.that(u.getRootCause(e).getMessage()).isEqualsTo('Divide by 0');
        }
    }
    private static void throwEx0() {
        try {
            throwEx1();
        } catch (Exception e) {
            throw new LibshareException('Exception while calling throwEx1', e);
        }
    }

    private static void throwEx1() {
        try {
            throwEx2();
        } catch (Exception e) {
            throw new LibshareException('Exception while calling throwEx2', e);
        }
    }
    
    private static void throwEx2() {
		Integer value = 100 / 0;        
    }
    
    testmethod public static void test_getCallingClassAndMethod() {
		callTest();
    }
    
    private static void callTest() {
        assert.that(u.getCallingClassAndMethod()[0]).isEqualsTo('lib.UtilsTest');
        assert.that(u.getCallingClassAndMethod()[1]).isEqualsTo('test_getCallingClassAndMethod');
    }

    testmethod public static void test_toBoolean() {
    	assert.that(u.toBoolean(null)).isFalse();
    	assert.that(u.toBoolean(null, true)).isTrue();
    	assert.that(u.toBoolean('')).isFalse();
    	assert.that(u.toBoolean(true)).isTrue();
    	assert.that(u.toBoolean('true')).isTrue();
    }
    
    testmethod public static void test_encode() {
        assert.that(u.encode(null, null)).isEqualsTo(null);
        assert.that(u.encode('foo bar', 'url')).isEqualsTo('foo+bar');
        assert.that(u.encode('foo < bar', 'xml')).isEqualsTo('foo &lt; bar');
        assert.that(u.encode('foo < bar', 'html')).isEqualsTo('foo &lt; bar');
        assert.that(u.encode('abc123!?$*&()\'-=@~', 'base64')).isEqualsTo('YWJjMTIzIT8kKiYoKSctPUB+');
        assert.that(u.encode('abc123!?$*&()\'-=@~', 'base64urlsafe')).isEqualsTo('YWJjMTIzIT8kKiYoKSctPUB-');

        try {
            u.encode('foo', null);
            assert.expectedException();
        } catch (Exception e) {}

        try {
            u.encode('foo', 'asasf');
            assert.expectedException();
        } catch (Exception e) {}
    }
    
    testmethod public static void test_encodeDecodeUrl() {
        assert.that(u.encodeUrl('hello world')).isEqualsTo('hello+world');
        assert.that(u.encodeUrl(null)).isEqualsTo(null);
        assert.that(u.decodeUrl('hello%20world')).isEqualsTo('hello world');
        assert.that(u.decodeUrl('hello+world')).isEqualsTo('hello world');
        assert.that(u.decodeUrl(null)).isEqualsTo(null);
    }    

    testmethod public static void test_encodeDecodeXml() {
        assert.that(u.encodeXml('hello < world')).isEqualsTo('hello &lt; world');
        assert.that(u.encodeXml(null)).isEqualsTo(null);
        assert.that(u.decodeXml('hello &lt; world')).isEqualsTo('hello < world');
        assert.that(u.decodeXml(null)).isEqualsTo(null);
    }    

    testmethod public static void test_encodeDecodeHtml() {
        assert.that(u.encodeHtml('hello < world')).isEqualsTo('hello &lt; world');
        assert.that(u.encodeHtml(null)).isEqualsTo(null);
        assert.that(u.decodeHtml('hello &lt; world')).isEqualsTo('hello < world');
        assert.that(u.decodeHtml(null)).isEqualsTo(null);
    }    

    testmethod public static void test_encodeDecodeBase64() {
        assert.that(u.encodeBase64('this is a test phrase')).isEqualsTo('dGhpcyBpcyBhIHRlc3QgcGhyYXNl');
        assert.that(u.encodeBase64(Blob.valueOf('this is a test phrase'))).isEqualsTo('dGhpcyBpcyBhIHRlc3QgcGhyYXNl');
        assert.that(u.encodeBase64((String) null)).isEqualsTo(null);
        assert.that(u.encodeBase64((Blob) null)).isEqualsTo(null);
        assert.that(u.decodeBase64('dGhpcyBpcyBhIHRlc3QgcGhyYXNl')).isEqualsTo('this is a test phrase');
        assert.that(u.decodeBase64(null)).isEqualsTo(null);
        assert.that(u.decodeBase64AsBlob('dGhpcyBpcyBhIHRlc3QgcGhyYXNl')).isEqualsTo(Blob.valueOf('this is a test phrase'));
        assert.that(u.decodeBase64AsBlob(null)).isEqualsTo(null);
        assert.that(u.encodeBase64UrlSafe('this is a test phrase')).isEqualsTo('dGhpcyBpcyBhIHRlc3QgcGhyYXNl');

        assert.that(u.encodeBase64('abc123!?$*&()\'-=@~')).isEqualsTo('YWJjMTIzIT8kKiYoKSctPUB+');
        assert.that(u.decodeBase64('YWJjMTIzIT8kKiYoKSctPUB+')).isEqualsTo('abc123!?$*&()\'-=@~');
        assert.that(u.encodeBase64UrlSafe('abc123!?$*&()\'-=@~')).isEqualsTo('YWJjMTIzIT8kKiYoKSctPUB-');
        assert.that(u.encodeBase64UrlSafe((String) null)).isEqualsTo(null);
        assert.that(u.encodeBase64UrlSafe((Blob) null)).isEqualsTo(null);
    }
    
    testmethod public static void test_toInteger() {
        assert.that(u.toInteger(null, 10)).isEqualsTo(10);
        assert.that(u.toInteger(null, null, null, null)).isEqualsTo(null);
        assert.that(u.toInteger(10, null, null, null)).isEqualsTo(10);
        assert.that(u.toInteger(null, null, 50, null)).isEqualsTo(50);
        assert.that(u.toInteger(10, null, 50, null)).isEqualsTo(10);
        assert.that(u.toInteger(10, 20, 50, null)).isEqualsTo(20);
        assert.that(u.toInteger(100, 20, 50, 80)).isEqualsTo(80);
    }
    
    testmethod public static void test_replaceVars() {
        System.assertEquals(null, u.replaceVars(null, (String) null, null));
        System.assertEquals(null, u.replaceVars(null, 'key', 'value'));
        System.assertEquals('Value=', u.replaceVars('Value=${key}', 'key', null));
        System.assertEquals('Value=value', u.replaceVars('Value=${key}', 'key', 'value'));
        System.assertEquals('Value=${key}', u.replaceVars('Value=${key}', 'Key', 'value'));
        System.assertEquals('Value=valueAfterValue', u.replaceVars('Value=${key}AfterValue', 'key', 'value'));
        System.assertEquals('John John', u.replaceVars('${firstName} ${firstName}', 'firstName', 'John'));
        System.assertEquals('John Doe', u.replaceVars('${firstName} ${lastName}', new Map<String, Object>{'firstName' => 'John', 'lastName' => 'Doe'}));
        System.assertEquals('${firstName} ${lastName}', u.replaceVars('${firstName} ${lastName}', new Map<String, Object>()));
        System.assertEquals('Value=hello+world', u.replaceVars('Value=${Key}', 'Key', 'hello world', 'url'));
    }     
    
    testmethod public static void test_toString() {
        assert.that(u.toString(null)).isEqualsTo(null);
        assert.that(u.toString('test')).isEqualsTo('test');
        assert.that(u.toString(DateTime.newInstanceGmt(2017, 1, 1, 0, 0, 0))).isEqualsTo('2017-01-01T00:00:00Z');
        assert.that(u.toString(Date.newInstance(2017, 1, 1))).isEqualsTo('2017-01-01');
    }
    
    testmethod public static void test_parseIsoDateTime() {
        System.assertEquals(null, u.parseIsoDateTime(null));

        DateTime time1 = u.parseIsoDateTime('2000-01-20T01:02:03Z');
        System.assertEquals(2000, time1.year());
        System.assertEquals(01, time1.month());
        System.assertEquals(19, time1.day());
        System.assertEquals(17, time1.hour());
        System.assertEquals(02, time1.minute());
        System.assertEquals(03, time1.second());
    }
    
    testmethod public static void test_formatIsoDateTime() {
        Datetime myDate = datetime.newInstanceGmt(2008, 12, 1, 12, 30, 2);
        System.assertEquals('2008-12-01T12:30:02Z', u.formatIsoDateTime(myDate));
        System.assertEquals(null, u.formatIsoDateTime(null));
    }

    testmethod public static void test_parseIsoDate() {
        System.assertEquals(null, u.parseIsoDate(null));

        Date time1 = u.parseIsoDate('2000-01-20');
        System.assertEquals(2000, time1.year());
        System.assertEquals(01, time1.month());
        System.assertEquals(20, time1.day());
    }
    
    testmethod public static void test_formatIsoDate() {
        Datetime myDate = datetime.newInstanceGmt(2008, 12, 1, 12, 30, 2);
        System.assertEquals('2008-12-01', u.formatIsoDate(myDate.date()));
        System.assertEquals(null, u.formatIsoDate(null));
    }
    
    testmethod public static void test_getCurrentDateTime() {
        System.assertEquals(DateTime.now(), u.now());
        TestUtils.setCurrentDateTime(Datetime.newInstance(2008, 12, 1, 12, 30, 2));
        System.assertEquals(Datetime.newInstance(2008, 12, 1, 12, 30, 2), u.now());
    }

    testmethod public static void test_getCurrentDate() {
        System.assertEquals(Date.today(), u.today());
        TestUtils.setCurrentDate(date.parse('12/27/2009'));
        System.assertEquals(date.parse('12/27/2009'), u.today());
    }
    
    testmethod public static void test_diffInDays() {
        DateTime now = DateTime.now();
        System.assertEquals(0, u.diffInDays(now, now));
        System.assertEquals(0, u.diffInDays(now, now.addHours(23)));
        System.assertEquals(1, u.diffInDays(now, now.addHours(24)));
        System.assertEquals(1, u.diffInDays(now.addHours(24), now));
        System.assertEquals(null, u.diffInDays(now, null));
        System.assertEquals(null, u.diffInDays(null, now));
        System.assertEquals(null, u.diffInDays(null, null));
    }
    
    testmethod public static void test_pageMessages() {
        LibshareException be =new LibshareException('Business Message1');
        LibshareException se =new LibshareException('Business Message2');
        
        u.addPageError(be);
        u.addPageError(se);
        
        System.assertEquals(be.getMessage(), u.getPageErrors().get(0).getSummary());
        System.assertEquals(se.getMessage(), u.getPageErrors().get(1).getSummary());
        System.assertEquals(2, u.getPageErrors().size());
        
        u.addPageError('Error Message');
        System.assertEquals(3, u.getPageErrors().size());

        System.assertEquals(0, u.getPageInfos().size());
        u.addPageInfo('Info Message');
        System.assertEquals(1, u.getPageInfos().size());
    }
    
    testmethod public static void test_getPageParams() {
        
        //No page reference.
        System.assertEquals(null, u.getPageParam('key'));
        
        Test.setCurrentPage(new PageReference('/TestPage?key=value'));
        System.assertEquals('value', u.getPageParam('key'));

        Test.setCurrentPage(new PageReference('/TestPage?key='));
        System.assertEquals('', u.getPageParam('key'));

        //+ indicates a space
        Test.setCurrentPage(new PageReference('/TestPage?key=+++'));
        System.assertEquals('   ', u.getPageParam('key'));

        Test.setCurrentPage(new PageReference('/TestPage'));
        System.assertEquals(null, u.getPageParam('key'));
        
        //With default value
        Test.setCurrentPage(new PageReference('/TestPage?key=value'));
        System.assertEquals('value', u.getPageParam('key', 'defalutvalue'));

        Test.setCurrentPage(new PageReference('/TestPage?key='));
        System.assertEquals('defalutvalue', u.getPageParam('key', 'defalutvalue'));

        //+ indicates a space
        Test.setCurrentPage(new PageReference('/TestPage?key=+++'));
        System.assertEquals('   ', u.getPageParam('key', 'defalutvalue'));

        Test.setCurrentPage(new PageReference('/TestPage'));
        System.assertEquals('defalutvalue', u.getPageParam('key', 'defalutvalue'));
    }

    testmethod public static void test_joinMap() {
    
        Map<String, String> values = new Map<String, String>();
        values.put('foo', 'bar');
        values.put('bob', 'alice');
        
        System.assertEquals(null, u.join((Map<String, Object>) null));
        System.assert(u.join(',', '=', values) == 'bob=alice,foo=bar' || u.join(',', '=', values) == 'foo=bar,bob=alice' );
        System.assert(u.join(values) == 'bob=alice, foo=bar' || u.join(values) == 'foo=bar, bob=alice' );

        values = new Map<String, String>();
        values.put('foo', 'hello world');
        System.assert(u.join(values) == 'foo=hello world');
        System.assert(u.join(',', '=', 'url', values) == 'foo=hello+world');
    }
    
    testmethod public static void test_joinList() {
		
        List<String> strings = new List<String>{'hello', 'world'};
        List<Integer> ints = new List<Integer>{10, 20};
        
        System.assertEquals(null, u.join((List<Object>) null));
        System.assertEquals('helloworld', u.join(strings));
        System.assertEquals('1020', u.join(ints));
        System.assertEquals('hello,world', u.join(',', strings));
        
		strings = new List<String>{'hello', 'world', null, 'foo'};
        System.assertEquals('hello,world,,foo', u.join(',', strings));
        System.assertEquals('hello,world,foo', u.join(',', true, strings));
    }

    testmethod public static void test_join() {
        System.assertEquals('foobar', u.join('foo', 'bar'));
        System.assertEquals('foobaralice', u.join('foo', 'bar', 'alice'));
        System.assertEquals('foo=bar', u.joinWith('=', 'foo', 'bar'));
        System.assertEquals('foo=bar=alice', u.joinWith('=', 'foo', 'bar', 'alice'));
    }
    
    testmethod public static void test_firstNotNull() {
        Account s1 = new Account();
        Account s2 = new Account();
        
        System.assertEquals(null, u.firstNotNull((SObject) null, (SObject)  null));
        System.assertEquals(s1, u.firstNotNull(s1, null));
        System.assertEquals(s1, u.firstNotNull(s1, s2));
        System.assertEquals(s2, u.firstNotNull(null, s2));
        
        String st1 = '';
        String st2 = '';
        String st3 = '';
        
        System.assertEquals(st1, u.firstNotNull(st1, null));
        System.assertEquals(st1, u.firstNotNull(st1, st2));
        System.assertEquals(st2, u.firstNotNull(null, st2));
        System.assertEquals(st3, u.firstNotNull(null, null, st3));
    }
    
    testmethod public static void test_firstNotBlank() {
        
        System.assertEquals(null, u.firstNotBlank(null, null));
        System.assertEquals('', u.firstNotBlank(null, ''));
        System.assertEquals('Second', u.firstNotBlank(null, 'Second'));
        System.assertEquals('First', u.firstNotBlank('First', null));
        System.assertEquals('First', u.firstNotBlank('First', 'Second'));
        
    }     
    
    testmethod public static void test_truncate() {
    	assert.that(u.truncateEnd(null, 3)).isEqualsTo(null);
    	assert.that(u.truncateEnd('', 3)).isEqualsTo('');
    	assert.that(u.truncateEnd('a', 3)).isEqualsTo('a');
    	assert.that(u.truncateEnd('ab', 3)).isEqualsTo('ab');
    	assert.that(u.truncateEnd('abc', 3)).isEqualsTo('abc');
    	assert.that(u.truncateEnd('abcd', 3)).isEqualsTo('abc');

        assert.that(u.truncateStart(null, 3)).isEqualsTo(null);
    	assert.that(u.truncateStart('', 3)).isEqualsTo('');
    	assert.that(u.truncateStart('a', 3)).isEqualsTo('a');
    	assert.that(u.truncateStart('ab', 3)).isEqualsTo('ab');
    	assert.that(u.truncateStart('abc', 3)).isEqualsTo('abc');
    	assert.that(u.truncateStart('abcd', 3)).isEqualsTo('bcd');
    }

    testmethod public static void test_equalsIc() {
        System.assertEquals(true, u.equalsIc(null, null));
        System.assertEquals(false, u.equalsIc(null, 'value'));
        System.assertEquals(true, u.equalsIc(' ', ' '));
        System.assertEquals(true, u.equalsIc('Value', 'value'));
        System.assertEquals(false, u.equalsIc('Value', ' value '));        
    }     

    testmethod public static void test_increment() {
        System.assertEquals(1, u.increment((Decimal) null));
        System.assertEquals(1, u.increment(0.0));
        System.assertEquals(3, u.increment(2.0));
        System.assertEquals(1, u.increment((Integer) null));
        System.assertEquals(1, u.increment(0));
        System.assertEquals(3, u.increment(2));
    }
    
	testmethod public static void test_getSobject() {
		System.assertEquals('User', u.getSobject(UserInfo.getUserId()));
		System.assertEquals(null, u.getSobject((Id) null));
		System.assertEquals('User', u.getSobject([select id from user where id = :UserInfo.getUserId()]));
		System.assertEquals(null, u.getSobject((Sobject) null));
	}

    testmethod public static void test_split() {
        assert.that(u.split(null, 3).size()).isEqualsTo(0);
        assert.that(u.split('', 3).size()).isEqualsTo(0);
        assert.that(u.split(' ', 3).size()).isEqualsTo(1);
        assert.that(u.split('a', 3).size()).isEqualsTo(1);
        assert.that(u.split('ab', 3).size()).isEqualsTo(1);
        assert.that(u.split('abc', 3).size()).isEqualsTo(1);
        assert.that(u.split('abcd', 3).size()).isEqualsTo(2);
    }

    testmethod public static void test_sleep() {
    	StopWatch sw = new StopWatch();
        u.sleep(100);
        assert.that(sw.getElapsedTime()).isGreaterThan(90);
    }
    
    testmethod public static void test_getRandomString() {
        assert.that(u.getRandomString(0).length()).isEqualsTo(0);
        assert.that(u.getRandomString(1).length()).isEqualsTo(1);
        assert.that(u.getRandomString(9).length()).isEqualsTo(9);
        assert.that(u.getRandomString(10).length()).isEqualsTo(10);
        assert.that(u.getRandomString(11).length()).isEqualsTo(11);
        assert.that(u.getRandomString(19).length()).isEqualsTo(19);
        assert.that(u.getRandomString(99).length()).isEqualsTo(99);
        assert.that(u.getRandomString(100).length()).isEqualsTo(100);
        assert.that(u.getRandomString(9999).length()).isEqualsTo(9999);
    }
 	
    testmethod public static void test_getRandomInteger() {
		assert.that(u.getRandomInteger()).isGreaterThanOrEqualsTo(0);
        for (Integer i = 0; i< 1000; i++) {
			assert.that(u.getRandomInteger(5)).isBetweenInclusive(0, 10);
        }

        for (Integer i = 0; i< 1000; i++) {
			assert.that(u.getRandomInteger(0, 10)).isBetweenInclusive(0, 10);
        }
    }

    testmethod public static void test_getStaticResource() {
    	assert.that(u.getStaticResource('LibshareTestResource')).isEqualsTo('This is Libshare Static Resource used for unit testing');
        
        try {
            u.getStaticResource('NotExistingOne');
            assert.expectedException();
        } catch (Exception e) {}
    }
    
    testmethod public static void test_getClassAndMethod() {
        assert.that(u.getClassAndMethod(new List<String>{}, 0)[0]).isEqualsTo('Unknown');
        assert.that(u.getClassAndMethod(new List<String>{'NotValid'}, 0)[0]).isEqualsTo('Unknown');
        assert.that(u.getClassAndMethod(new List<String>{'Class.ClassName.methodName:'}, 0)[0]).isEqualsTo('ClassName');
        assert.that(u.getClassAndMethod(new List<String>{'Class.ClassName.methodName:'}, 0)[1]).isEqualsTo('methodName');
        assert.that(u.getClassAndMethod(new List<String>{'Class.ClassName'}, 0)[0]).isEqualsTo('ClassName');
        assert.that(u.getClassAndMethod(new List<String>{'Class.ClassName'}, 0)[1]).isEqualsTo('Unknown');
    }
    
    testmethod static void test_durationTiny() {
        assert.that(u.getDurationTiny(1)).isEqualsTo('1ms');

        assert.that(u.getDurationTiny(1000)).isEqualsTo('1s');
        assert.that(u.getDurationTiny(1001)).isEqualsTo('1s 1ms');

        assert.that(u.getDurationTiny(61000)).isEqualsTo('1m 1s');
        assert.that(u.getDurationTiny(61001)).isEqualsTo('1m 1s 1ms');

        assert.that(u.getDurationTiny(3600000)).isEqualsTo('1h');
        assert.that(u.getDurationTiny(3600001)).isEqualsTo('1h 1ms');
        assert.that(u.getDurationTiny(3601001)).isEqualsTo('1h 1s 1ms');
        assert.that(u.getDurationTiny(3661001)).isEqualsTo('1h 1m 1s 1ms');
    }

    testmethod static void test_durationShort() {
        assert.that(u.getDurationShort(1)).isEqualsTo('1 millis');

        assert.that(u.getDurationShort(1000)).isEqualsTo('1 secs');
        assert.that(u.getDurationShort(1001)).isEqualsTo('1 secs, 1 millis');

        assert.that(u.getDurationShort(61000)).isEqualsTo('1 mins, 1 secs');
        assert.that(u.getDurationShort(61001)).isEqualsTo('1 mins, 1 secs, 1 millis');

        assert.that(u.getDurationShort(3600000)).isEqualsTo('1 hrs');
        assert.that(u.getDurationShort(3600001)).isEqualsTo('1 hrs, 1 millis');
        assert.that(u.getDurationShort(3601001)).isEqualsTo('1 hrs, 1 secs, 1 millis');
        assert.that(u.getDurationShort(3661001)).isEqualsTo('1 hrs, 1 mins, 1 secs, 1 millis');
    }

    testmethod static void test_durationLong() {
        assert.that(u.getDurationLong(1)).isEqualsTo('1 milliseconds');

        assert.that(u.getDurationLong(1000)).isEqualsTo('1 seconds');
        assert.that(u.getDurationLong(1001)).isEqualsTo('1 seconds, 1 milliseconds');

        assert.that(u.getDurationLong(61000)).isEqualsTo('1 minutes, 1 seconds');
        assert.that(u.getDurationLong(61001)).isEqualsTo('1 minutes, 1 seconds, 1 milliseconds');

        assert.that(u.getDurationLong(3600000)).isEqualsTo('1 hours');
        assert.that(u.getDurationLong(3600001)).isEqualsTo('1 hours, 1 milliseconds');
        assert.that(u.getDurationLong(3601001)).isEqualsTo('1 hours, 1 seconds, 1 milliseconds');
        assert.that(u.getDurationLong(3661001)).isEqualsTo('1 hours, 1 minutes, 1 seconds, 1 milliseconds');
    }
}