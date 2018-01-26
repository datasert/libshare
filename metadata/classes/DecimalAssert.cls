global class DecimalAssert extends BaseAssert {
    private Decimal actual;
    
    public DecimalAssert(Asserter asserter,Decimal actual) {
        super(asserter, actual);
        this.actual = actual;
    }
    
    global DecimalAssert isNull() {
        common_isNull();
        return this;
    }
	global DecimalAssert isNull(String msg) {
        common_isNull(msg);
        return this;
    }
    
    global DecimalAssert isNotNull() {
        common_isNotNull();
        return this;
    }
    global DecimalAssert isNotNull(String msg) {
        common_isNotNull(msg);
        return this;
    }
    
    global DecimalAssert isEqualsTo(Decimal expected) {
        common_isEqualsTo(toDecimal(expected));
        return this;
    }
    global DecimalAssert isEqualsTo(Decimal expected, String msg) {
        common_isEqualsTo(toDecimal(expected), msg);
        return this;
    }
    
    global DecimalAssert isNotEqualsTo(Decimal expected) {
        common_isNotEqualsTo(toDecimal(expected));
        return this;
    }
    global DecimalAssert isNotEqualsTo(Decimal expected, String msg) {
        common_isNotEqualsTo(toDecimal(expected), msg);
        return this;
    }
    
    global DecimalAssert isZero() {
    	return isEqualsTo(0);
    }
    
    global DecimalAssert isZero(String msg) {
    	return isEqualsTo(0, msg);
    }

    global DecimalAssert isNotZero() {
	    return isNotEqualsTo(0);
    }
    
    global DecimalAssert isNotZero(String msg) {
	    return isNotEqualsTo(0, msg);
    }

    global DecimalAssert isOne() {
	    return isEqualsTo(1);
    }

    global DecimalAssert isOne(String msg) {
	    return isEqualsTo(1, msg);
    }

    global DecimalAssert isNotOne() {
	    return isNotEqualsTo(1);
    }
    
    global DecimalAssert isNotOne(String msg) {
	    return isNotEqualsTo(1, msg);
    }

    global DecimalAssert isPositive() {
        return isGreaterThan(0);
    }
    
    global DecimalAssert isPositive(String msg) {
        return isGreaterThan(0, msg);
    }

    global DecimalAssert isNegative() {
        return isLessThan(0);
    }
    
    global DecimalAssert isNegative(String msg) {
        return isLessThan(0, msg);
    }

    global DecimalAssert isLessThan(Decimal expected) {
        return isLessThan(expected, format('Expected: <less than> {0}, Actual: {1}', expected, actual));
    }
    
    global DecimalAssert isLessThan(Decimal expected, String msg) {
        assert(actual < expected, msg);
        return this;
    }

    global DecimalAssert isLessThanOrEqualsTo(Decimal expected) {
        return isLessThanOrEqualsTo(expected, format('Expected: <less than or equals to> {0}, Actual: {1}', expected, actual));
    }
    
    global DecimalAssert isLessThanOrEqualsTo(Decimal expected, String msg) {
        assert(actual <= expected, msg);
        return this;
    }

    global DecimalAssert isGreaterThan(Decimal expected) {
        return isGreaterThan(expected, format('Expected: <greater than> {0}, Actual: {1}', expected, actual));
    }
    
    global DecimalAssert isGreaterThan(Decimal expected, String msg) {
        assert(actual > expected, msg);
        return this;
    }

    global DecimalAssert isGreaterThanOrEqualsTo(Decimal expected) {
        return isGreaterThanOrEqualsTo(expected, format('Expected: <greater than or equals to> {0}, Actual: {1}', expected, actual));
    }
    
    global DecimalAssert isGreaterThanOrEqualsTo(Decimal expected, String msg) {
        assert(actual >= expected, msg);
        return this;
    }

    global DecimalAssert isBetweenInclusive(Decimal startValue, Decimal endValue) {
        return isBetweenInclusive(startValue, endValue, format('Expected: <between (inclusive)> {0} and {1}, Actual: {2}', startValue, endValue, actual));
    }
    
    global DecimalAssert isBetweenInclusive(Decimal startValue, Decimal endValue, String msg) {
        assert(actual >= startValue && actual <= endValue, msg);
        return this;
    }

    global DecimalAssert isBetween(Decimal startValue, Decimal endValue) {
        return isBetween(startValue, endValue, format('Expected: <between> {0} and {1}, Actual: {2}', startValue, endValue, actual));
    }
    
    global DecimalAssert isBetween(Decimal startValue, Decimal endValue, String msg) {
        assert(actual > startValue && actual < endValue, msg);
        return this;
    }

    private Decimal toDecimal(Object expected) {
        if (expected == null) {
            return null;
        }
        
        try {
            return Decimal.valueOf(String.valueOf(expected));
        } catch (Exception e) {
            throw assertFalse(format('Expected {0} must be a valid Decimal', expected));
        }
    }
}