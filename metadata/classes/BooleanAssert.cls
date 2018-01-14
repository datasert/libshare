global class BooleanAssert extends BaseAssert {
    private Boolean actual;
    
    public BooleanAssert(Asserter asserter, Boolean actual) {
        super(asserter, actual);
        this.actual = actual;
    }
    
    global BooleanAssert isNull() {
        super.common_isNull();
        return this;
    }

    global BooleanAssert isNull(String msg) {
        super.common_isNull(msg);
        return this;
    }

    global BooleanAssert isNotNull() {
        super.common_isNotNull();
        return this;
    }

    global BooleanAssert isNotNull(String msg) {
        super.common_isNotNull(msg);
        return this;
    }

    global BooleanAssert isTrue() {
        isEqualsTo(true);
        return this;
    }
        
    global BooleanAssert isTrue(String msg) {
        isEqualsTo(true, msg);
        return this;
    }

    global BooleanAssert isFalse() {
        isEqualsTo(false);
        return this;
    }
    
    global BooleanAssert isFalse(String msg) {
        isEqualsTo(false, msg);
        return this;
    }

    global BooleanAssert isEqualsTo(Boolean other) {
        super.common_isEqualsTo(other);
        return this;
    }

    global BooleanAssert isEqualsTo(Boolean other, String msg) {
        super.common_isEqualsTo(other, msg);
        return this;
    }

    global BooleanAssert isNotEqualsTo(Boolean other) {
        super.common_isNotEqualsTo(other);
        return this;
    }

    global BooleanAssert isNotEqualsTo(Boolean other, String msg) {
        super.common_isNotEqualsTo(other, msg);
        return this;
    }
}