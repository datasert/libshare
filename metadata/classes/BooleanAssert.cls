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

    global BooleanAssert isEqualsTo(Boolean expected) {
        super.common_isEqualsTo(expected);
        return this;
    }

    global BooleanAssert isEqualsTo(Boolean expected, String msg) {
        super.common_isEqualsTo(expected, msg);
        return this;
    }

    global BooleanAssert isNotEqualsTo(Boolean expected) {
        super.common_isNotEqualsTo(expected);
        return this;
    }

    global BooleanAssert isNotEqualsTo(Boolean expected, String msg) {
        super.common_isNotEqualsTo(expected, msg);
        return this;
    }
}