@IsTest
public class DecimalAssertTest {
    static Assert assert = Sf.assert.setUseCustomException(true);
    static String customMessage = 'Custom Message';
    
    testmethod public static void test_isNull() {
        
        assert.that((Decimal) null).isNull();
        
        try {
            assert.that(10.9).isNull();
            assert.expectedException();
        } catch (Exception e) {
            assert.that(e).hasMessage('Expected: <null>, Actual: <not null> 10.9');
        }

        assert.that((Decimal) null).isNull(customMessage);
        
        try {
            assert.that(10.9).isNull(customMessage);
            assert.expectedException();
        } catch (Exception e) {
            assert.that(e).hasMessage(customMessage);
        }
    }

    testmethod public static void test_isNotNull() {
        
        assert.that(10.9).isNotNull();
        assert.that(0.5).isNotNull();
        assert.that(-1.5).isNotNull();
        
        try {
            assert.that((Decimal) null).isNotNull();
            assert.expectedException();
        } catch (Exception e) {
            assert.that(e).hasMessage('Expected: <not null>, Actual: <null>');
        }

        assert.that(10.9).isNotNull(customMessage);
        assert.that(0).isNotNull(customMessage);
        assert.that(-1.5).isNotNull(customMessage);
        
        try {
            assert.that((Decimal) null).isNotNull(customMessage);
            assert.expectedException();
        } catch (Exception e) {
            assert.that(e).hasMessage(customMessage);
        }
    }

    testmethod public static void test_isEqualsTo() {
        
        assert.that(10.9).isEqualsTo(10.9);
        assert.that(0.5).isEqualsTo(0.5);
        assert.that(-1.1).isEqualsTo(-1.1);
        
        try {
            assert.that(10.99).isEqualsTo(11);
            assert.expectedException();
        } catch (Exception e) {
            assert.that(e).hasMessage('Expected: 11, Actual: 10.99');
        }

        try {
            assert.that(10.99).isEqualsTo(null);
            assert.expectedException();
        } catch (Exception e) {
            assert.that(e).hasMessage('Expected: null, Actual: 10.99');
        }
        try {
            assert.that((Decimal) null).isEqualsTo(10.0);
            assert.expectedException();
        } catch (Exception e) {
            assert.that(e).hasMessage('Expected: 10.0, Actual: null');
        }

        assert.that(10.9).isEqualsTo(10.9, customMessage);
        assert.that(0.5).isEqualsTo(0.5, customMessage);
        assert.that(-1.1).isEqualsTo(-1.1, customMessage);
        
        try {
            assert.that(10.9).isEqualsTo(11.1, customMessage);
            assert.expectedException();
        } catch (Exception e) {
            assert.that(e).hasMessage(customMessage);
        }
        try {
            assert.that(10.9).isEqualsTo(null, customMessage);
            assert.expectedException();
        } catch (Exception e) {
            assert.that(e).hasMessage(customMessage);
        }
        try {
            assert.that((Decimal) null).isEqualsTo(10.99, customMessage);
            assert.expectedException();
        } catch (Exception e) {
            assert.that(e).hasMessage(customMessage);
        }
    }
    
    testmethod public static void test_isNotEqualsTo() {
        
        assert.that(10.99).isNotEqualsTo(20.99);
        assert.that(-1.1).isNotEqualsTo(0.5);
        assert.that(0.0).isNotEqualsTo(-1.3);
        assert.that((Decimal) null).isNotEqualsTo(0.1);
        
        try {
            assert.that(10.99).isNotEqualsTo(10.99);
            assert.expectedException();
        } catch (Exception e) {
            assert.that(e).hasMessage('Expected: <not equals to> 10.99');
        }
        
        try {
            assert.that((Decimal) null).isNotEqualsTo(null);
            assert.expectedException();
        } catch (Exception e) {
            assert.that(e).hasMessage('Expected: <not equals to> null');
        }
        
        assert.that(10.99).isNotEqualsTo(11.99, customMessage);
        assert.that(-1.1).isNotEqualsTo(0.0, customMessage);
        assert.that(0.1).isNotEqualsTo(-1.1, customMessage);
        assert.that((Decimal) null).isNotEqualsTo(-1.1, customMessage);
        
        try {
            assert.that(10.99).isNotEqualsTo(10.99, customMessage);
            assert.expectedException();
        } catch (Exception e) {
            assert.that(e).hasMessage(customMessage);
        }
        
        try {
            assert.that((Decimal) null).isNotEqualsTo(null, customMessage);
            assert.expectedException();
        } catch (Exception e) {
            assert.that(e).hasMessage(customMessage);
        }
        
    }    
    
