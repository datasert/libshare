global class DateTimeAssert extends BaseAssert {
    private DateTime actual;
    
    public DateTimeAssert(Asserter asserter, DateTime actual) {
        super(asserter, actual);
        this.actual = actual;
    }
    
    global DateTimeAssert isNull() {
        super.common_isNull();
        return this;
    }

    global DateTimeAssert isNull(String msg) {
        super.common_isNull(msg);
        return this;
    }

    global DateTimeAssert isNotNull() {
        super.common_isNotNull();
        return this;
    }

    global DateTimeAssert isNotNull(String msg) {
        super.common_isNotNull(msg);
        return this;
    }

    global DateTimeAssert isSameAs(DateTime expected) {
        super.common_isSameAs(expected);
        return this;
    }
    global DateTimeAssert isSameAs(DateTime expected, String msg) {
        super.common_isSameAs(expected, msg);
        return this;
    }

    global DateTimeAssert isNotSameAs(DateTime expected) {
        super.common_isNotSameAs(expected);
        return this;
    }
    global DateTimeAssert isNotSameAs(DateTime expected, String msg) {
        super.common_isNotSameAs(expected, msg);
        return this;
    }

    global DateTimeAssert isEqualsTo(String expected) {
        return isEqualsTo(parseIsoDateTime(expected));
    }
    global DateTimeAssert isEqualsTo(DateTime expected) {
        super.common_isEqualsTo(expected);
        return this;
    }
    global DateTimeAssert isEqualsTo(String expected, String msg) {
        return isEqualsTo(parseIsoDateTime(expected), msg);
    }
    global DateTimeAssert isEqualsTo(DateTime expected, String msg) {
        super.common_isEqualsTo(expected, msg);
        return this;
    }

    global DateTimeAssert isNotEqualsTo(String expected) {
        return isNotEqualsTo(parseIsoDateTime(expected));
    }
    global DateTimeAssert isNotEqualsTo(DateTime expected) {
        super.common_isNotEqualsTo(expected);
        return this;
    }
    global DateTimeAssert isNotEqualsTo(String expected, String msg) {
        return isNotEqualsTo(parseIsoDateTime(expected), msg);
    }
    global DateTimeAssert isNotEqualsTo(DateTime expected, String msg) {
        super.common_isNotEqualsTo(expected, msg);
        return this;
    }
    
    global DateTimeAssert isAfter(String expected) {
        return isAfter(parseIsoDateTime(expected));
    }
    global DateTimeAssert isAfter(DateTime expected) {
        return isAfter(expected, format('Expected that actual [{0}] is after [{1}] but is not', actual, expected));
    }
    global DateTimeAssert isAfter(String expected, String msg) {
        return isAfter(parseIsoDateTime(expected), msg);
    }
    global DateTimeAssert isAfter(DateTime expected, String msg) {
        isNotNull();
        expectedIsNotNull(expected);
        assert(actual > expected, msg);
        return this;
    }

    global DateTimeAssert isOnOrAfter(String expected) {
        return isOnOrAfter(parseIsoDateTime(expected));
    }
    global DateTimeAssert isOnOrAfter(DateTime expected) {
        return isOnOrAfter(expected, format('Expected that actual [{0}] is on or after [{1}] but is not', actual, expected));
    }
    global DateTimeAssert isOnOrAfter(String expected, String msg) {
        return isOnOrAfter(parseIsoDateTime(expected), msg);
    }
    global DateTimeAssert isOnOrAfter(DateTime expected, String msg) {
        isNotNull();
        expectedIsNotNull(expected);
        assert(actual >= expected, msg);
        return this;
    }

    global DateTimeAssert isBefore(String expected) {
        return isBefore(parseIsoDateTime(expected));
    }
    global DateTimeAssert isBefore(DateTime expected) {
        return isBefore(expected, format('Expected that actual [{0}] is before [{1}] but is not', actual, expected));
    }
    global DateTimeAssert isBefore(String expected, String msg) {
        return isBefore(parseIsoDateTime(expected), msg);
    }
    global DateTimeAssert isBefore(DateTime expected, String msg) {
        isNotNull();
        expectedIsNotNull(expected);
        assert(actual < expected, msg);
        return this;
    }

    global DateTimeAssert isOnOrBefore(String expected) {
        return isOnOrBefore(parseIsoDateTime(expected));
    }
    global DateTimeAssert isOnOrBefore(DateTime expected) {
        return isOnOrBefore(expected, format('Expected that actual [{0}] is on or before [{1}] but is not', actual, expected));
    }
    global DateTimeAssert isOnOrBefore(String expected, String msg) {
        return isOnOrBefore(parseIsoDateTime(expected), msg);
    }
    global DateTimeAssert isOnOrBefore(DateTime expected, String msg) {
        isNotNull();
        expectedIsNotNull(expected);
        assert(actual <= expected, msg);
        return this;
    }
    
    global DateTime parseIsoDateTime(String dateTimeString) {
        if (String.isBlank(dateTimeString)) {
            return null;
        }
        
        return (DateTime)Json.deserialize('"' + dateTimeString + '"', DateTime.class);
    }
 }