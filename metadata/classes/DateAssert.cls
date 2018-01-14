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

    global DateAssert isSameAs(Date other) {
        super.common_isSameAs(other);
        return this;
    }
    global DateAssert isSameAs(Date other, String msg) {
        super.common_isSameAs(other, msg);
        return this;
    }

    global DateAssert isNotSameAs(Date other) {
        super.common_isNotSameAs(other);
        return this;
    }
    global DateAssert isNotSameAs(Date other, String msg) {
        super.common_isNotSameAs(other, msg);
        return this;
    }

    global DateAssert isEqualsTo(String other) {
        return isEqualsTo(parseIsoDate(other));
    }
    global DateAssert isEqualsTo(Date other) {
        super.common_isEqualsTo(other);
        return this;
    }
    global DateAssert isEqualsTo(String other, String msg) {
        return isEqualsTo(parseIsoDate(other), msg);
    }
    global DateAssert isEqualsTo(Date other, String msg) {
        super.common_isEqualsTo(other, msg);
        return this;
    }

    global DateAssert isNotEqualsTo(String other) {
        return isNotEqualsTo(parseIsoDate(other));
    }
    global DateAssert isNotEqualsTo(Date other) {
        super.common_isNotEqualsTo(other);
        return this;
    }
    global DateAssert isNotEqualsTo(String other, String msg) {
        return isNotEqualsTo(parseIsoDate(other), msg);
    }
    global DateAssert isNotEqualsTo(Date other, String msg) {
        super.common_isNotEqualsTo(other, msg);
        return this;
    }
    
    global DateAssert isAfter(String other) {
        return isAfter(parseIsoDate(other));
    }
    global DateAssert isAfter(Date other) {
        return isAfter(other, format('Expected that actual [{0}] is after [{1}] but is not', actual, other));
    }
    global DateAssert isAfter(String other, String msg) {
        return isAfter(parseIsoDate(other), msg);
    }
    global DateAssert isAfter(Date other, String msg) {
        isNotNull();
        otherIsNotNull(other);
        assert(actual > other, msg);
        return this;
    }

    global DateAssert isOnOrAfter(String other) {
        return isOnOrAfter(parseIsoDate(other));
    }
    global DateAssert isOnOrAfter(Date other) {
        return isOnOrAfter(other, format('Expected that actual [{0}] is on or after [{1}] but is not', actual, other));
    }
    global DateAssert isOnOrAfter(String other, String msg) {
        return isOnOrAfter(parseIsoDate(other), msg);
    }
    global DateAssert isOnOrAfter(Date other, String msg) {
        isNotNull();
        otherIsNotNull(other);
        assert(actual >= other, msg);
        return this;
    }

    global DateAssert isBefore(String other) {
        return isBefore(parseIsoDate(other));
    }
    global DateAssert isBefore(Date other) {
        return isBefore(other, format('Expected that actual [{0}] is before [{1}] but is not', actual, other));
    }
    global DateAssert isBefore(String other, String msg) {
        return isBefore(parseIsoDate(other), msg);
    }
    global DateAssert isBefore(Date other, String msg) {
        isNotNull();
        otherIsNotNull(other);
        assert(actual < other, msg);
        return this;
    }

    global DateAssert isOnOrBefore(String other) {
        return isOnOrBefore(parseIsoDate(other));
    }
    global DateAssert isOnOrBefore(Date other) {
        return isOnOrBefore(other, format('Expected that actual [{0}] is on or before [{1}] but is not', actual, other));
    }
    global DateAssert isOnOrBefore(String other, String msg) {
        return isOnOrBefore(parseIsoDate(other), msg);
    }
    global DateAssert isOnOrBefore(Date other, String msg) {
        isNotNull();
        otherIsNotNull(other);
        assert(actual <= other, msg);
        return this;
    }
    
    global Date parseIsoDate(String dateString) {
        if (String.isBlank(dateString)) {
            return null;
        }
        
        return (Date)Json.deserialize('"' + dateString + '"', Date.class);
    }
}