    testmethod public static void test_isZero() {
        assert.that(0.0).isZero();
        try {
            assert.that(10.0).isZero();
            assert.expectedException();
        } catch (Exception e) {
            assert.that(e).hasMessage('Expected: 0, Actual: 10.0');
        }
        try {
            assert.that((Decimal) null).isZero();
            assert.expectedException();
        } catch (Exception e) {
            assert.that(e).hasMessage('Expected: 0, Actual: null');
        }

        assert.that(0.0).isZero(customMessage);
        try {
            assert.that(10.0).isZero(customMessage);
            assert.expectedException();
        } catch (Exception e) {
            assert.that(e).hasMessage(customMessage);
        }
        try {
            assert.that((Decimal) null).isZero(customMessage);
            assert.expectedException();
        } catch (Exception e) {
            assert.that(e).hasMessage(customMessage);
        }
    }

    testmethod public static void test_isNotZero() {
        assert.that(-1.0).isNotZero();
        assert.that((Decimal) null).isNotZero();
        try {
            assert.that(0.0).isNotZero();
            assert.expectedException();
        } catch (Exception e) {
            assert.that(e).hasMessage('Expected: <not equals to> 0.0');
        }

        assert.that(-1.0).isNotZero(customMessage);
        assert.that((Decimal) null).isNotZero(customMessage);
        try {
            assert.that(0.0).isNotZero(customMessage);
            assert.expectedException();
        } catch (Exception e) {
            assert.that(e).hasMessage(customMessage);
        }
    }
    
    testmethod public static void test_isOne() {
        assert.that(1.0).isOne();
        try {
            assert.that(10.0).isOne();
            assert.expectedException();
        } catch (Exception e) {
            assert.that(e).hasMessage('Expected: 1, Actual: 10.0');
        }
        try {
            assert.that((Decimal) null).isOne();
            assert.expectedException();
        } catch (Exception e) {
            assert.that(e).hasMessage('Expected: 1, Actual: null');
        }

        assert.that(1.0).isOne(customMessage);
        try {
            assert.that(10.0).isOne(customMessage);
            assert.expectedException();
        } catch (Exception e) {
            assert.that(e).hasMessage(customMessage);
        }
        try {
            assert.that((Decimal) null).isOne(customMessage);
            assert.expectedException();
        } catch (Exception e) {
            assert.that(e).hasMessage(customMessage);
        }
    }

    testmethod public static void test_isNotOne() {
        assert.that(-1.0).isNotOne();
        assert.that((Decimal) null).isNotOne();
        try {
            assert.that(1.0).isNotOne();
            assert.expectedException();
        } catch (Exception e) {
            assert.that(e).hasMessage('Expected: <not equals to> 1.0');
        }

        assert.that(-1.0).isNotOne(customMessage);
        assert.that((Decimal) null).isNotOne(customMessage);
        try {
            assert.that(1.0).isNotOne(customMessage);
            assert.expectedException();
        } catch (Exception e) {
            assert.that(e).hasMessage(customMessage);
        }
    }
    
