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

    global DateTimeAssert isSameAs(DateTime other) {
        super.common_isSameAs(other);
        return this;
    }
    global DateTimeAssert isSameAs(DateTime other, String msg) {
        super.common_isSameAs(other, msg);
        return this;
    }

    global DateTimeAssert isNotSameAs(DateTime other) {
        super.common_isNotSameAs(other);
        return this;
    }
    global DateTimeAssert isNotSameAs(DateTime other, String msg) {
        super.common_isNotSameAs(other, msg);
        return this;
    }

    global DateTimeAssert isEqualsTo(String other) {
        return isEqualsTo(parseIsoDateTime(other));
    }
    global DateTimeAssert isEqualsTo(DateTime other) {
        super.common_isEqualsTo(other);
        return this;
    }
    global DateTimeAssert isEqualsTo(String other, String msg) {
        return isEqualsTo(parseIsoDateTime(other), msg);
    }
    global DateTimeAssert isEqualsTo(DateTime other, String msg) {
        super.common_isEqualsTo(other, msg);
        return this;
    }

    global DateTimeAssert isNotEqualsTo(String other) {
        return isNotEqualsTo(parseIsoDateTime(other));
    }
    global DateTimeAssert isNotEqualsTo(DateTime other) {
        super.common_isNotEqualsTo(other);
        return this;
    }
    global DateTimeAssert isNotEqualsTo(String other, String msg) {
        return isNotEqualsTo(parseIsoDateTime(other), msg);
    }
    global DateTimeAssert isNotEqualsTo(DateTime other, String msg) {
        super.common_isNotEqualsTo(other, msg);
        return this;
    }
    
    global DateTimeAssert isAfter(String other) {
        return isAfter(parseIsoDateTime(other));
    }
    global DateTimeAssert isAfter(DateTime other) {
        return isAfter(other, format('Expected that actual [{0}] is after [{1}] but is not', actual, other));
    }
    global DateTimeAssert isAfter(String other, String msg) {
        return isAfter(parseIsoDateTime(other), msg);
    }
    global DateTimeAssert isAfter(DateTime other, String msg) {
        isNotNull();
        otherIsNotNull(other);
        assert(actual > other, msg);
        return this;
    }

    global DateTimeAssert isOnOrAfter(String other) {
        return isOnOrAfter(parseIsoDateTime(other));
    }
    global DateTimeAssert isOnOrAfter(DateTime other) {
        return isOnOrAfter(other, format('Expected that actual [{0}] is on or after [{1}] but is not', actual, other));
    }
    global DateTimeAssert isOnOrAfter(String other, String msg) {
        return isOnOrAfter(parseIsoDateTime(other), msg);
    }
    global DateTimeAssert isOnOrAfter(DateTime other, String msg) {
        isNotNull();
        otherIsNotNull(other);
        assert(actual >= other, msg);
        return this;
    }

    global DateTimeAssert isBefore(String other) {
        return isBefore(parseIsoDateTime(other));
    }
    global DateTimeAssert isBefore(DateTime other) {
        return isBefore(other, format('Expected that actual [{0}] is before [{1}] but is not', actual, other));
    }
    global DateTimeAssert isBefore(String other, String msg) {
        return isBefore(parseIsoDateTime(other), msg);
    }
    global DateTimeAssert isBefore(DateTime other, String msg) {
        isNotNull();
        otherIsNotNull(other);
        assert(actual < other, msg);
        return this;
    }

    global DateTimeAssert isOnOrBefore(String other) {
        return isOnOrBefore(parseIsoDateTime(other));
    }
    global DateTimeAssert isOnOrBefore(DateTime other) {
        return isOnOrBefore(other, format('Expected that actual [{0}] is on or before [{1}] but is not', actual, other));
    }
    global DateTimeAssert isOnOrBefore(String other, String msg) {
        return isOnOrBefore(parseIsoDateTime(other), msg);
    }
    global DateTimeAssert isOnOrBefore(DateTime other, String msg) {
        isNotNull();
        otherIsNotNull(other);
        assert(actual <= other, msg);
        return this;
    }
    
    global DateTime parseIsoDateTime(String dateTimeString) {
        if (String.isBlank(dateTimeString)) {
            return null;
        }
        
        return (DateTime)Json.deserialize('"' + dateTimeString + '"', DateTime.class);
    }
 }