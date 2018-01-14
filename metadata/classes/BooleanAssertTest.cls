@IsTest
public class BooleanAssertTest {
    static Assert assert = Sf.assert.setUseCustomException(true);
    static String customMessage = 'Custom Message';
	
    testmethod public static void test_isNull() {
        assert.that((Boolean) null).isNull();

        try {
	        assert.that(true).isNull();
            assert.expectedException();
        } catch (Exception e) {
            assert.that(e).hasMessage('Expected that actual [true] to be [null] but is not');
        }
        
        try {
	        assert.that(false).isNull();
            assert.expectedException();
        } catch (Exception e) {
            assert.that(e).hasMessage('Expected that actual [false] to be [null] but is not');
        }

        assert.that((Boolean) null).isNull(customMessage);
        try {
	        assert.that(true).isNull(customMessage);
            assert.expectedException();
        } catch (Exception e) {
            assert.that(e).hasMessage(customMessage);
        }
        
        try {
	        assert.that(false).isNull(customMessage);
            assert.expectedException();
        } catch (Exception e) {
            assert.that(e).hasMessage(customMessage);
        }
    }

    testmethod public static void test_isNotNull() {
        assert.that(true).isNotNull();
        assert.that(false).isNotNull();

        try {
	        assert.that((Boolean) null).isNotNull();
            assert.expectedException();
        } catch (Exception e) {
            assert.that(e).hasMessage('Expected that actual to be not [null] but is');
        }
        
        assert.that(true).isNotNull(customMessage);
        try {
	        assert.that((Boolean) null).isNotNull(customMessage);
            assert.expectedException();
        } catch (Exception e) {
            assert.that(e).hasMessage(customMessage);
        }
    }
 
    testmethod public static void test_isTrue() {
        assert.that(true).isTrue();

        try {
	        assert.that((Boolean) null).isTrue();
            assert.expectedException();
        } catch (Exception e) {
            assert.that(e).hasMessage('Expected that actual [null] to be equals to [true] but is not');
        }
        
        try {
	        assert.that(false).isTrue();
            assert.expectedException();
        } catch (Exception e) {
            assert.that(e).hasMessage('Expected that actual [false] to be equals to [true] but is not');
        }

        assert.that(true).isTrue(customMessage);
        try {
	        assert.that((Boolean) null).isTrue(customMessage);
            assert.expectedException();
        } catch (Exception e) {
            assert.that(e).hasMessage(customMessage);
        }
        
        try {
	        assert.that(false).isTrue(customMessage);
            assert.expectedException();
        } catch (Exception e) {
            assert.that(e).hasMessage(customMessage);
        }
    }

    testmethod public static void test_isFalse() {
        assert.that(false).isFalse();

        try {
	        assert.that((Boolean) null).isFalse();
            assert.expectedException();
        } catch (Exception e) {
            assert.that(e).hasMessage('Expected that actual [null] to be equals to [false] but is not');
        }
        
        try {
	        assert.that(true).isFalse();
            assert.expectedException();
        } catch (Exception e) {
            assert.that(e).hasMessage('Expected that actual [true] to be equals to [false] but is not');
        }

        assert.that(false).isFalse(customMessage);
        try {
	        assert.that((Boolean) null).isFalse(customMessage);
            assert.expectedException();
        } catch (Exception e) {
            assert.that(e).hasMessage(customMessage);
        }
        
        try {
	        assert.that(true).isFalse(customMessage);
            assert.expectedException();
        } catch (Exception e) {
            assert.that(e).hasMessage(customMessage);
        }
    }

    testmethod public static void test_isEqualsTo() {
        assert.that(true).isEqualsTo(true);
        assert.that(false).isEqualsTo(false);

        try {
	        assert.that((Boolean) null).isEqualsTo(true);
            assert.expectedException();
        } catch (Exception e) {
            assert.that(e).hasMessage('Expected that actual [null] to be equals to [true] but is not');
        }
        
        try {
	        assert.that(false).isEqualsTo(true);
            assert.expectedException();
        } catch (Exception e) {
            assert.that(e).hasMessage('Expected that actual [false] to be equals to [true] but is not');
        }

        assert.that(true).isEqualsTo(true, customMessage);
        try {
	        assert.that((Boolean) null).isEqualsTo(true, customMessage);
            assert.expectedException();
        } catch (Exception e) {
            assert.that(e).hasMessage(customMessage);
        }
        
        try {
	        assert.that(false).isEqualsTo(true, customMessage);
            assert.expectedException();
        } catch (Exception e) {
            assert.that(e).hasMessage(customMessage);
        }
    }

    testmethod public static void test_isNotEqualsTo() {
        assert.that(false).isNotEqualsTo(true);
        assert.that(true).isNotEqualsTo(false);
        assert.that((Boolean) null).isNotEqualsTo(true);

        try {
	        assert.that(true).isNotEqualsTo(true);
            assert.expectedException();
        } catch (Exception e) {
            assert.that(e).hasMessage('Expected that actual [true] to be not equals to [true] but is');
        }

        assert.that((Boolean) null).isNotEqualsTo(true, customMessage);
        
        try {
	        assert.that(true).isNotEqualsTo(true, customMessage);
            assert.expectedException();
        } catch (Exception e) {
            assert.that(e).hasMessage(customMessage);
        }
    }

}