    testmethod public static void test_isPositive() {
        assert.that(1.0).isPositive();
        assert.that(100.0).isPositive();
        try {
            assert.that(0.0).isPositive();
            assert.expectedException();
        } catch (Exception e) {
            assert.that(e).hasMessage('Expected: <greater than> 0, Actual: 0.0');
        }
        try {
            assert.that(-1.0).isPositive();
            assert.expectedException();
        } catch (Exception e) {
            assert.that(e).hasMessage('Expected: <greater than> 0, Actual: -1.0');
        }
        try {
            assert.that((Decimal) null).isPositive();
            assert.expectedException();
        } catch (Exception e) {
            assert.that(e).hasMessage('Expected: <greater than> 0, Actual: null');
        }

        assert.that(1.0).isPositive(customMessage);
        assert.that(100.0).isPositive(customMessage);
        try {
            assert.that(0.0).isPositive(customMessage);
            assert.expectedException();
        } catch (Exception e) {
            assert.that(e).hasMessage(customMessage);
        }
        try {
            assert.that((Decimal) null).isPositive(customMessage);
            assert.expectedException();
        } catch (Exception e) {
            assert.that(e).hasMessage(customMessage);
        }
    }
    
    testmethod public static void test_isNegative() {
        assert.that(-1.0).isNegative();
        assert.that(-100.0).isNegative();
        try {
            assert.that(0.0).isNegative();
            assert.expectedException();
        } catch (Exception e) {
            assert.that(e).hasMessage('Expected: <less than> 0, Actual: 0.0');
        }
        try {
            assert.that(1.0).isNegative();
            assert.expectedException();
        } catch (Exception e) {
            assert.that(e).hasMessage('Expected: <less than> 0, Actual: 1.0');
        }
        try {
            assert.that((Decimal) null).isNegative();
            assert.expectedException();
        } catch (Exception e) {
            assert.that(e).hasMessage('Expected: <less than> 0, Actual: null');
        }

        assert.that(-1.0).isNegative(customMessage);
        assert.that(-100.0).isNegative(customMessage);
        try {
            assert.that(0.0).isNegative(customMessage);
            assert.expectedException();
        } catch (Exception e) {
            assert.that(e).hasMessage(customMessage);
        }
        try {
            assert.that(1.0).isNegative(customMessage);
            assert.expectedException();
        } catch (Exception e) {
            assert.that(e).hasMessage(customMessage);
        }
        try {
            assert.that((Decimal) null).isNegative(customMessage);
            assert.expectedException();
        } catch (Exception e) {
            assert.that(e).hasMessage(customMessage);
        }
    }
    
    testmethod public static void test_isLessThan() {
        assert.that(1.0).isLessThan(2.0);
        assert.that(10.0).isLessThan(11.0);
        assert.that(-2.0).isLessThan(-1.0);
        assert.that(0.0).isLessThan(1.0);
        try {
            assert.that(0.0).isLessThan(0.0);
            assert.expectedException();
        } catch (Exception e) {
            assert.that(e).hasMessage('Expected: <less than> 0.0, Actual: 0.0');
        }
        try {
            assert.that(1.0).isLessThan(0.0);
            assert.expectedException();
        } catch (Exception e) {
            assert.that(e).hasMessage('Expected: <less than> 0.0, Actual: 1.0');
        }
        try {
            assert.that((Decimal) null).isLessThan(0.0);
            assert.expectedException();
        } catch (Exception e) {
            assert.that(e).hasMessage('Expected: <less than> 0.0, Actual: null');
        }

        assert.that(1.0).isLessThan(2.0, customMessage);
        assert.that(10.0).isLessThan(11.0, customMessage);
        assert.that(-2.0).isLessThan(-1.0, customMessage);
        assert.that(0.0).isLessThan(1.0, customMessage);
        try {
            assert.that(0.0).isLessThan(0.0, customMessage);
            assert.expectedException();
        } catch (Exception e) {
            assert.that(e).hasMessage(customMessage);
        }
        try {
            assert.that(1.0).isLessThan(0.0, customMessage);
            assert.expectedException();
        } catch (Exception e) {
            assert.that(e).hasMessage(customMessage);
        }
        try {
            assert.that((Decimal) null).isLessThan(0.0, customMessage);
            assert.expectedException();
        } catch (Exception e) {
            assert.that(e).hasMessage(customMessage);
        }
    }
    
