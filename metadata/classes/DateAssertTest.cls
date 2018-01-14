@IsTest
public class DateAssertTest {
    static Assert assert = Sf.assert.setUseCustomException(true);
    static String customMessage = 'Custom Message';
	static Date jan1st = Date.newInstance(2017, 01, 01);
	static Date jan2nd = Date.newInstance(2017, 01, 02);
	static Date jan3rd = Date.newInstance(2017, 01, 03);
    
    testmethod public static void test_isNull() {
        assert.that((Date) null).isNull();

        try {
	        assert.that(jan1st).isNull();
            assert.expectedException();
        } catch (Exception e) {
            assert.that(e).hasMessage('Expected that actual [2017-01-01 00:00:00] to be [null] but is not');
        }
        
        assert.that((Date) null).isNull(customMessage);
        try {
	        assert.that(jan1st).isNull(customMessage);
            assert.expectedException();
        } catch (Exception e) {
            assert.that(e).hasMessage(customMessage);
        }
    }
    
    testmethod public static void test_isNotNull() {
        assert.that(jan1st).isNotNull();

        try {
	        assert.that((Date) null).isNotNull();
            assert.expectedException();
        } catch (Exception e) {
            assert.that(e).hasMessage('Expected that actual to be not [null] but is');
        }
        
        assert.that(jan1st).isNotNull(customMessage);
        try {
	        assert.that((Date) null).isNotNull(customMessage);
            assert.expectedException();
        } catch (Exception e) {
            assert.that(e).hasMessage(customMessage);
        }
    }
    
    testmethod public static void test_isEqualsTo() {
        assert.that((Date) null).isEqualsTo((Date) null);
        assert.that(jan1st).isEqualsTo(jan1st);
        assert.that(jan1st).isEqualsTo('2017-01-01');

        try {
	        assert.that(jan1st).isEqualsTo(jan2nd);
            assert.expectedException();
        } catch (Exception e) {
            assert.that(e).hasMessage('Expected that actual [2017-01-01 00:00:00] to be equals to [2017-01-02 00:00:00] but is not');
        }
        
        assert.that(jan1st).isEqualsTo(jan1st, customMessage);
        assert.that(jan1st).isEqualsTo('2017-01-01', customMessage);
        try {
	        assert.that(jan1st).isEqualsTo(jan2nd, customMessage);
            assert.expectedException();
        } catch (Exception e) {
            assert.that(e).hasMessage(customMessage);
        }
    }

    testmethod public static void test_isNotEqualsTo() {
        assert.that(jan1st).isNotEqualsTo(jan2nd);
        assert.that(jan1st).isNotEqualsTo('2017-01-02');
        assert.that(jan1st).isNotEqualsTo((date) null);
        assert.that((Date) null).isNotEqualsTo(jan1st);

        try {
	        assert.that(jan1st).isNotEqualsTo(jan1st);
            assert.expectedException();
        } catch (Exception e) {
            assert.that(e).hasMessage('Expected that actual [2017-01-01 00:00:00] to be not equals to [2017-01-01 00:00:00] but is');
        }
        
        assert.that(jan1st).isNotEqualsTo('2017-01-02', customMessage);
        assert.that(jan1st).isNotEqualsTo(jan2nd, customMessage);
        assert.that(jan1st).isNotEqualsTo((Date)null, customMessage);
        assert.that((Date) null).isNotEqualsTo(jan1st, customMessage);

        try {
	        assert.that(jan1st).isNotEqualsTo(jan1st, customMessage);
            assert.expectedException();
        } catch (Exception e) {
            assert.that(e).hasMessage(customMessage);
        }
    }
    
    testmethod public static void test_isSameAs() {
        Date dt = jan1st;
        assert.that(dt).isSameAs(dt);

        try {
	        assert.that(jan1st).isSameAs(Date.newInstance(2017, 01, 01));
            assert.expectedException();
        } catch (Exception e) {
            assert.that(e).hasMessage('Expected that actual [2017-01-01 00:00:00] to be same as [2017-01-01 00:00:00] but is not');
        }
        
        assert.that(dt).isSameAs(dt, customMessage);

        try {
	        assert.that(jan1st).isSameAs(Date.newInstance(2017, 01, 01), customMessage);
            assert.expectedException();
        } catch (Exception e) {
            assert.that(e).hasMessage(customMessage);
        }
    }
    
    testmethod public static void test_isNotSameAs() {
        assert.that(jan1st).isNotSameAs(Date.newInstance(2017, 01, 01));

        Date dt = jan1st;
        try {
	        assert.that(dt).isNotSameAs(dt);
            assert.expectedException();
        } catch (Exception e) {
            assert.that(e).hasMessage('Expected that actual [2017-01-01 00:00:00] to be not same as [2017-01-01 00:00:00] but is');
        }
        
        assert.that(jan1st).isNotSameAs(Date.newInstance(2017, 01, 01), customMessage);

        try {
	        assert.that(dt).isNotSameAs(dt, customMessage);
            assert.expectedException();
        } catch (Exception e) {
            assert.that(e).hasMessage(customMessage);
        }
    }
    
