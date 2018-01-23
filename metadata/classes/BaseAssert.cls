public virtual class BaseAssert {
	private Object actual;
    protected Asserter asserter;
    
    public BaseAssert(Asserter asserter, Object actual) {
        this.actual = actual;
        this.asserter = asserter;
    }
    
    public virtual BaseAssert common_isNull() {
		return common_isNull(format('Expected that actual [{0}] to be [null] but is not', actual));
    }

    public virtual BaseAssert common_isNull(String msg) {
        assert(actual == null, msg);
        return this;
    }

    public virtual BaseAssert common_isNotNull() {
		return common_isNotNull('Expected that actual to be not [null] but is');
    }
    
    public virtual BaseAssert common_isNotNull(String msg) {
        assert(actual != null, msg);
        return this;
    }

    public virtual BaseAssert common_isEqualsTo(Object expected) {
        return common_isEqualsTo(expected, format('Expected: [{0}] Actual: [{1}]', expected, actual));
    }

    public virtual BaseAssert common_isEqualsTo(Object expected, String msg) {
        if (actual == null && expected == null) {
            return this;
        }
        
        if (actual == null || expected == null) {
            throw assertFalse(msg);
        }
        
        if (actual instanceof String) {
            assert(((String) actual).equals(String.valueOf(expected)), msg);
        } else {
			assert(actual.equals(expected), msg);
        }
        return this;
    }

    public virtual BaseAssert common_isNotEqualsTo(Object expected) {
        return common_isNotEqualsTo(expected, format('Expected that actual [{0}] to be not equals to [{1}] but is', actual, expected));
    }

    public virtual BaseAssert common_isNotEqualsTo(Object expected, String msg) {
        if (actual == null && expected == null) {
            assertFalse(msg);
        }
        
        if (actual == null || expected == null) {
            return this;
        }
        
        if (actual instanceof String) {
            assert(!((String) actual).equals(String.valueOf(expected)), msg);
        } else {
			assert(!actual.equals(expected), msg);
        }
        return this;
    }

    public virtual BaseAssert common_isSameAs(Object expected) {
        return common_isSameAs(expected, format('Expected that actual [{0}] to be same as [{1}] but is not', actual, expected));
    }

    public virtual BaseAssert common_isSameAs(Object expected, String msg) {
        if (actual !== expected) {
			assertFalse(msg);
        }
        
        return this;
    }

    public virtual BaseAssert common_isNotSameAs(Object expected) {
        return common_isNotSameAs(expected, format('Expected that actual [{0}] to be not same as [{1}] but is', actual, expected));
    }
    
    public virtual BaseAssert common_isNotSameAs(Object expected, String msg) {
        if (actual === expected) {
			assertFalse(msg);
        }
        
        return this;
    }

    public void assert(Boolean value, String message) {
        asserter.assert(value, message);
    }

    public AssertException assertFalse(String message) {
        asserter.assert(false, message);
        return new AssertException('Never thrown this');
    }

    public String format (String message, Object arg1) {
        return format(message, new List<Object> {arg1});
    }
    
    public String format (String message, Object arg1, Object arg2) {
        return format(message, new List<Object> {arg1, arg2});
    }

    public String format (String message, Object arg1, Object arg2, Object arg3) {
        return format(message, new List<Object> {arg1, arg2, arg3});
    }

    public String format (String message, Object arg1, Object arg2, Object arg3, Object arg4) {
        return format(message, new List<Object> {arg1, arg2, arg3, arg4});
    }

    public String format (String message, List<Object> args) {
        List<String> stringArgs = new List<String>();
        for (Object arg : args) {
            stringArgs.add(String.valueOf(arg));
        }
        
        return String.format(message, stringArgs);
    }

    public void otherIsNotNull(Object other) {
        assert(other != null, 'Expected that other parameter passed to assert with actual to be not [null] but is');
  	}

    public void evaluate() {
        asserter.evaluate();
    }
}