    testmethod public static void test_isLessThanOrEqualsTo() {
        assert.that(1.0).isLessThanOrEqualsTo(1.0);
        assert.that(10.0).isLessThanOrEqualsTo(11.0);
        assert.that(-2.0).isLessThanOrEqualsTo(-2.0);
        assert.that(0.0).isLessThanOrEqualsTo(0.0);
        try {
            assert.that(0.0).isLessThanOrEqualsTo(-1.0);
            assert.expectedException();
        } catch (Exception e) {
            assert.that(e).hasMessage('Expected: <less than or equals to> -1.0, Actual: 0.0');
        }
        try {
            assert.that(1.0).isLessThanOrEqualsTo(0.0);
            assert.expectedException();
        } catch (Exception e) {
            assert.that(e).hasMessage('Expected: <less than or equals to> 0.0, Actual: 1.0');
        }
        try {
            assert.that((Decimal) null).isLessThanOrEqualsTo(0.0);
            assert.expectedException();
        } catch (Exception e) {
            assert.that(e).hasMessage('Expected: <less than or equals to> 0.0, Actual: null');
        }

        assert.that(1.0).isLessThanOrEqualsTo(1.0, customMessage);
        assert.that(10.0).isLessThanOrEqualsTo(11.0, customMessage);
        assert.that(-2.0).isLessThanOrEqualsTo(-2.0, customMessage);
        assert.that(0.0).isLessThanOrEqualsTo(0.0, customMessage);
        try {
            assert.that(0.0).isLessThanOrEqualsTo(-1.0, customMessage);
            assert.expectedException();
        } catch (Exception e) {
            assert.that(e).hasMessage(customMessage);
        }
        try {
            assert.that(1.0).isLessThanOrEqualsTo(0.0, customMessage);
            assert.expectedException();
        } catch (Exception e) {
            assert.that(e).hasMessage(customMessage);
        }
        try {
            assert.that((Decimal) null).isLessThanOrEqualsTo(0.0, customMessage);
            assert.expectedException();
        } catch (Exception e) {
            assert.that(e).hasMessage(customMessage);
        }
    }

    testmethod public static void test_isGreaterThan() {
        assert.that(1.0).isGreaterThan(0.0);
        assert.that(10.0).isGreaterThan(9.0);
        assert.that(-1.0).isGreaterThan(-2.0);
        assert.that(0.0).isGreaterThan(-1.0);
        try {
            assert.that(0.0).isGreaterThan(1.0);
            assert.expectedException();
        } catch (Exception e) {
            assert.that(e).hasMessage('Expected: <greater than> 1.0, Actual: 0.0');
        }
        try {
            assert.that(1.0).isGreaterThan(2.0);
            assert.expectedException();
        } catch (Exception e) {
            assert.that(e).hasMessage('Expected: <greater than> 2.0, Actual: 1.0');
        }
        try {
            assert.that((Decimal) null).isGreaterThan(0.0);
            assert.expectedException();
        } catch (Exception e) {
            assert.that(e).hasMessage('Expected: <greater than> 0.0, Actual: null');
        }

        assert.that(1.0).isGreaterThan(0.0, customMessage);
        assert.that(10.0).isGreaterThan(9.0, customMessage);
        assert.that(-1.0).isGreaterThan(-2.0, customMessage);
        assert.that(0.0).isGreaterThan(-1.0, customMessage);
        try {
            assert.that(0.0).isGreaterThan(1.0, customMessage);
            assert.expectedException();
        } catch (Exception e) {
            assert.that(e).hasMessage(customMessage);
        }
        try {
            assert.that(1.0).isGreaterThan(2.0, customMessage);
            assert.expectedException();
        } catch (Exception e) {
            assert.that(e).hasMessage(customMessage);
        }
        try {
            assert.that((Decimal) null).isGreaterThan(0.0, customMessage);
            assert.expectedException();
        } catch (Exception e) {
            assert.that(e).hasMessage(customMessage);
        }
    }
    
