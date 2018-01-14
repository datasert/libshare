@IsTest
public class IntegerAssertTest {
    static Assert assert = Sf.assert.setUseCustomException(true);
    static String customMessage = 'Custom Message';
	
    testmethod public static void test_isNull() {
        
        assert.that((Integer) null).isNull();
        
        try {
	        assert.that(10).isNull();
            assert.expectedException();
        } catch (Exception e) {
            assert.that(e).hasMessage('Expected that actual [10] to be [null] but is not');
        }

        assert.that((Integer) null).isNull(customMessage);
        
        try {
	        assert.that(10).isNull(customMessage);
            assert.expectedException();
        } catch (Exception e) {
            assert.that(e).hasMessage(customMessage);
        }
    }

    testmethod public static void test_isNotNull() {
        
        assert.that(10).isNotNull();
        assert.that(0).isNotNull();
        assert.that(-1).isNotNull();
        
        try {
	        assert.that((Integer) null).isNotNull();
            assert.expectedException();
        } catch (Exception e) {
            assert.that(e).hasMessage('Expected that actual to be not [null] but is');
        }

        assert.that(10).isNotNull(customMessage);
        assert.that(0).isNotNull(customMessage);
        assert.that(-1).isNotNull(customMessage);
        
        try {
	        assert.that((Integer) null).isNotNull(customMessage);
            assert.expectedException();
        } catch (Exception e) {
            assert.that(e).hasMessage(customMessage);
        }
    }

    testmethod public static void test_isEqualsTo() {
        
        assert.that(10).isEqualsTo(10);
        assert.that(0).isEqualsTo(0);
        assert.that(-1).isEqualsTo(-1);
        assert.that(10).isEqualsTo(10);
        assert.that((Integer) null).isEqualsTo(null);
        
        try {
	        assert.that(10).isEqualsTo(11);
            assert.expectedException();
        } catch (Exception e) {
            assert.that(e).hasMessage('Expected that actual [10] to be equals to [11] but is not');
        }

        try {
	        assert.that(10).isEqualsTo(null);
            assert.expectedException();
        } catch (Exception e) {
            assert.that(e).hasMessage('Expected that actual [10] to be equals to [null] but is not');
        }
        try {
	        assert.that((Integer) null).isEqualsTo(10);
            assert.expectedException();
        } catch (Exception e) {
            assert.that(e).hasMessage('Expected that actual [null] to be equals to [10] but is not');
        }

        assert.that(10).isEqualsTo(10, customMessage);
        assert.that(0).isEqualsTo(0, customMessage);
        assert.that(-1).isEqualsTo(-1, customMessage);
        assert.that((Integer) null).isEqualsTo(null, customMessage);
        
        try {
	        assert.that(10).isEqualsTo(11, customMessage);
            assert.expectedException();
        } catch (Exception e) {
            assert.that(e).hasMessage(customMessage);
        }
        try {
	        assert.that(10).isEqualsTo(null, customMessage);
            assert.expectedException();
        } catch (Exception e) {
            assert.that(e).hasMessage(customMessage);
        }
        try {
	        assert.that((Integer) null).isEqualsTo(10, customMessage);
            assert.expectedException();
        } catch (Exception e) {
            assert.that(e).hasMessage(customMessage);
        }
    }
    
    testmethod public static void test_isNotEqualsTo() {
        
        assert.that(10).isNotEqualsTo(20);
        assert.that(-1).isNotEqualsTo(0);
        assert.that(0).isNotEqualsTo(-1);
        assert.that((Integer) null).isNotEqualsTo(0);
        assert.that(0).isNotEqualsTo(null);
        
        try {
	        assert.that(10).isNotEqualsTo(10);
            assert.expectedException();
        } catch (Exception e) {
            assert.that(e).hasMessage('Expected that actual [10] to be not equals to [10] but is');
        }
        
        try {
	        assert.that((Integer) null).isNotEqualsTo(null);
            assert.expectedException();
        } catch (Exception e) {
            assert.that(e).hasMessage('Expected that actual [null] to be not equals to [null] but is');
        }
        
        assert.that(10).isNotEqualsTo(11, customMessage);
        assert.that(-1).isNotEqualsTo(0, customMessage);
        assert.that(0).isNotEqualsTo(-1, customMessage);
        assert.that((Integer) null).isNotEqualsTo(-1, customMessage);
        assert.that(0).isNotEqualsTo(null, customMessage);
        
        try {
	        assert.that(10).isNotEqualsTo(10, customMessage);
            assert.expectedException();
        } catch (Exception e) {
            assert.that(e).hasMessage(customMessage);
        }
        
        try {
	        assert.that((Integer) null).isNotEqualsTo(null, customMessage);
            assert.expectedException();
        } catch (Exception e) {
            assert.that(e).hasMessage(customMessage);
        }
        
    }    
	
