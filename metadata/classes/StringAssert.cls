global class StringAssert extends BaseAssert {
    private String actual;
    private boolean ignoreCase = false;
    
    public StringAssert(Asserter asserter, String actual) {
        super(asserter, actual);
        this.actual = actual;
    }
	
    private String getIgnoreCaseMessagePart() {
        return ignoreCase ? ' (ignoring case)' : '';
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
        return isEqualsTo(expected, format('Expected' + getIgnoreCaseMessagePart() + ': {0}, Actual: {1}', expected, actual));
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
        return isNotEqualsTo(expected, format('Expected' + getIgnoreCaseMessagePart() + ': not equals to {0}, Actual: same', expected, actual));
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
        return isNullOrEmpty(format('Expected: <null or empty>, Actual: {0}', actual));
    }
    global StringAssert isNullOrEmpty(String msg) {
        if (actual != null && !String.isEmpty(actual)) {
            assert(false, msg);
        }
        
        return this;
    }

    global StringAssert isEmpty() {
        return isEmpty(format('Expected: <empty>, Actual: {0}', actual));
    }
    global StringAssert isEmpty(String msg) {
        if (actual == null || !String.isEmpty(actual)) {
            assert(false, msg);
        }
        
        return this;
    }

    global StringAssert isNotEmpty() {
        return isNotEmpty(format('Expected: <not empty>, Actual: empty', actual));
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
        return isNullOrBlank(format('Expected: <not null or blank>, Actual: {0}', actual));
    }
    global StringAssert isNullOrBlank(String msg) {
        if (actual != null && !String.isBlank(actual)) {
            assert(false, msg);
        }
        
        return this;
    }

    global StringAssert isBlank() {
        return isBlank(format('Expected: <blank>, Actual: {0}', actual));
    }
    global StringAssert isBlank(String msg) {
        if (actual == null || !String.isBlank(actual)) {
            assert(false, msg);
        }
        
        return this;
    }

    global StringAssert isNotBlank() {
        return isNotBlank(format('Expected: <not blank>, Actual: {0}', actual));
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
        return hasSize(size, format('Expected: <size {0}>, Actual: <size {1}> {2}', size, actual.length(), actual));
    }
    global StringAssert hasSize(Integer size, String msg) {
        isNotNull();
        assert(actual.length() == size, msg);
        return this;
    }

    global StringAssert hasLineCount(Integer lines) {
        isNotNull();
        Integer actualLines = actual.split('\n').size();
        assert(lines == actualLines, format('Expected: <{0} lines>, Actual: <{1} lines> {2}', lines, actualLines, actual));
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
            assert(false, format('Expected: <size {0}>, Actual: <size {1}>', other, actual));
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
        return startsWith(other, format('Expected' + getIgnoreCaseMessagePart() + ': <starts with> {0}, Actual: {1}', other, actual));
    }
    global StringAssert startsWith(String other, String msg) {
        isNotNull();
        otherIsNotNull(other);
        
        assert(getActual().startsWith(getExpected(other)), msg);
        return this;
    }

    global StringAssert doesNotStartWith(String other) {
        return doesNotStartWith(other, format('Expected' + getIgnoreCaseMessagePart() + ': <not starts with> {0}, Actual: {1}', other, actual));
    }
    global StringAssert doesNotStartWith(String other, String msg) {
        isNotNull();
        otherIsNotNull(other);
        
        assert(!getActual().startsWith(getExpected(other)), msg);
        return this;
    }

    global StringAssert endsWith(String other) {
        return endsWith(other, format('Expected' + getIgnoreCaseMessagePart() + ': <ends with> {0}, Actual: {1}', other, actual));
    }
    global StringAssert endsWith(String other, String msg) {
        isNotNull();
        otherIsNotNull(other);
        
        assert(getActual().endsWith(getExpected(other)), msg);
        return this;
    }

    global StringAssert doesNotEndWith(String other) {
        return doesNotEndWith(other, format('Expected' + getIgnoreCaseMessagePart() + ': <not ends with> {0}, Actual: {1}', other, actual));
    }
    global StringAssert doesNotEndWith(String other, String msg) {
        isNotNull();
        otherIsNotNull(other);
        
        assert(!getActual().endsWith(getExpected(other)), msg);
        return this;
    }
    
    global StringAssert contains(String other) {
        return contains(other, format('Expected' + getIgnoreCaseMessagePart() + ': <contains> {0}, Actual: {1}', other, actual));
    }
    global StringAssert contains(String other, String msg) {
        isNotNull();
        otherIsNotNull(other);
        
        assert(getActual().contains(getExpected(other)), msg);
        return this;
    }

    global StringAssert doesNotContain(String other) {
        return doesNotContain(other, format('Expected' + getIgnoreCaseMessagePart() + ': <not contains> {0}, Actual: {1}', other, actual));
    }
    global StringAssert doesNotContain(String other, String msg) {
        isNotNull();
        otherIsNotNull(other);
        
        assert(!getActual().contains(getExpected(other)), msg);
        return this;
    }

    global StringAssert matches(String otherRegex) {
        return matches(otherRegex, format('Expected: <matches regex> {0}, Actual: <not matches regex> {1}', otherRegex, actual));
    }
    global StringAssert matches(String otherRegex, String msg) {
        isNotNull();
        otherIsNotNull(otherRegex);
        
        assert(Pattern.matches(otherRegex, actual), msg);
        return this;
    }

    global StringAssert doesNotMatch(String otherRegex) {
        return doesNotMatch(otherRegex, format('Expected: <not matches regex> {0}, Actual: <matches regex> {1}', otherRegex, actual));
    }
    global StringAssert doesNotMatch(String otherRegex, String msg) {
        isNotNull();
        otherIsNotNull(otherRegex);
        
        assert(!Pattern.matches(otherRegex, actual), msg);
        return this;
    }

    global StringAssert isSubstringOf(String other) {
        return isSubstringOf(other, format('Expected' + getIgnoreCaseMessagePart() + ': <substring of> {0}, Actual: {1}', other, actual));
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