    testmethod public static void test_isGreaterThanOrEqualsTo() {
        assert.that(1.0).isGreaterThanOrEqualsTo(1.0);
        assert.that(10.0).isGreaterThanOrEqualsTo(9.0);
        assert.that(-1.0).isGreaterThanOrEqualsTo(-2.0);
        assert.that(0.0).isGreaterThanOrEqualsTo(0.0);
        try {
            assert.that(0.0).isGreaterThanOrEqualsTo(1.0);
            assert.expectedException();
        } catch (Exception e) {
            assert.that(e).hasMessage('Expected: <greater than or equals to> 1.0, Actual: 0.0');
        }
        try {
            assert.that(1.0).isGreaterThanOrEqualsTo(2.0);
            assert.expectedException();
        } catch (Exception e) {
            assert.that(e).hasMessage('Expected: <greater than or equals to> 2.0, Actual: 1.0');
        }
        try {
            assert.that((Decimal) null).isGreaterThanOrEqualsTo(0.0);
            assert.expectedException();
        } catch (Exception e) {
            assert.that(e).hasMessage('Expected: <greater than or equals to> 0.0, Actual: null');
        }

        assert.that(1.0).isGreaterThanOrEqualsTo(1.0, customMessage);
        assert.that(10.0).isGreaterThanOrEqualsTo(9.0, customMessage);
        assert.that(-1.0).isGreaterThanOrEqualsTo(-2.0, customMessage);
        assert.that(0.0).isGreaterThanOrEqualsTo(0.0, customMessage);
        try {
            assert.that(0.0).isGreaterThanOrEqualsTo(.01, customMessage);
            assert.expectedException();
        } catch (Exception e) {
            assert.that(e).hasMessage(customMessage);
        }
        try {
            assert.that(1.0).isGreaterThanOrEqualsTo(2.0, customMessage);
            assert.expectedException();
        } catch (Exception e) {
            assert.that(e).hasMessage(customMessage);
        }
        try {
            assert.that((Decimal) null).isGreaterThanOrEqualsTo(0.0, customMessage);
            assert.expectedException();
        } catch (Exception e) {
            assert.that(e).hasMessage(customMessage);
        }
    }
    
    testmethod public static void test_isBetween() {
        assert.that(1.0).isBetween(0.0, 2.0);
        assert.that(1.0).isBetween(-1.0, 2.0);
        assert.that(1.0).isBetween(-3.0, 2.0);
        assert.that(-2.0).isBetween(-3.0, -1.0);
        assert.that(-2.0).isBetween(-3.0, 0.0);
        assert.that(-2.0).isBetween(-3.0, 3.0);
        
        assert.that(0.0).isBetween(-1.0, 1.0);
        assert.that(0.0).isBetween(-2.0, 1.0);

        try {
            assert.that(0.0).isBetween(1.0, 2.0);
            assert.expectedException();
        } catch (Exception e) {
            assert.that(e).hasMessage('Expected: <between> 1.0 and 2.0, Actual: 0.0');
        }
        try {
            assert.that(1.0).isBetween(-2.0, -1.0);
            assert.expectedException();
        } catch (Exception e) {
            assert.that(e).hasMessage('Expected: <between> -2.0 and -1.0, Actual: 1.0');
        }
        try { 
            assert.that((Decimal) null).isBetween(0.0, 1.0);
            assert.expectedException();
        } catch (Exception e) {
            assert.that(e).hasMessage('Expected: <between> 0.0 and 1.0, Actual: null');
        }

        assert.that(1.0).isBetween(0.0, 2.0, customMessage);
        assert.that(1.0).isBetween(-1.0, 2.0, customMessage);
        assert.that(1.0).isBetween(-3.0, 2.0, customMessage);
        assert.that(-2.0).isBetween(-3.0, -1.0, customMessage);
        assert.that(-2.0).isBetween(-3.0, 0.0, customMessage);
        assert.that(-2.0).isBetween(-3.0, 3.0, customMessage);
        
        assert.that(0.0).isBetween(-1.0, 1.0, customMessage);
        assert.that(0.0).isBetween(-2.0, 1.0, customMessage);

        try {
            assert.that(0.0).isBetween(1.0, 2.0, customMessage);
            assert.expectedException();
        } catch (Exception e) {
            assert.that(e).hasMessage(customMessage);
        }
        try {
            assert.that(1.0).isBetween(-2.0, -1.0, customMessage);
            assert.expectedException();
        } catch (Exception e) {
            assert.that(e).hasMessage(customMessage);
        }
        try { 
            assert.that((Decimal) null).isBetween(0.0, 1.0, customMessage);
            assert.expectedException();
        } catch (Exception e) {
            assert.that(e).hasMessage(customMessage);
        }
    }
    
