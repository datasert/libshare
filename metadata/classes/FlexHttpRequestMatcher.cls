/**
 * Flexible HttpRequestMatcher which provides capabilities that satisfies many usecases.
 * <p>
 * This class can be extended by subclasses and individual methods can be overridden to
 * alter its behavior.
 * <p>
 * More than one matcher can be specified and if so, overall match only if all configured
 * matchers are matched. If there are no matched, then overall doesn't match.
 */
global virtual class FlexHttpRequestMatcher implements HttpRequestMatcher {
    global static final String REQ_METHOD = 'method';
    global static final String REQ_URL = 'url';
    global static final String REQ_BODY = 'body';
    global static final String REQ_HEADER_PREFIX = 'header:';
    
    global static final String OPER_EQUALS = 'equals';
    global static final String OPER_EQUALS_IC = 'equalsIgnoreCase';
    global static final String OPER_STARTS_WITH = 'startsWith';
    global static final String OPER_STARTS_WITH_IC = 'startsWithIgnoreCase';
    global static final String OPER_ENDS_WITH = 'endsWith';
    global static final String OPER_ENDS_WITH_IC = 'endsWithIgnoreCase';
    global static final String OPER_CONTAINS = 'contains';
    global static final String OPER_CONTAINS_IC = 'containsIgnoreCase';
    global static final String OPER_MATCHES = 'matches';

    global static final String OPER_NOT_EQUALS = 'notEquals';
    global static final String OPER_NOT_EQUALS_IC = 'notEqualsIgnoreCase';
    global static final String OPER_NOT_STARTS_WITH = 'notStartsWith';
    global static final String OPER_NOT_STARTS_WITH_IC = 'notStartsWithIgnoreCase';
    global static final String OPER_NOT_ENDS_WITH = 'notEndsWith';
    global static final String OPER_NOT_ENDS_WITH_IC = 'notEndsWithIgnoreCase';
    global static final String OPER_NOT_CONTAINS = 'notContains';
    global static final String OPER_NOT_CONTAINS_IC = 'notContainsIgnoreCase';
    global static final String OPER_NOT_MATCHES = 'notmatches';

    private static Utils u = Utils.INSTANCE;
	private List<RequestMatcherEntry> entries = new List<RequestMatcherEntry>();
    
    global FlexHttpRequestMatcher() {
        //default
    }
    
    global FlexHttpRequestMatcher(String field, String operator, Object value) {
        match(field, operator, value);
    }
    
    global FlexHttpRequestMatcher(String field, String operator, Object value, Integer minMatches, Integer maxMatches) {
        match(field, operator, value, minMatches, maxMatches);
    }

    global virtual boolean isMatches(HttpRequestMatcherRequest req) {
        if (req == null || entries.isEmpty()) {
            return false;
        }
        
        HttpRequest httpReq = req.currentRequest;

        for (RequestMatcherEntry entry : entries) {
            if (!isMatches(httpReq, entry)) {
                return false;
            }
        }
        
        return true;
    }
    
    protected virtual boolean isMatches(HttpRequest req, RequestMatcherEntry entry) {
        boolean matches = isMatches(getRequestValue(req, entry.field), entry.operator, entry.value);
        if (matches) {
            entry.currentMatches = u.increment(entry.currentMatches);
            
            if (entry.minMatches != null && entry.currentMatches < entry.minMatches) {
				matches = false;
            }

            if (entry.maxMatches != null && entry.currentMatches > entry.maxMatches) {
				matches = false;
            }
        }
        
        return matches;
    }
    
    protected virtual boolean isMatches(Object actual, String operator, Object expected) {
        
        String actualString = u.emptyIfNull(u.toString(actual));
        String expectedString = u.emptyIfNull(u.toString(expected));
        
        if (u.equalsIc(operator, OPER_EQUALS)) {
			return actualString.equals(expectedString);
        }

        if (u.equalsIc(operator, OPER_EQUALS_IC)) {
			return actualString.equalsIgnoreCase(expectedString);
        }

        if (u.equalsIc(operator, OPER_NOT_EQUALS)) {
			return !actualString.equals(expectedString);
        }

        if (u.equalsIc(operator, OPER_NOT_EQUALS_IC)) {
			return !actualString.equalsIgnoreCase(expectedString);
        }

        if (u.equalsIc(operator, OPER_STARTS_WITH)) {
			return actualString.startsWith(expectedString);
        }

        if (u.equalsIc(operator, OPER_STARTS_WITH_IC)) {
			return actualString.startsWithIgnoreCase(expectedString.toLowerCase());
        }

        if (u.equalsIc(operator, OPER_NOT_STARTS_WITH)) {
			return !actualString.startsWith(expectedString);
        }

        if (u.equalsIc(operator, OPER_NOT_STARTS_WITH_IC)) {
			return !actualString.startsWithIgnoreCase(expectedString.toLowerCase());
        }

        if (u.equalsIc(operator, OPER_ENDS_WITH)) {
			return actualString.endsWith(expectedString);
        }

        if (u.equalsIc(operator, OPER_ENDS_WITH_IC)) {
			return actualString.endsWithIgnoreCase(expectedString);
        }

        if (u.equalsIc(operator, OPER_NOT_ENDS_WITH)) {
			return !actualString.endsWith(expectedString);
        }

        if (u.equalsIc(operator, OPER_NOT_ENDS_WITH_IC)) {
			return !actualString.endsWithIgnoreCase(expectedString);
        }

        if (u.equalsIc(operator, OPER_CONTAINS)) {
			return actualString.contains(expectedString);
        }

        if (u.equalsIc(operator, OPER_CONTAINS_IC)) {
			return actualString.containsIgnoreCase(expectedString);
        }

        if (u.equalsIc(operator, OPER_NOT_CONTAINS)) {
			return !actualString.contains(expectedString);
        }

        if (u.equalsIc(operator, OPER_NOT_CONTAINS_IC)) {
			return !actualString.containsIgnoreCase(expectedString);
        }

        if (u.equalsIc(operator, OPER_MATCHES)) {
			return Pattern.matches(expectedString, actualString);
        }
        
        if (u.equalsIc(operator, OPER_NOT_MATCHES)) {
			return !Pattern.matches(expectedString, actualString);
        }

        throw new LibshareException('Unsupported operator ' + operator);
    }

    protected virtual Object getRequestValue(HttpRequest req, String field) {
        if (u.equalsIc(field, REQ_METHOD)) {
            return req.getMethod();
        }

        if (u.equalsIc(field, REQ_URL)) {
            return req.getEndpoint();
        }

        if (u.equalsIc(field, REQ_BODY)) {
            return req.getBody();
        }

        if (field.startsWith(REQ_HEADER_PREFIX)) {
            return req.getHeader(field.substringAfter(REQ_HEADER_PREFIX));
        }
        
		throw new LibshareException('Unknown request matcher field ' + field);
    }
    
    global FlexHttpRequestMatcher match(String field, String operator, Object value) {
        entries.add(new RequestMatcherEntry(field, operator, value, null, null));
        return this;
    }
    
    global FlexHttpRequestMatcher match(String field, String operator, Object value, Integer minMatches, Integer maxMatches) {
        entries.add(new RequestMatcherEntry(field, operator, value, minMatches, maxMatches));
        return this;
    }
    
    global FlexHttpRequestMatcher clear() {
        entries.clear();
        return this;
    }

    global class RequestMatcherEntry {
        public String field {get;set;}
        public String operator {get;set;}
        public Object value {get;set;}
        public Integer minMatches {get;set;}
        public Integer maxMatches {get;set;}
        public Integer currentMatches {get;set;}
        
        public RequestMatcherEntry(String field, String operator, Object value, Integer minMatches, Integer maxMatches) {
            this.field = field;
            this.operator = operator;
            this.value = value;
            this.minMatches = minMatches;
            this.maxMatches = maxMatches;
        }
    }
}