    testmethod public static void test_isZero() {
        assert.that(0).isZero();
        try {
	        assert.that(10).isZero();
            assert.expectedException();
        } catch (Exception e) {
            assert.that(e).hasMessage('Expected that actual [10] to be equals to [0] but is not');
        }
        try {
	        assert.that((Integer) null).isZero();
            assert.expectedException();
        } catch (Exception e) {
            assert.that(e).hasMessage('Expected that actual [null] to be equals to [0] but is not');
        }

        assert.that(0).isZero(customMessage);
        try {
	        assert.that(10).isZero(customMessage);
            assert.expectedException();
        } catch (Exception e) {
            assert.that(e).hasMessage(customMessage);
        }
        try {
	        assert.that((Integer) null).isZero(customMessage);
            assert.expectedException();
        } catch (Exception e) {
            assert.that(e).hasMessage(customMessage);
        }
   	}

    testmethod public static void test_isNotZero() {
        assert.that(-1).isNotZero();
        assert.that((Integer) null).isNotZero();
        try {
	        assert.that(0).isNotZero();
            assert.expectedException();
        } catch (Exception e) {
            assert.that(e).hasMessage('Expected that actual [0] to be not equals to [0] but is');
        }

        assert.that(-1).isNotZero(customMessage);
        assert.that((Integer) null).isNotZero(customMessage);
        try {
	        assert.that(0).isNotZero(customMessage);
            assert.expectedException();
        } catch (Exception e) {
            assert.that(e).hasMessage(customMessage);
        }
   	}
    
    testmethod public static void test_isOne() {
        assert.that(1).isOne();
        try {
	        assert.that(10).isOne();
            assert.expectedException();
        } catch (Exception e) {
            assert.that(e).hasMessage('Expected that actual [10] to be equals to [1] but is not');
        }
        try {
	        assert.that((Integer) null).isOne();
            assert.expectedException();
        } catch (Exception e) {
            assert.that(e).hasMessage('Expected that actual [null] to be equals to [1] but is not');
        }

        assert.that(1).isOne(customMessage);
        try {
	        assert.that(10).isOne(customMessage);
            assert.expectedException();
        } catch (Exception e) {
            assert.that(e).hasMessage(customMessage);
        }
        try {
	        assert.that((Integer) null).isOne(customMessage);
            assert.expectedException();
        } catch (Exception e) {
            assert.that(e).hasMessage(customMessage);
        }
   	}

    testmethod public static void test_isNotOne() {
        assert.that(-1).isNotOne();
        assert.that((Integer) null).isNotOne();
        try {
	        assert.that(1).isNotOne();
            assert.expectedException();
        } catch (Exception e) {
            assert.that(e).hasMessage('Expected that actual [1] to be not equals to [1] but is');
        }

        assert.that(-1).isNotOne(customMessage);
        assert.that((Integer) null).isNotOne(customMessage);
        try {
	        assert.that(1).isNotOne(customMessage);
            assert.expectedException();
        } catch (Exception e) {
            assert.that(e).hasMessage(customMessage);
        }
   	}
    
    testmethod public static void test_isPositive() {
        assert.that(1).isPositive();
        assert.that(100).isPositive();
        try {
	        assert.that(0).isPositive();
            assert.expectedException();
        } catch (Exception e) {
            assert.that(e).hasMessage('Expected that actual [0] to be greater than [0] but is not');
        }
        try {
	        assert.that(-1).isPositive();
            assert.expectedException();
        } catch (Exception e) {
            assert.that(e).hasMessage('Expected that actual [-1] to be greater than [0] but is not');
        }
        try {
	        assert.that((Integer) null).isPositive();
            assert.expectedException();
        } catch (Exception e) {
            assert.that(e).hasMessage('Expected that actual [null] to be greater than [0] but is not');
        }

        assert.that(1).isPositive(customMessage);
        assert.that(100).isPositive(customMessage);
        try {
	        assert.that(0).isPositive(customMessage);
            assert.expectedException();
        } catch (Exception e) {
            assert.that(e).hasMessage(customMessage);
        }
        try {
	        assert.that((Integer) null).isPositive(customMessage);
            assert.expectedException();
        } catch (Exception e) {
            assert.that(e).hasMessage(customMessage);
        }
   	}
    