    testmethod public static void test_isBetweenInclusive() {
        assert.that(1.0).isBetweenInclusive(1.0, 1.0);
        assert.that(1.0).isBetweenInclusive(0.0, 2.0);
        assert.that(1.0).isBetweenInclusive(0.0, 1.0);
        assert.that(1.0).isBetweenInclusive(1.0, 2.0);
        assert.that(-2.0).isBetweenInclusive(-2.0, -2.0);
        assert.that(-2.0).isBetweenInclusive(-2.0, -1.0);
        assert.that(-2.0).isBetweenInclusive(-3.0, -2.0);
        
        assert.that(0.0).isBetweenInclusive(0.0, 0.0);
        assert.that(0.0).isBetweenInclusive(-1.0, 0.0);
        assert.that(0.0).isBetweenInclusive(0.0, 1.0);
        assert.that(0.0).isBetweenInclusive(-1.0, 1.0);
        try {
            assert.that(0.0).isBetweenInclusive(1.0, 2.0);
            assert.expectedException();
        } catch (Exception e) {
            assert.that(e).hasMessage('Expected: <between (inclusive)> 1.0 and 2.0, Actual: 0.0');
        }
        try {
            assert.that(1.0).isBetweenInclusive(-2.0, -1.0);
            assert.expectedException();
        } catch (Exception e) {
            assert.that(e).hasMessage('Expected: <between (inclusive)> -2.0 and -1.0, Actual: 1.0');
        }
        try { 
            assert.that((Decimal) null).isBetweenInclusive(0.0, 1.0);
            assert.expectedException();
        } catch (Exception e) {
            assert.that(e).hasMessage('Expected: <between (inclusive)> 0.0 and 1.0, Actual: null');
        }

        assert.that(1.0).isBetweenInclusive(1.0, 1.0, customMessage);
        assert.that(1.0).isBetweenInclusive(0.0, 2.0, customMessage);
        assert.that(1.0).isBetweenInclusive(0.0, 1.0, customMessage);
        assert.that(1.0).isBetweenInclusive(1.0, 2.0, customMessage);
        assert.that(-2.0).isBetweenInclusive(-2.0, -2.0, customMessage);
        assert.that(-2.0).isBetweenInclusive(-2.0, -1.0, customMessage);
        assert.that(-2.0).isBetweenInclusive(-3.0, -2.0, customMessage);
        
        assert.that(0.0).isBetweenInclusive(0.0, 0.0, customMessage);
        assert.that(0.0).isBetweenInclusive(-1.0, 0.0, customMessage);
        assert.that(0.0).isBetweenInclusive(0.0, 1.0, customMessage);
        assert.that(0.0).isBetweenInclusive(-1.0, 1.0, customMessage);
        try {
            assert.that(0.0).isBetweenInclusive(1.0, 2.0, customMessage);
            assert.expectedException();
        } catch (Exception e) {
            assert.that(e).hasMessage(customMessage);
        }
        try {
            assert.that(1.0).isBetweenInclusive(-2.0, -1.0, customMessage);
            assert.expectedException();
        } catch (Exception e) {
            assert.that(e).hasMessage(customMessage);
        }
        try { 
            assert.that((Decimal) null).isBetweenInclusive(0.0, 1.0, customMessage);
            assert.expectedException();
        } catch (Exception e) {
            assert.that(e).hasMessage(customMessage);
        }
        
    }
    
}