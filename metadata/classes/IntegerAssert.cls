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
        return isLessThan(expected, format('Expected that actual [{0}] to be less than [{1}] but is not', actual, expected));
    }
    
    global IntegerAssert isLessThan(Integer other, String msg) {
        assert(actual < other, msg);
        return this;
    }

    global IntegerAssert isLessThanOrEqualsTo(Integer expected) {
        return isLessThanOrEqualsTo(expected, format('Expected that actual [{0}] to be less than or equals to [{1}] but is not', actual, expected));
    }
    
    global IntegerAssert isLessThanOrEqualsTo(Integer other, String msg) {
        assert(actual <= other, msg);
        return this;
    }

    global IntegerAssert isGreaterThan(Integer other) {
        return isGreaterThan(other, format('Expected that actual [{0}] to be greater than [{1}] but is not', actual, other));
    }
    
    global IntegerAssert isGreaterThan(Integer other, String msg) {
        assert(actual > other, msg);
        return this;
    }

    global IntegerAssert isGreaterThanOrEqualsTo(Integer other) {
        return isGreaterThanOrEqualsTo(other, format('Expected that actual [{0}] to be greater than or equals to [{1}] but is not', actual, other));
    }
    
    global IntegerAssert isGreaterThanOrEqualsTo(Integer other, String msg) {
        assert(actual >= other, msg);
        return this;
    }

    global IntegerAssert isBetweenInclusive(Integer start, Integer endValue) {
        return isBetweenInclusive(start, endValue, format('Expected that actual [{0}] to be between (inclusive) [{1}] and [{2}] but is not', actual, start, endValue));
    }
    
    global IntegerAssert isBetweenInclusive(Integer start, Integer endValue, String msg) {
        assert(actual >= start && actual <= endValue, msg);
        return this;
    }

    global IntegerAssert isBetween(Integer start, Integer endValue) {
        return isBetween(start, endValue, format('Expected that actual [{0}] to be between [{1}] and [{2}] but is not', actual, start, endValue));
    }
    
    global IntegerAssert isBetween(Integer start, Integer endValue, String msg) {
        assert(actual > start && actual < endValue, msg);
        return this;
    }

    private Integer toInteger(Object expected) {
        if (expected == null) {
            return null;
        }
        
        try {
            return Integer.valueOf(expected);
        } catch (Exception e) {
            throw assertFalse(format('The expected value [{0}] must be a valid Integer', expected));
        }
    }
}