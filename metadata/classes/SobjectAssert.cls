global virtual class SobjectAssert extends BaseAssert {
    private Sobject actual;

    public SobjectAssert(Asserter asserter, Sobject actual) {
        super(asserter, actual);
        this.actual = actual;
    }
    
    global SobjectAssert isNull() {
        super.common_isNull();
        return this;
    }

    global SobjectAssert isNull(String msg) {
        super.common_isNull(msg);
        return this;
    }

    global SobjectAssert isNotNull() {
        super.common_isNotNull();
        return this;
    }

    global SobjectAssert isNotNull(String msg) {
        super.common_isNotNull(msg);
        return this;
    }

    global SobjectAssert isSameAs(Sobject other) {
        super.common_isSameAs(other);
        return this;
    }
    
    global SobjectAssert isSameAs(Sobject other, String msg) {
        super.common_isSameAs(other, msg);
        return this;
    }

    global SobjectAssert isNotSameAs(Sobject other) {
        super.common_isNotSameAs(other);
        return this;
    }
        
    global SobjectAssert isNotSameAs(Sobject other, String msg) {
        super.common_isNotSameAs(other, msg);
        return this;
    }

    global SobjectAssert isEqualsTo(Sobject other) {
        super.common_isEqualsTo(other);
        return this;
    }

    global SobjectAssert isEqualsTo(Sobject other, String msg) {
        super.common_isEqualsTo(other, msg);
        return this;
    }

    global SobjectAssert isNotEqualsTo(Sobject other) {
        super.common_isNotEqualsTo(other);
        return this;
    }

    global SobjectAssert isNotEqualsTo(Sobject other, String msg) {
        super.common_isNotEqualsTo(other, msg);
        return this;
    }

    global SobjectAssert hasNotBlankFields(List<String> fields, String msg) {
        return this;
    }

    global SobjectAssert hasFields(Map<String, Object> fields) {
        return this;
    }

    global SobjectAssert hasFields(Map<String, Object> fields, String msg) {
        return this;
    }
}