    testmethod public static void test_isNegative() {
        assert.that(-1).isNegative();
        assert.that(-100).isNegative();
        try {
	        assert.that(0).isNegative();
            assert.expectedException();
        } catch (Exception e) {
            assert.that(e).hasMessage('Expected that actual [0] to be less than [0] but is not');
        }
        try {
	        assert.that(1).isNegative();
            assert.expectedException();
        } catch (Exception e) {
            assert.that(e).hasMessage('Expected that actual [1] to be less than [0] but is not');
        }
        try {
	        assert.that((Integer) null).isNegative();
            assert.expectedException();
        } catch (Exception e) {
            assert.that(e).hasMessage('Expected that actual [null] to be less than [0] but is not');
        }

        assert.that(-1).isNegative(customMessage);
        assert.that(-100).isNegative(customMessage);
        try {
	        assert.that(0).isNegative(customMessage);
            assert.expectedException();
        } catch (Exception e) {
            assert.that(e).hasMessage(customMessage);
        }
        try {
	        assert.that(1).isNegative(customMessage);
            assert.expectedException();
        } catch (Exception e) {
            assert.that(e).hasMessage(customMessage);
        }
        try {
	        assert.that((Integer) null).isNegative(customMessage);
            assert.expectedException();
        } catch (Exception e) {
            assert.that(e).hasMessage(customMessage);
        }
   	}
    
    testmethod public static void test_isLessThan() {
        assert.that(1).isLessThan(2);
        assert.that(10).isLessThan(11);
        assert.that(-2).isLessThan(-1);
        assert.that(0).isLessThan(1);
        try {
	        assert.that(0).isLessThan(0);
            assert.expectedException();
        } catch (Exception e) {
            assert.that(e).hasMessage('Expected that actual [0] to be less than [0] but is not');
        }
        try {
	        assert.that(1).isLessThan(0);
            assert.expectedException();
        } catch (Exception e) {
            assert.that(e).hasMessage('Expected that actual [1] to be less than [0] but is not');
        }
        try {
	        assert.that((Integer) null).isLessThan(0);
            assert.expectedException();
        } catch (Exception e) {
            assert.that(e).hasMessage('Expected that actual [null] to be less than [0] but is not');
        }

        assert.that(1).isLessThan(2, customMessage);
        assert.that(10).isLessThan(11, customMessage);
        assert.that(-2).isLessThan(-1, customMessage);
        assert.that(0).isLessThan(1, customMessage);
        try {
	        assert.that(0).isLessThan(0, customMessage);
            assert.expectedException();
        } catch (Exception e) {
            assert.that(e).hasMessage(customMessage);
        }
        try {
	        assert.that(1).isLessThan(0, customMessage);
            assert.expectedException();
        } catch (Exception e) {
            assert.that(e).hasMessage(customMessage);
        }
        try {
	        assert.that((Integer) null).isLessThan(0, customMessage);
            assert.expectedException();
        } catch (Exception e) {
            assert.that(e).hasMessage(customMessage);
        }
   	}
    
    testmethod public static void test_isLessThanOrEqualsTo() {
        assert.that(1).isLessThanOrEqualsTo(1);
        assert.that(10).isLessThanOrEqualsTo(11);
        assert.that(-2).isLessThanOrEqualsTo(-2);
        assert.that(0).isLessThanOrEqualsTo(0);
        try {
	        assert.that(0).isLessThanOrEqualsTo(-1);
            assert.expectedException();
        } catch (Exception e) {
            assert.that(e).hasMessage('Expected that actual [0] to be less than or equals to [-1] but is not');
        }
        try {
	        assert.that(1).isLessThanOrEqualsTo(0);
            assert.expectedException();
        } catch (Exception e) {
            assert.that(e).hasMessage('Expected that actual [1] to be less than or equals to [0] but is not');
        }
        try {
	        assert.that((Integer) null).isLessThanOrEqualsTo(0);
            assert.expectedException();
        } catch (Exception e) {
            assert.that(e).hasMessage('Expected that actual [null] to be less than or equals to [0] but is not');
        }

        assert.that(1).isLessThanOrEqualsTo(1, customMessage);
        assert.that(10).isLessThanOrEqualsTo(11, customMessage);
        assert.that(-2).isLessThanOrEqualsTo(-2, customMessage);
        assert.that(0).isLessThanOrEqualsTo(0, customMessage);
        try {
	        assert.that(0).isLessThanOrEqualsTo(-1, customMessage);
            assert.expectedException();
        } catch (Exception e) {
            assert.that(e).hasMessage(customMessage);
        }
        try {
	        assert.that(1).isLessThanOrEqualsTo(0, customMessage);
            assert.expectedException();
        } catch (Exception e) {
            assert.that(e).hasMessage(customMessage);
        }
        try {
	        assert.that((Integer) null).isLessThanOrEqualsTo(0, customMessage);
            assert.expectedException();
        } catch (Exception e) {
            assert.that(e).hasMessage(customMessage);
        }
   	}

