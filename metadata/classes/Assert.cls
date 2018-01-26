global class Assert {
    private Asserter asserter = new Asserter();
    
    public Assert() {
        //public constructor so it can only be created from sf.cls
    }
    
    global Assert setMultiAssert(boolean multi) {
        asserter.multi = multi;
        return this;
    }
    
    global Assert setUseCustomException(boolean useCustom) {
        asserter.useCustomException = useCustom;
        return this;
    }
    
    global StringAssert that(String actual) {
        return new StringAssert(asserter, actual);
    }
    global IntegerAssert that(Integer actual) {
        return new IntegerAssert(asserter, actual);
    }
    global DecimalAssert that(Decimal actual) {
        return new DecimalAssert(asserter, actual);
    }
    global BooleanAssert that(Boolean actual) {
        return new BooleanAssert(asserter, actual);
    }
    global DateAssert that(Date actual) {
        return new DateAssert(asserter, actual);
    }
    global DatetimeAssert that(Datetime actual) {
        return new DatetimeAssert(asserter, actual);
    }
    global ObjectAssert that(Object actual) {
        return new ObjectAssert(asserter, actual);
    }
    global ExceptionAssert that(Exception actual) {
        return new ExceptionAssert(asserter, actual);
    }
    
    global Assert fail(String message) {
        asserter.assert(false, message);
        return this;
    }
    
    global Assert fail() {
        asserter.assert(false, 'Failed without message');
        return this;
    }

    global Assert check(Boolean result) {
        asserter.assert(result, 'Assertion failed');
        return this;
    }
    global Assert check(Boolean result, String message) {
        asserter.assert(result, message);
        return this;
    }

    global Assert expectedException(System.Type cls) {
        asserter.assert(false, String.format('Expected: <exception of type> {0}, Actual: <not thrown>', new List<String>{cls.toString()}));
        return this;
    }
    
    global Assert expectedException() {
        asserter.assert(false, 'Expected: <an exception>, Actual: <not thrown>');
        return this;
    }
    global Assert expectedException(String msg) {
        asserter.assert(false, msg);
        return this;
    }
    
    global Assert evaluate() {
        asserter.evaluate();
         return this;
   }
}