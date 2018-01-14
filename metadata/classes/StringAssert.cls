global class StringAssert extends BaseAssert {
    private String actual;
    private boolean ignoreCase = false;
    
    public StringAssert(Asserter asserter, String actual) {
        super(asserter, actual);
        this.actual = actual;
    }
	
    private String getIgnoreCaseMessagePart() {
        return ignoreCase ? '(ignoring case) ' : '';
    }
    
    private String getActual() {
        if (actual == null) {
            return null;
        }
        
        return ignoreCase ? actual.toLowerCase() : actual;
    }
    
    private String getExpected(Object value) {
        if (value == null) {
            return null;
        }
        
        return ignoreCase ? String.valueOf(value).toLowerCase() : String.valueOf(value);
    }

    global StringAssert ignoreCase() {
        ignoreCase = true;
        return this;
    }
    
    global StringAssert ignoreCase(boolean ignoreCase) {
        ignoreCase = ignoreCase;
        return this;
    }

    global StringAssert isNull() {
        common_isNull();
        return this;
    }
	global StringAssert isNull(String msg) {
        common_isNull(msg);
        return this;
    }
    
    global StringAssert isNotNull() {
        common_isNotNull();
        return this;
    }
    global StringAssert isNotNull(String msg) {
        common_isNotNull(msg);
        return this;
    }
    
    global StringAssert isEqualsTo(Object expected) {
        return isEqualsTo(expected, format('Expected that actual [{0}] to be equals to [{1}] ' + getIgnoreCaseMessagePart () + 'but is not', actual, expected));
    }

    global StringAssert isEqualsTo(Object expected, String msg) {
        if (actual == null && expected == null) {
            return this;
        }
        
        if (actual == null || expected == null) {
            throw assertFalse(msg);
        }
        
        assert(getActual().equals(getExpected(expected)), msg);
        return this;
    }

    global virtual StringAssert isNotEqualsTo(Object expected) {
        return isNotEqualsTo(expected, format('Expected that actual [{0}] to be not equals to [{1}] ' + getIgnoreCaseMessagePart () + 'but is', actual, expected));
    }

    global virtual StringAssert isNotEqualsTo(Object expected, String msg) {
        if (actual == null && expected == null) {
            assertFalse(msg);
        }
        
        if (actual == null || expected == null) {
            return this;
        }
        
        assert(!getActual().equals(getExpected(expected)), msg);
        return this;
    }
    
    global StringAssert isSameAs(Object expected) {
        common_isSameAs(expected);
        return this;
    }
    global StringAssert isSameAs(Object expected, String msg) {
        common_isSameAs(expected, msg);
        return this;
    }
    
    global StringAssert isNotSameAs(Object expected) {
        common_isNotSameAs(expected);
        return this;
    }
    global StringAssert isNotSameAs(Object expected, String msg) {
        common_isNotSameAs(expected, msg);
        return this;
    }
    
    global StringAssert isNullOrEmpty() {
        return isNullOrEmpty(format('Expected that actual [{0}] to be either null or empty but is not', actual));
    }
    global StringAssert isNullOrEmpty(String msg) {
        if (actual != null && !String.isEmpty(actual)) {
            assert(false, msg);
        }
        
        return this;
    }

    global StringAssert isEmpty() {
        return isEmpty(format('Expected that actual [{0}] to be empty but is not', actual));
    }
    global StringAssert isEmpty(String msg) {
        if (actual == null || !String.isEmpty(actual)) {
            assert(false, msg);
        }
        
        return this;
    }

    global StringAssert isNotEmpty() {
        return isNotEmpty(format('Expected that actual [{0}] to be not empty but is', actual));
    }
    global StringAssert isNotEmpty(String msg) {
        if (actual == null) {
            return this;
        }
        
        if (String.isEmpty(actual)) {
            assert(false, msg);
        }
        
        return this;
    }

    global StringAssert isNullOrBlank() {
        return isNullOrBlank(format('Expected that actual [{0}] to be either null or blank but is not', actual));
    }
    global StringAssert isNullOrBlank(String msg) {
        if (actual != null && !String.isBlank(actual)) {
            assert(false, msg);
        }
        
        return this;
    }

    global StringAssert isBlank() {
        return isBlank(format('Expected that actual [{0}] to be blank but is not', actual));
    }
    global StringAssert isBlank(String msg) {
        if (actual == null || !String.isBlank(actual)) {
            assert(false, msg);
        }
        
        return this;
    }

    global StringAssert isNotBlank() {
        return isNotBlank(format('Expected that actual [{0}] to be not blank but is', actual));
    }
    
    global StringAssert isNotBlank(String msg) {
        if (actual == null) {
            return this;
        } 
        
        if (String.isBlank(actual)) {
            assert(false, msg);
        }
        
        return this;
    }

    global StringAssert hasSize(Integer size) {
        isNotNull();
        return hasSize(size, format('Expected that actual [{0}] to have size [{1}] but it has [{2}]', actual, size, actual.length()));
    }
    global StringAssert hasSize(Integer size, String msg) {
        isNotNull();
        assert(actual.length() == size, msg);
        return this;
    }

    global StringAssert hasLineCount(Integer lines) {
        isNotNull();
        Integer actualLines = actual.split('\n').size();
        assert(lines == actualLines, format('Expected that actual [{0}] to have [{1}] lines but it has [{2}]', actual, lines, actualLines));
        return this;
    }

    global StringAssert hasLineCount(Integer lines, String msg) {
        isNotNull();
        Integer actualLines = actual.split('\n').size();
        assert(lines == actualLines, msg);
        return this;
    }

    global StringAssert hasSameSizeAs(String other) {
        if (actual == null && other == null) {
            return this;
        }
        
        if (actual == null || other == null || actual.length() != other.length()) {
	        assert(false, format('Expected that actual [{0}] to have same size as [{1}] but is not', actual, other));
        }
        return this;
    }

    global StringAssert hasSameSizeAs(String other, String msg) {
        if (actual == null && other == null) {
            return this;
        }
        
        if (actual == null || other == null || actual.length() != other.length()) {
	        assert(false, msg);
        }
        return this;
    }
    
    global StringAssert startsWith(String other) {
        return startsWith(other, format('Expected that actual [{0}] to start with [{1}] ' + getIgnoreCaseMessagePart () + 'but is not', actual, other));
    }
    global StringAssert startsWith(String other, String msg) {
        isNotNull();
        otherIsNotNull(other);
        
        assert(getActual().startsWith(getExpected(other)), msg);
        return this;
    }

    global StringAssert doesNotStartWith(String other) {
        return doesNotStartWith(other, format('Expected that actual [{0}] to not start with [{1}] ' + getIgnoreCaseMessagePart () + 'but is', actual, other));
    }
    global StringAssert doesNotStartWith(String other, String msg) {
        isNotNull();
        otherIsNotNull(other);
        
        assert(!getActual().startsWith(getExpected(other)), msg);
        return this;
    }

    global StringAssert endsWith(String other) {
        return endsWith(other, format('Expected that actual [{0}] to end with [{1}] ' + getIgnoreCaseMessagePart () + 'but is not', actual, other));
    }
    global StringAssert endsWith(String other, String msg) {
        isNotNull();
        otherIsNotNull(other);
        
        assert(getActual().endsWith(getExpected(other)), msg);
        return this;
    }

    global StringAssert doesNotEndWith(String other) {
        return doesNotEndWith(other, format('Expected that actual [{0}] to not end with [{1}] ' + getIgnoreCaseMessagePart () + 'but is', actual, other));
    }
    global StringAssert doesNotEndWith(String other, String msg) {
        isNotNull();
        otherIsNotNull(other);
        
        assert(!getActual().endsWith(getExpected(other)), msg);
        return this;
    }
    
    global StringAssert contains(String other) {
        return contains(other, format('Expected that actual [{0}] to contain [{1}] ' + getIgnoreCaseMessagePart () + 'but is not', actual, other));
    }
    global StringAssert contains(String other, String msg) {
        isNotNull();
        otherIsNotNull(other);
        
        assert(getActual().contains(getExpected(other)), msg);
        return this;
    }

    global StringAssert doesNotContain(String other) {
        return doesNotContain(other, format('Expected that actual [{0}] to not contain [{1}] ' + getIgnoreCaseMessagePart () + 'but is', actual, other));
    }
    global StringAssert doesNotContain(String other, String msg) {
        isNotNull();
        otherIsNotNull(other);
        
        assert(!getActual().contains(getExpected(other)), msg);
        return this;
    }

    global StringAssert matches(String otherRegex) {
        return matches(otherRegex, format('Expected that actual [{0}] to regex match [{1}] but is not', actual, otherRegex));
    }
    global StringAssert matches(String otherRegex, String msg) {
        isNotNull();
        otherIsNotNull(otherRegex);
        
        assert(Pattern.matches(otherRegex, actual), msg);
        return this;
    }

    global StringAssert doesNotMatch(String otherRegex) {
        return doesNotMatch(otherRegex, format('Expected that actual [{0}] to not regex match [{1}] but is', actual, otherRegex));
    }
    global StringAssert doesNotMatch(String otherRegex, String msg) {
        isNotNull();
        otherIsNotNull(otherRegex);
        
        assert(!Pattern.matches(otherRegex, actual), msg);
        return this;
    }

    global StringAssert isSubstringOf(String other) {
        return isSubstringOf(other, format('Expected that actual [{0}] to be substring of [{1}] ' + getIgnoreCaseMessagePart () + 'but is not', actual, other));
    }
    global StringAssert isSubstringOf(String other, String msg) {
        isNotNull();
        otherIsNotNull(other);
        
        assert(getExpected(other).indexOf(getActual()) >= 0, msg);
        return this;
    }
    
    global StringAssert isId() {
        return isId(format('Expected that actua [{0}] to be a valid Id but is not', actual));
    }
    
    global StringAssert isId(String msg) {
        try {
            Id idValue = actual;
        } catch (Exception e) {
            throw assertFalse(msg);
        }
        
        return this;
    }
    
    public IntegerAssert asInteger() {
        Integer value = null;
        try {
            value = Integer.valueOf(actual);
        } catch (Exception e) {
            assert(false, format('Expected that actual [{0}] to be Integer but is not', actual));
        }
        return new IntegerAssert(asserter, value);
    }

    global DecimalAssert asDecimal() {
        Decimal value = null;
        try {
            value = Decimal.valueOf(actual);
        } catch (Exception e) {
            assert(false, format('Expected that actual [{0}] to be Decimal but is not', actual));
        }
        return Sf.assert.that(value);
    }
    global BooleanAssert asBoolean() {
        Boolean value = null;
        try {
            value = Boolean.valueOf(actual);
        } catch (Exception e) {
            assert(false, format('Expected that actual [{0}] to be Boolean but is not', actual));
        }
        return Sf.assert.that(value);
    }

    global DateAssert asDate(){
        Date value = null;
        try {
            value = Date.valueOf(actual);
        } catch (Exception e) {
            assert(false, format('Expected that actual [{0}] to be Date but is not', actual));
        }
        return Sf.assert.that(value);
    }

    global DateTimeAssert asDateTime(){
        Datetime value = null;
        try {
            value = Datetime.valueOf(actual);
        } catch (Exception e) {
            assert(false, format('Expected that actual [{0}] to be Datetime but is not', actual));
        }
        return Sf.assert.that(value);
    }
}