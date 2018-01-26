global class IntegerAssert extends BaseAssert {
    private Integer actual;
    
    public IntegerAssert(Asserter asserter, Integer actual) {
        super(asserter, actual);
        this.actual = actual;
    }
    
    global IntegerAssert isNull() {
        common_isNull();
        return this;
    }
	global IntegerAssert isNull(String msg) {
        common_isNull(msg);
        return this;
    }
    
    global IntegerAssert isNotNull() {
        common_isNotNull();
        return this;
    }
    global IntegerAssert isNotNull(String msg) {
        common_isNotNull(msg);
        return this;
    }
    
    global IntegerAssert isEqualsTo(Integer expected) {
        common_isEqualsTo(toInteger(expected));
        return this;
    }
    global IntegerAssert isEqualsTo(Integer expected, String msg) {
        common_isEqualsTo(toInteger(expected), msg);
        return this;
    }
    
    global IntegerAssert isNotEqualsTo(Integer expected) {
        common_isNotEqualsTo(toInteger(expected));
        return this;
    }
    global IntegerAssert isNotEqualsTo(Integer expected, String msg) {
        common_isNotEqualsTo(toInteger(expected), msg);
        return this;
    }
    
    global IntegerAssert isZero() {
    	return isEqualsTo(0);
    }
    
    global IntegerAssert isZero(String msg) {
    	return isEqualsTo(0, msg);
    }

    global IntegerAssert isNotZero() {
	    return isNotEqualsTo(0);
    }
    
    global IntegerAssert isNotZero(String msg) {
	    return isNotEqualsTo(0, msg);
    }

    global IntegerAssert isOne() {
	    return isEqualsTo(1);
    }

    global IntegerAssert isOne(String msg) {
	    return isEqualsTo(1, msg);
    }

    global IntegerAssert isNotOne() {
	    return isNotEqualsTo(1);
    }
    
    global IntegerAssert isNotOne(String msg) {
	    return isNotEqualsTo(1, msg);
    }

    global IntegerAssert isPositive() {
        return isGreaterThan(0);
    }
    
    global IntegerAssert isPositive(String msg) {
        return isGreaterThan(0, msg);
    }

    global IntegerAssert isNegative() {
        return isLessThan(0);
    }
    
    global IntegerAssert isNegative(String msg) {
        return isLessThan(0, msg);
    }

    global IntegerAssert isLessThan(Integer expected) {
        return isLessThan(expected, format('Expected: <less than> {0}, Actual: {1}', expected, actual));
    }
    
    global IntegerAssert isLessThan(Integer other, String msg) {
        assert(actual < other, msg);
        return this;
    }

    global IntegerAssert isLessThanOrEqualsTo(Integer expected) {
        return isLessThanOrEqualsTo(expected, format('Expected: <less than or equals to> {0}, Actual: {1}', expected, actual));
    }
    
    global IntegerAssert isLessThanOrEqualsTo(Integer expected, String msg) {
        assert(actual <= expected, msg);
        return this;
    }

    global IntegerAssert isGreaterThan(Integer expected) {
        return isGreaterThan(expected, format('Expected: <greater than> {0}, Actual: {1}', expected, actual));
    }
    
    global IntegerAssert isGreaterThan(Integer expected, String msg) {
        assert(actual > expected, msg);
        return this;
    }

    global IntegerAssert isGreaterThanOrEqualsTo(Integer expected) {
        return isGreaterThanOrEqualsTo(expected, format('Expected: <greater than or equals to> {0}, Actual: {1}', expected, actual));
    }
    
    global IntegerAssert isGreaterThanOrEqualsTo(Integer expected, String msg) {
        assert(actual >= expected, msg);
        return this;
    }

    global IntegerAssert isBetweenInclusive(Integer startValue, Integer endValue) {
        return isBetweenInclusive(startValue, endValue, format('Expected: <between (inclusive)> {0} and {1}, Actual: {2}', startValue, endValue, actual));
    }
    
    global IntegerAssert isBetweenInclusive(Integer startValue, Integer endValue, String msg) {
        assert(actual >= startValue && actual <= endValue, msg);
        return this;
    }

    global IntegerAssert isBetween(Integer startValue, Integer endValue) {
        return isBetween(startValue, endValue, format('Expected: <between> {0} and {1}, Actual: {2}', startValue, endValue, actual));
    }
    
    global IntegerAssert isBetween(Integer startValue, Integer endValue, String msg) {
        assert(actual > startValue && actual < endValue, msg);
        return this;
    }

    private Integer toInteger(Object expected) {
        if (expected == null) {
            return null;
        }
        
        try {
            return Integer.valueOf(expected);
        } catch (Exception e) {
            throw assertFalse(format('Expected: <valid integer>, Actual: {0}', expected));
        }
    }
}