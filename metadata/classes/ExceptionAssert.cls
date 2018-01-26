global class ExceptionAssert extends BaseAssert {
	
    private Exception actual;
    
    public ExceptionAssert(Asserter asserter, Exception actual) {
        super(asserter, actual);
        this.actual = actual;
    }
    
    global ExceptionAssert hasMessage(String message) {
        return hasMessage(message, format('Expected: <exception with message> {0}, Actual: {1}', message, actual.getMessage()));
    }
    
    global ExceptionAssert hasMessage(String message, String failMsg) {
        expectedIsNotNull(message);
        assert(actual.getMessage() == message, failMsg);
        
        return this;	
    }

    global ExceptionAssert hasCause() {
        return hasCause(format('Expected: <exception with a cause>, Actual: <without any cause>', actual));
    }
    
    global ExceptionAssert hasCause(String msg) {
        assert(actual.getCause() != null, msg);
        return this;
    }
    
    global ExceptionAssert hasNoCause() {
        return hasNoCause(format('Expected: <exception without any cause>, Actual: <has cause>', actual));
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