    testmethod public static void test_isGreaterThan() {
        assert.that(1).isGreaterThan(0);
        assert.that(10).isGreaterThan(9);
        assert.that(-1).isGreaterThan(-2);
        assert.that(0).isGreaterThan(-1);
        try {
	        assert.that(0).isGreaterThan(1);
            assert.expectedException();
        } catch (Exception e) {
            assert.that(e).hasMessage('Expected that actual [0] to be greater than [1] but is not');
        }
        try {
	        assert.that(1).isGreaterThan(2);
            assert.expectedException();
        } catch (Exception e) {
            assert.that(e).hasMessage('Expected that actual [1] to be greater than [2] but is not');
        }
        try {
	        assert.that((Integer) null).isGreaterThan(0);
            assert.expectedException();
        } catch (Exception e) {
            assert.that(e).hasMessage('Expected that actual [null] to be greater than [0] but is not');
        }

        assert.that(1).isGreaterThan(0, customMessage);
        assert.that(10).isGreaterThan(9, customMessage);
        assert.that(-1).isGreaterThan(-2, customMessage);
        assert.that(0).isGreaterThan(-1, customMessage);
        try {
	        assert.that(0).isGreaterThan(1, customMessage);
            assert.expectedException();
        } catch (Exception e) {
            assert.that(e).hasMessage(customMessage);
        }
        try {
	        assert.that(1).isGreaterThan(2, customMessage);
            assert.expectedException();
        } catch (Exception e) {
            assert.that(e).hasMessage(customMessage);
        }
        try {
	        assert.that((Integer) null).isGreaterThan(0, customMessage);
            assert.expectedException();
        } catch (Exception e) {
            assert.that(e).hasMessage(customMessage);
        }
   	}
    
    testmethod public static void test_isGreaterThanOrEqualsTo() {
        assert.that(1).isGreaterThanOrEqualsTo(1);
        assert.that(10).isGreaterThanOrEqualsTo(9);
        assert.that(-1).isGreaterThanOrEqualsTo(-2);
        assert.that(0).isGreaterThanOrEqualsTo(0);
        try {
	        assert.that(0).isGreaterThanOrEqualsTo(1);
            assert.expectedException();
        } catch (Exception e) {
            assert.that(e).hasMessage('Expected that actual [0] to be greater than or equals to [1] but is not');
        }
        try {
	        assert.that(1).isGreaterThanOrEqualsTo(2);
            assert.expectedException();
        } catch (Exception e) {
            assert.that(e).hasMessage('Expected that actual [1] to be greater than or equals to [2] but is not');
        }
        try {
	        assert.that((Integer) null).isGreaterThanOrEqualsTo(0);
            assert.expectedException();
        } catch (Exception e) {
            assert.that(e).hasMessage('Expected that actual [null] to be greater than or equals to [0] but is not');
        }

        assert.that(1).isGreaterThanOrEqualsTo(1, customMessage);
        assert.that(10).isGreaterThanOrEqualsTo(9, customMessage);
        assert.that(-1).isGreaterThanOrEqualsTo(-2, customMessage);
        assert.that(0).isGreaterThanOrEqualsTo(0, customMessage);
        try {
	        assert.that(0).isGreaterThanOrEqualsTo(1, customMessage);
            assert.expectedException();
        } catch (Exception e) {
            assert.that(e).hasMessage(customMessage);
        }
        try {
	        assert.that(1).isGreaterThanOrEqualsTo(2, customMessage);
            assert.expectedException();
        } catch (Exception e) {
            assert.that(e).hasMessage(customMessage);
        }
        try {
	        assert.that((Integer) null).isGreaterThanOrEqualsTo(0, customMessage);
            assert.expectedException();
        } catch (Exception e) {
            assert.that(e).hasMessage(customMessage);
        }
   	}
    
