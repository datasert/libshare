@IsTest
public class AssertTest {
    static Assert assert = Sf.assert.setUseCustomException(true);
    static String customMessage = 'Custom Message';

    testmethod public static void test_fail() {
        try {
            assert.fail();
            System.assert(false, 'Expected exception');
        } catch (AssertException e) {
            //ignore
        }

        try {
            assert.fail('Hello');
            System.assert(false, 'Expected exception');
        } catch (AssertException e) {
            System.assertEquals('Hello', e.getMessage());
        }
    }

    testmethod public static void test_result() {
        assert.check(true);

        try {
			assert.check(false);
            System.assert(false, 'Expected exception');
        } catch (AssertException e) {
            //ignore
        }

        assert.check(true);
        assert.check(true, customMessage);

        try {
			assert.check(false, customMessage);
            System.assert(false, customMessage);
        } catch (AssertException e) {
            //ignore
        }
    }

    testmethod public static void test_expectedException() {
        try {
            assert.expectedException();
            System.assert(false, 'Expected exception');
        } catch (AssertException e) {
            System.assertEquals('Expected an exception but none was thrown', e.getMessage());
        }

        try {
            assert.expectedException('Test Msg');
            System.assert(false, 'Expected exception');
        } catch (AssertException e) {
            System.assertEquals('Test Msg', e.getMessage());
        }

        try {
            assert.expectedException(AssertException.class);
            System.assert(false, 'Expected exception');
        } catch (AssertException e) {
            System.assertEquals('Expected an exception of type [lib.AssertException] but none was thrown', e.getMessage());
        }
    }
    
    testmethod public static void test_multiAssert() {
     	Assert assert2 = Sf.assert.setUseCustomException(true).setMultiAssert(true);
        assert2.expectedException();
        assert2.expectedException('Test Msg');
        assert2.expectedException(AssertException.class);

        try {
            assert2.evaluate();
            System.assert(false, 'Expected an exception to be thrown');
        } catch (AssertException e) {
            //ignore
        }
    }
    
}