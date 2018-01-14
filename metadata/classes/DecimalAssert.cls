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
        return isLessThan(expected, format('Expected that actual [{0}] to be less than [{1}] but is not', actual, expected));
    }
    
    global DecimalAssert isLessThan(Decimal other, String msg) {
        assert(actual < other, msg);
        return this;
    }

    global DecimalAssert isLessThanOrEqualsTo(Decimal expected) {
        return isLessThanOrEqualsTo(expected, format('Expected that actual [{0}] to be less than or equals to [{1}] but is not', actual, expected));
    }
    
    global DecimalAssert isLessThanOrEqualsTo(Decimal other, String msg) {
        assert(actual <= other, msg);
        return this;
    }

    global DecimalAssert isGreaterThan(Decimal other) {
        return isGreaterThan(other, format('Expected that actual [{0}] to be greater than [{1}] but is not', actual, other));
    }
    
    global DecimalAssert isGreaterThan(Decimal other, String msg) {
        assert(actual > other, msg);
        return this;
    }

    global DecimalAssert isGreaterThanOrEqualsTo(Decimal other) {
        return isGreaterThanOrEqualsTo(other, format('Expected that actual [{0}] to be greater than or equals to [{1}] but is not', actual, other));
    }
    
    global DecimalAssert isGreaterThanOrEqualsTo(Decimal other, String msg) {
        assert(actual >= other, msg);
        return this;
    }

    global DecimalAssert isBetweenInclusive(Decimal start, Decimal endValue) {
        return isBetweenInclusive(start, endValue, format('Expected that actual [{0}] to be between (inclusive) [{1}] and [{2}] but is not', actual, start, endValue));
    }
    
    global DecimalAssert isBetweenInclusive(Decimal start, Decimal endValue, String msg) {
        assert(actual >= start && actual <= endValue, msg);
        return this;
    }

    global DecimalAssert isBetween(Decimal start, Decimal endValue) {
        return isBetween(start, endValue, format('Expected that actual [{0}] to be between [{1}] and [{2}] but is not', actual, start, endValue));
    }
    
    global DecimalAssert isBetween(Decimal start, Decimal endValue, String msg) {
        assert(actual > start && actual < endValue, msg);
        return this;
    }

    private Decimal toDecimal(Object expected) {
        if (expected == null) {
            return null;
        }
        
        try {
            return Decimal.valueOf(String.valueOf(expected));
        } catch (Exception e) {
            throw assertFalse(format('The expected value [{0}] must be a valid Decimal', expected));
        }
    }
}