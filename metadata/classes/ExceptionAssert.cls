global class ExceptionAssert extends BaseAssert {
	
    private Exception actual;
    
    public ExceptionAssert(Asserter asserter, Exception actual) {
        super(asserter, actual);
        this.actual = actual;
    }
    
    global ExceptionAssert hasMessage(String message) {
        return hasMessage(message, format('Expected that exception message [{0}] to be equals to [{1}] but is not', actual.getMessage(), message));
    }
    
    global ExceptionAssert hasMessage(String message, String failMsg) {
        otherIsNotNull(message);
        assert(actual.getMessage() == message, failMsg);
        
        return this;	
    }

    global ExceptionAssert hasCause() {
        return hasCause(format('Expected that actual [{0}] has a cause but does not', actual));
    }
    
    global ExceptionAssert hasCause(String msg) {
        assert(actual.getCause() != null, msg);
        return this;
    }
    
    global ExceptionAssert hasNoCause() {
        return hasNoCause(format('Expected that actual [{0}] has no cause but has', actual));
    }
    
    global ExceptionAssert hasNoCause(String msg) {
        assert(actual.getCause() == null, msg);
        return this;
    }
    
    global StringAssert getMessage() {
        return new StringAssert(asserter, actual.getMessage());
    }
    
    global ExceptionAssert getCause() {
        return new ExceptionAssert(asserter, actual.getCause());
    }
    
    private Exception getRootCause(Exception e) {
        if (e != null && e.getCause() != null) {
            return getRootCause(e.getCause());
        }
        
        return e;
    }
    
    global ExceptionAssert getRootCause() {
        return new ExceptionAssert(asserter, getRootCause(actual.getCause()));
    }
}