@IsTest
public class DateTimeAssertTest {
    static Assert assert = Sf.assert.setUseCustomException(true);
    static String customMessage = 'Custom Message';
	
    testmethod public static void test_isNull() {
        assert.that((Date) null).isNull();

        try {
	        assert.that(Date.newInstance(2017, 01, 01)).isNull();
            assert.expectedException();
        } catch (Exception e) {
            assert.that(e).hasMessage('Expected that actual [2017-01-01 00:00:00] to be [null] but is not');
        }
        
        assert.that((Date) null).isNull(customMessage);
        try {
	        assert.that(Date.newInstance(2017, 01, 01)).isNull(customMessage);
            assert.expectedException();
        } catch (Exception e) {
            assert.that(e).hasMessage(customMessage);
        }
    }
    
    testmethod public static void test_isNotNull() {
        assert.that(Date.newInstance(2017, 01, 01)).isNotNull();

        try {
	        assert.that((Date) null).isNotNull();
            assert.expectedException();
        } catch (Exception e) {
            assert.that(e).hasMessage('Expected that actual to be not [null] but is');
        }
        
        assert.that(Date.newInstance(2017, 01, 01)).isNotNull(customMessage);
        try {
	        assert.that((Date) null).isNotNull(customMessage);
            assert.expectedException();
        } catch (Exception e) {
            assert.that(e).hasMessage(customMessage);
        }
    }
    
    testmethod public static void test_isEqualsTo() {
        assert.that((Date) null).isEqualsTo((Date) null);
        assert.that(Date.newInstance(2017, 01, 01)).isEqualsTo(Date.newInstance(2017, 01, 01));

        try {
	        assert.that(Date.newInstance(2017, 01, 01)).isEqualsTo(Date.newInstance(2017, 01, 02));
            assert.expectedException();
        } catch (Exception e) {
            assert.that(e).hasMessage('Expected that actual [2017-01-01 00:00:00] to be equals to [2017-01-02 00:00:00] but is not');
        }
        
        assert.that(Date.newInstance(2017, 01, 01)).isEqualsTo(Date.newInstance(2017, 01, 01), customMessage);
        try {
	        assert.that(Date.newInstance(2017, 01, 01)).isEqualsTo(Date.newInstance(2017, 01, 02), customMessage);
            assert.expectedException();
        } catch (Exception e) {
            assert.that(e).hasMessage(customMessage);
        }
    }

    testmethod public static void test_isNotEqualsTo() {
        assert.that(Date.newInstance(2017, 01, 01)).isNotEqualsTo(Date.newInstance(2017, 01, 02));
        assert.that(Date.newInstance(2017, 01, 01)).isNotEqualsTo((Date) null);
        assert.that((Date) null).isNotEqualsTo(Date.newInstance(2017, 01, 01));

        try {
        assert.that(Date.newInstance(2017, 01, 01)).isNotEqualsTo(Date.newInstance(2017, 01, 01));
            assert.expectedException();
        } catch (Exception e) {
            assert.that(e).hasMessage('Expected that actual [2017-01-01 00:00:00] to be not equals to [2017-01-01 00:00:00] but is');
        }
        
        assert.that(Date.newInstance(2017, 01, 01)).isNotEqualsTo(Date.newInstance(2017, 01, 02), customMessage);
        assert.that(Date.newInstance(2017, 01, 01)).isNotEqualsTo((Date) null, customMessage);
        assert.that((Date) null).isNotEqualsTo(Date.newInstance(2017, 01, 01), customMessage);

        try {
	        assert.that(Date.newInstance(2017, 01, 01)).isNotEqualsTo(Date.newInstance(2017, 01, 01), customMessage);
            assert.expectedException();
        } catch (Exception e) {
            assert.that(e).hasMessage(customMessage);
        }
    }
    