    testmethod public static void test_isAfter() {
        assert.that(jan2nd).isAfter(jan1st);
        assert.that(jan2nd).isAfter('2017-01-01');
        assert.that(Date.newInstance(2018, 01, 02)).isAfter(jan1st);

        try {
	        assert.that(jan2nd).isAfter(jan2nd);
            assert.expectedException();
        } catch (Exception e) {
            assert.that(e).hasMessage('Expected that actual [2017-01-02 00:00:00] is after [2017-01-02 00:00:00] but is not');
        }
        
        try {
	        assert.that(jan1st).isAfter(jan2nd);
            assert.expectedException();
        } catch (Exception e) {
            assert.that(e).hasMessage('Expected that actual [2017-01-01 00:00:00] is after [2017-01-02 00:00:00] but is not');
        }

        assert.that(jan2nd).isAfter('2017-01-01', customMessage);
        assert.that(jan2nd).isAfter(jan1st, customMessage);
        assert.that(Date.newInstance(2018, 01, 02)).isAfter(jan1st, customMessage);

        try {
	        assert.that(jan2nd).isAfter(jan2nd, customMessage);
            assert.expectedException();
        } catch (Exception e) {
            assert.that(e).hasMessage(customMessage);
        }
        
        try {
	        assert.that(jan1st).isAfter(jan2nd, customMessage);
            assert.expectedException();
        } catch (Exception e) {
            assert.that(e).hasMessage(customMessage);
        }
    }
    
    testmethod public static void test_isOnOrAfter() {
        assert.that(jan2nd).isOnOrAfter(jan1st);
        assert.that(jan2nd).isOnOrAfter('2017-01-01');
        assert.that(jan2nd).isOnOrAfter('2017-01-02');
        assert.that(Date.newInstance(2018, 01, 02)).isOnOrAfter(jan1st);
        assert.that(jan1st).isOnOrAfter(jan1st);

        try {
	        assert.that(jan1st).isOnOrAfter(jan2nd);
            assert.expectedException();
        } catch (Exception e) {
            assert.that(e).hasMessage('Expected that actual [2017-01-01 00:00:00] is on or after [2017-01-02 00:00:00] but is not');
        }

        assert.that(jan2nd).isOnOrAfter('2017-01-01', customMessage);
        assert.that(jan2nd).isOnOrAfter('2017-01-02', customMessage);
        assert.that(jan2nd).isOnOrAfter(jan1st, customMessage);
        assert.that(Date.newInstance(2018, 01, 02)).isOnOrAfter(jan1st, customMessage);
        assert.that(jan1st).isOnOrAfter(jan1st, customMessage);

        try {
	        assert.that(jan1st).isOnOrAfter(jan2nd, customMessage);
            assert.expectedException();
        } catch (Exception e) {
            assert.that(e).hasMessage(customMessage);
        }
    }
    
    testmethod public static void test_isBefore() {
        assert.that(jan1st).isBefore(jan2nd);
        assert.that(jan1st).isBefore('2017-01-02');
        assert.that(Date.newInstance(2017, 12, 31)).isBefore(Date.newInstance(2018, 01, 01));

        try {
	        assert.that(jan2nd).isBefore(jan2nd);
            assert.expectedException();
        } catch (Exception e) {
            assert.that(e).hasMessage('Expected that actual [2017-01-02 00:00:00] is before [2017-01-02 00:00:00] but is not');
        }
        
        try {
	        assert.that(jan2nd).isBefore(jan1st);
            assert.expectedException();
        } catch (Exception e) {
            assert.that(e).hasMessage('Expected that actual [2017-01-02 00:00:00] is before [2017-01-01 00:00:00] but is not');
        }

        assert.that(jan1st).isBefore(jan2nd, customMessage);
        assert.that(jan1st).isBefore('2017-01-02', customMessage);
        assert.that(Date.newInstance(2017, 12, 31)).isBefore(Date.newInstance(2018, 01, 01), customMessage);

        try {
	        assert.that(jan2nd).isBefore(jan2nd, customMessage);
            assert.expectedException();
        } catch (Exception e) {
            assert.that(e).hasMessage(customMessage);
        }
        
        try {
	        assert.that(jan2nd).isBefore(jan1st, customMessage);
            assert.expectedException();
        } catch (Exception e) {
            assert.that(e).hasMessage(customMessage);
        }
    }

    testmethod public static void test_isOnOrBefore() {
        assert.that(jan2nd).isOnOrBefore(jan2nd);
        assert.that(jan1st).isOnOrBefore(jan2nd);
        assert.that(jan2nd).isOnOrBefore('2017-01-02');
        assert.that(jan1st).isOnOrBefore('2017-01-02');

        try {
	        assert.that(jan3rd).isOnOrBefore(jan2nd);
            assert.expectedException();
        } catch (Exception e) {
            assert.that(e).hasMessage('Expected that actual [2017-01-03 00:00:00] is on or before [2017-01-02 00:00:00] but is not');
        }

        assert.that(jan2nd).isOnOrBefore(jan2nd, customMessage);
        assert.that(jan1st).isOnOrBefore(jan2nd, customMessage);
        assert.that(jan2nd).isOnOrBefore('2017-01-02', customMessage);
        assert.that(jan1st).isOnOrBefore('2017-01-02', customMessage);

        try {
	        assert.that(jan3rd).isOnOrBefore(jan2nd, customMessage);
            assert.expectedException();
        } catch (Exception e) {
            assert.that(e).hasMessage(customMessage);
        }
    }
}