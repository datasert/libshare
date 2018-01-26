global class DateAssert extends BaseAssert {
    private Date actual;
    
    public DateAssert(Asserter asserter, Date actual) {
        super(asserter, actual);
        this.actual = actual;
    }
    
    global DateAssert isNull() {
        super.common_isNull();
        return this;
    }

    global DateAssert isNull(String msg) {
        super.common_isNull(msg);
        return this;
    }

    global DateAssert isNotNull() {
        super.common_isNotNull();
        return this;
    }
    global DateAssert isNotNull(String msg) {
        super.common_isNotNull(msg);
        return this;
    }

    global DateAssert isSameAs(Date expected) {
        super.common_isSameAs(expected);
        return this;
    }
    global DateAssert isSameAs(Date expected, String msg) {
        super.common_isSameAs(expected, msg);
        return this;
    }

    global DateAssert isNotSameAs(Date expected) {
        super.common_isNotSameAs(expected);
        return this;
    }
    global DateAssert isNotSameAs(Date expected, String msg) {
        super.common_isNotSameAs(expected, msg);
        return this;
    }

    global DateAssert isEqualsTo(String expected) {
        return isEqualsTo(parseIsoDate(expected));
    }
    global DateAssert isEqualsTo(Date expected) {
        super.common_isEqualsTo(expected);
        return this;
    }
    global DateAssert isEqualsTo(String expected, String msg) {
        return isEqualsTo(parseIsoDate(expected), msg);
    }
    global DateAssert isEqualsTo(Date expected, String msg) {
        super.common_isEqualsTo(expected, msg);
        return this;
    }

    global DateAssert isNotEqualsTo(String expected) {
        return isNotEqualsTo(parseIsoDate(expected));
    }
    global DateAssert isNotEqualsTo(Date expected) {
        super.common_isNotEqualsTo(expected);
        return this;
    }
    global DateAssert isNotEqualsTo(String expected, String msg) {
        return isNotEqualsTo(parseIsoDate(expected), msg);
    }
    global DateAssert isNotEqualsTo(Date expected, String msg) {
        super.common_isNotEqualsTo(expected, msg);
        return this;
    }
    
    global DateAssert isAfter(String expected) {
        return isAfter(parseIsoDate(expected));
    }
    global DateAssert isAfter(Date expected) {
        return isAfter(expected, format('Expected: <after> {0}, Actual: {1}', expected, actual));
    }
    global DateAssert isAfter(String expected, String msg) {
        return isAfter(parseIsoDate(expected), msg);
    }
    global DateAssert isAfter(Date expected, String msg) {
        isNotNull();
        expectedIsNotNull(expected);
        assert(actual > expected, msg);
        return this;
    }

    global DateAssert isOnOrAfter(String expected) {
        return isOnOrAfter(parseIsoDate(expected));
    }
    global DateAssert isOnOrAfter(Date expected) {
        return isOnOrAfter(expected, format('Expected: <on or after> {0}, Actual: {1}', expected, actual));
    }
    global DateAssert isOnOrAfter(String expected, String msg) {
        return isOnOrAfter(parseIsoDate(expected), msg);
    }
    global DateAssert isOnOrAfter(Date expected, String msg) {
        isNotNull();
        expectedIsNotNull(expected);
        assert(actual >= expected, msg);
        return this;
    }

    global DateAssert isBefore(String expected) {
        return isBefore(parseIsoDate(expected));
    }
    global DateAssert isBefore(Date expected) {
        return isBefore(expected, format('Expected: <before> {0}, Actual: {1}', expected, actual));
    }
    global DateAssert isBefore(String expected, String msg) {
        return isBefore(parseIsoDate(expected), msg);
    }
    global DateAssert isBefore(Date expected, String msg) {
        isNotNull();
        expectedIsNotNull(expected);
        assert(actual < expected, msg);
        return this;
    }

    global DateAssert isOnOrBefore(String expected) {
        return isOnOrBefore(parseIsoDate(expected));
    }
    global DateAssert isOnOrBefore(Date expected) {
        return isOnOrBefore(expected, format('Expected: <on or before> {0}, Actual: {1}', expected, actual));
    }
    global DateAssert isOnOrBefore(String expected, String msg) {
        return isOnOrBefore(parseIsoDate(expected), msg);
    }
    global DateAssert isOnOrBefore(Date expected, String msg) {
        isNotNull();
        expectedIsNotNull(expected);
        assert(actual <= expected, msg);
        return this;
    }
    
    global Date parseIsoDate(String dateString) {
        if (String.isBlank(dateString)) {
            return null;
        }
        
        return (Date)Json.deserialize('"' + dateString + '"', Date.class);
    }
}