    testmethod public static void test_isSameAs() {
        Date dt = Date.newInstance(2017, 01, 01);
        assert.that(dt).isSameAs(dt);

        try {
	        assert.that(Date.newInstance(2017, 01, 01)).isSameAs(Date.newInstance(2017, 01, 01));
            assert.expectedException();
        } catch (Exception e) {
            assert.that(e).hasMessage('Expected that actual [2017-01-01 00:00:00] to be same as [2017-01-01 00:00:00] but is not');
        }
        
        assert.that(dt).isSameAs(dt, customMessage);

        try {
	        assert.that(Date.newInstance(2017, 01, 01)).isSameAs(Date.newInstance(2017, 01, 01), customMessage);
            assert.expectedException();
        } catch (Exception e) {
            assert.that(e).hasMessage(customMessage);
        }
    }
    
    testmethod public static void test_isNotSameAs() {
        assert.that(Date.newInstance(2017, 01, 01)).isNotSameAs(Date.newInstance(2017, 01, 01));

        Date dt = Date.newInstance(2017, 01, 01);
        try {
	        assert.that(dt).isNotSameAs(dt);
            assert.expectedException();
        } catch (Exception e) {
            assert.that(e).hasMessage('Expected that actual [2017-01-01 00:00:00] to be not same as [2017-01-01 00:00:00] but is');
        }
        
        assert.that(Date.newInstance(2017, 01, 01)).isNotSameAs(Date.newInstance(2017, 01, 01), customMessage);

        try {
	        assert.that(dt).isNotSameAs(dt, customMessage);
            assert.expectedException();
        } catch (Exception e) {
            assert.that(e).hasMessage(customMessage);
        }
    }
    
    testmethod public static void test_isAfter() {
        assert.that(Date.newInstance(2017, 01, 02)).isAfter(Date.newInstance(2017, 01, 01));
        assert.that(Date.newInstance(2018, 01, 02)).isAfter(Date.newInstance(2017, 01, 01));

        try {
	        assert.that(Date.newInstance(2017, 01, 02)).isAfter(Date.newInstance(2017, 01, 02));
            assert.expectedException();
        } catch (Exception e) {
            assert.that(e).hasMessage('Expected that actual [2017-01-02 00:00:00] is after [2017-01-02 00:00:00] but is not');
        }
        
        try {
	        assert.that(Date.newInstance(2017, 01, 01)).isAfter(Date.newInstance(2017, 01, 02));
            assert.expectedException();
        } catch (Exception e) {
            assert.that(e).hasMessage('Expected that actual [2017-01-01 00:00:00] is after [2017-01-02 00:00:00] but is not');
        }

        assert.that(Date.newInstance(2017, 01, 02)).isAfter(Date.newInstance(2017, 01, 01), customMessage);
        assert.that(Date.newInstance(2018, 01, 02)).isAfter(Date.newInstance(2017, 01, 01), customMessage);

        try {
	        assert.that(Date.newInstance(2017, 01, 02)).isAfter(Date.newInstance(2017, 01, 02), customMessage);
            assert.expectedException();
        } catch (Exception e) {
            assert.that(e).hasMessage(customMessage);
        }
        
        try {
	        assert.that(Date.newInstance(2017, 01, 01)).isAfter(Date.newInstance(2017, 01, 02), customMessage);
            assert.expectedException();
        } catch (Exception e) {
            assert.that(e).hasMessage(customMessage);
        }
    }
    
