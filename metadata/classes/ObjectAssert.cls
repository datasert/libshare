global virtual class ObjectAssert extends BaseAssert {
    private Object actual;

    public ObjectAssert(Asserter asserter, Object actual) {
        super(asserter, actual);
        this.actual = actual;
    }
    
    global ObjectAssert isNull() {
        super.common_isNull();
        return this;
    }

    global ObjectAssert isNull(String msg) {
        super.common_isNull(msg);
        return this;
    }

    global ObjectAssert isNotNull() {
        super.common_isNotNull();
        return this;
    }

    global ObjectAssert isNotNull(String msg) {
        super.common_isNotNull(msg);
        return this;
    }

    global ObjectAssert isSameAs(Object other) {
        super.common_isSameAs(other);
        return this;
    }
        
    global ObjectAssert isSameAs(Object other, String msg) {
        super.common_isSameAs(other, msg);
        return this;
    }

    global ObjectAssert isNotSameAs(Object other) {
        super.common_isNotSameAs(other);
        return this;
    }
        
    global ObjectAssert isNotSameAs(Object other, String msg) {
        super.common_isNotSameAs(other, msg);
        return this;
    }

    global ObjectAssert isEqualsTo(Object other) {
        super.common_isEqualsTo(other);
        return this;
    }

    global ObjectAssert isEqualsTo(Object other, String msg) {
        super.common_isEqualsTo(other, msg);
        return this;
    }

    global ObjectAssert isNotEqualsTo(Object other) {
        super.common_isNotEqualsTo(other);
        return this;
    }

    global ObjectAssert isNotEqualsTo(Object other, String msg) {
        super.common_isNotEqualsTo(other, msg);
        return this;
    }
}