    testmethod public static void test_isBetween() {
        assert.that(1).isBetween(0, 2);
        assert.that(1).isBetween(-1, 2);
        assert.that(1).isBetween(-3, 2);
        assert.that(-2).isBetween(-3, -1);
        assert.that(-2).isBetween(-3, 0);
        assert.that(-2).isBetween(-3, 3);
        
        assert.that(0).isBetween(-1, 1);
        assert.that(0).isBetween(-2, 1);

        try {
	        assert.that(0).isBetween(1, 2);
            assert.expectedException();
        } catch (Exception e) {
            assert.that(e).hasMessage('Expected that actual [0] to be between [1] and [2] but is not');
        }
        try {
	        assert.that(1).isBetween(-2, -1);
            assert.expectedException();
        } catch (Exception e) {
            assert.that(e).hasMessage('Expected that actual [1] to be between [-2] and [-1] but is not');
        }
        try { 
	        assert.that((Integer) null).isBetween(0, 1);
            assert.expectedException();
        } catch (Exception e) {
            assert.that(e).hasMessage('Expected that actual [null] to be between [0] and [1] but is not');
        }

        assert.that(1).isBetween(0, 2, customMessage);
        assert.that(1).isBetween(-1, 2, customMessage);
        assert.that(1).isBetween(-3, 2, customMessage);
        assert.that(-2).isBetween(-3, -1, customMessage);
        assert.that(-2).isBetween(-3, 0, customMessage);
        assert.that(-2).isBetween(-3, 3, customMessage);
        
        assert.that(0).isBetween(-1, 1, customMessage);
        assert.that(0).isBetween(-2, 1, customMessage);

        try {
	        assert.that(0).isBetween(1, 2, customMessage);
            assert.expectedException();
        } catch (Exception e) {
            assert.that(e).hasMessage(customMessage);
        }
        try {
	        assert.that(1).isBetween(-2, -1, customMessage);
            assert.expectedException();
        } catch (Exception e) {
            assert.that(e).hasMessage(customMessage);
        }
        try { 
	        assert.that((Integer) null).isBetween(0, 1, customMessage);
            assert.expectedException();
        } catch (Exception e) {
            assert.that(e).hasMessage(customMessage);
        }
   	}
    
    testmethod public static void test_isBetweenInclusive() {
        assert.that(1).isBetweenInclusive(1, 1);
        assert.that(1).isBetweenInclusive(0, 2);
        assert.that(1).isBetweenInclusive(0, 1);
        assert.that(1).isBetweenInclusive(1, 2);
        assert.that(-2).isBetweenInclusive(-2, -2);
        assert.that(-2).isBetweenInclusive(-2, -1);
        assert.that(-2).isBetweenInclusive(-3, -2);
        
        assert.that(0).isBetweenInclusive(0, 0);
        assert.that(0).isBetweenInclusive(-1, 0);
        assert.that(0).isBetweenInclusive(0, 1);
        assert.that(0).isBetweenInclusive(-1, 1);
        try {
	        assert.that(0).isBetweenInclusive(1, 2);
            assert.expectedException();
        } catch (Exception e) {
            assert.that(e).hasMessage('Expected that actual [0] to be between (inclusive) [1] and [2] but is not');
        }
        try {
	        assert.that(1).isBetweenInclusive(-2, -1);
            assert.expectedException();
        } catch (Exception e) {
            assert.that(e).hasMessage('Expected that actual [1] to be between (inclusive) [-2] and [-1] but is not');
        }
        try { 
	        assert.that((Integer) null).isBetweenInclusive(0, 1);
            assert.expectedException();
        } catch (Exception e) {
            assert.that(e).hasMessage('Expected that actual [null] to be between (inclusive) [0] and [1] but is not');
        }

        assert.that(1).isBetweenInclusive(1, 1, customMessage);
        assert.that(1).isBetweenInclusive(0, 2, customMessage);
        assert.that(1).isBetweenInclusive(0, 1, customMessage);
        assert.that(1).isBetweenInclusive(1, 2, customMessage);
        assert.that(-2).isBetweenInclusive(-2, -2, customMessage);
        assert.that(-2).isBetweenInclusive(-2, -1, customMessage);
        assert.that(-2).isBetweenInclusive(-3, -2, customMessage);
        
        assert.that(0).isBetweenInclusive(0, 0, customMessage);
        assert.that(0).isBetweenInclusive(-1, 0, customMessage);
        assert.that(0).isBetweenInclusive(0, 1, customMessage);
        assert.that(0).isBetweenInclusive(-1, 1, customMessage);
        try {
	        assert.that(0).isBetweenInclusive(1, 2, customMessage);
            assert.expectedException();
        } catch (Exception e) {
            assert.that(e).hasMessage(customMessage);
        }
        try {
	        assert.that(1).isBetweenInclusive(-2, -1, customMessage);
            assert.expectedException();
        } catch (Exception e) {
            assert.that(e).hasMessage(customMessage);
        }
        try { 
	        assert.that((Integer) null).isBetweenInclusive(0, 1, customMessage);
            assert.expectedException();
        } catch (Exception e) {
            assert.that(e).hasMessage(customMessage);
        }
        
   	}
    
}