    testmethod public static void test_isOnOrAfter() {
        assert.that(Date.newInstance(2017, 01, 02)).isOnOrAfter(Date.newInstance(2017, 01, 01));
        assert.that(Date.newInstance(2018, 01, 02)).isOnOrAfter(Date.newInstance(2017, 01, 01));
        assert.that(Date.newInstance(2017, 01, 01)).isOnOrAfter(Date.newInstance(2017, 01, 01));

        try {
	        assert.that(Date.newInstance(2017, 01, 01)).isOnOrAfter(Date.newInstance(2017, 01, 02));
            assert.expectedException();
        } catch (Exception e) {
            assert.that(e).hasMessage('Expected that actual [2017-01-01 00:00:00] is on or after [2017-01-02 00:00:00] but is not');
        }

        assert.that(Date.newInstance(2017, 01, 02)).isOnOrAfter(Date.newInstance(2017, 01, 01), customMessage);
        assert.that(Date.newInstance(2018, 01, 02)).isOnOrAfter(Date.newInstance(2017, 01, 01), customMessage);
        assert.that(Date.newInstance(2017, 01, 01)).isOnOrAfter(Date.newInstance(2017, 01, 01), customMessage);

        try {
	        assert.that(Date.newInstance(2017, 01, 01)).isOnOrAfter(Date.newInstance(2017, 01, 02), customMessage);
            assert.expectedException();
        } catch (Exception e) {
            assert.that(e).hasMessage(customMessage);
        }
    }
    
    testmethod public static void test_isBefore() {
        assert.that(Date.newInstance(2017, 01, 01)).isBefore(Date.newInstance(2017, 01, 02));
        assert.that(Date.newInstance(2017, 12, 31)).isBefore(Date.newInstance(2018, 01, 01));

        try {
	        assert.that(Date.newInstance(2017, 01, 02)).isBefore(Date.newInstance(2017, 01, 02));
            assert.expectedException();
        } catch (Exception e) {
            assert.that(e).hasMessage('Expected that actual [2017-01-02 00:00:00] is before [2017-01-02 00:00:00] but is not');
        }
        
        try {
	        assert.that(Date.newInstance(2017, 01, 02)).isBefore(Date.newInstance(2017, 01, 01));
            assert.expectedException();
        } catch (Exception e) {
            assert.that(e).hasMessage('Expected that actual [2017-01-02 00:00:00] is before [2017-01-01 00:00:00] but is not');
        }

        assert.that(Date.newInstance(2017, 01, 01)).isBefore(Date.newInstance(2017, 01, 02), customMessage);
        assert.that(Date.newInstance(2017, 12, 31)).isBefore(Date.newInstance(2018, 01, 01), customMessage);

        try {
	        assert.that(Date.newInstance(2017, 01, 02)).isBefore(Date.newInstance(2017, 01, 02), customMessage);
            assert.expectedException();
        } catch (Exception e) {
            assert.that(e).hasMessage(customMessage);
        }
        
        try {
	        assert.that(Date.newInstance(2017, 01, 02)).isBefore(Date.newInstance(2017, 01, 01), customMessage);
            assert.expectedException();
        } catch (Exception e) {
            assert.that(e).hasMessage(customMessage);
        }
    }

    testmethod public static void test_isOnOrBefore() {
        assert.that(Date.newInstance(2017, 01, 02)).isOnOrBefore(Date.newInstance(2017, 01, 02));
        assert.that(Date.newInstance(2017, 01, 01)).isOnOrBefore(Date.newInstance(2017, 01, 02));

        try {
	        assert.that(Date.newInstance(2017, 01, 03)).isOnOrBefore(Date.newInstance(2017, 01, 02));
            assert.expectedException();
        } catch (Exception e) {
            assert.that(e).hasMessage('Expected that actual [2017-01-03 00:00:00] is on or before [2017-01-02 00:00:00] but is not');
        }

        assert.that(Date.newInstance(2017, 01, 02)).isOnOrBefore(Date.newInstance(2017, 01, 02), customMessage);
        assert.that(Date.newInstance(2017, 01, 01)).isOnOrBefore(Date.newInstance(2017, 01, 02), customMessage);

        try {
	        assert.that(Date.newInstance(2017, 01, 03)).isOnOrBefore(Date.newInstance(2017, 01, 02), customMessage);
            assert.expectedException();
        } catch (Exception e) {
            assert.that(e).hasMessage(customMessage);
        }
    }
}