global class FlexHttpCalloutMock implements HttpCalloutMock {
    private class MockConfig {
        public HttpRequestMatcher requestMatcher {get;set;}
        public HttpResponseProvider responseProvider {get;set;}
        
        public MockConfig(HttpRequestMatcher requestMatcher, HttpResponseProvider responseProvider) {
            this.requestMatcher = requestMatcher;
            this.responseProvider = responseProvider;
        }
    }
	
    private static final Utils u = Utils.INSTANCE;
    
    private List<MockConfig> mockConfigs = new List<MockConfig>();
    private List<HttpCalloutCall> calloutCalls = new List<HttpCalloutCall>();
    private HttpResponse defaultResponse {get;set;}
    
    global FlexHttpCalloutMock withDefaultResponse(Object body) {
		return withDefaultResponse(200, body);
    }

    global FlexHttpCalloutMock withDefaultResponse(Integer statusCode, Object body) {
        return withDefaultResponse(new FlexHttpResponseProvider(statusCode, body).getResponse(null));
    }

    global FlexHttpCalloutMock withDefaultResponse(HttpResponse defaultResponse) {
        this.defaultResponse = defaultResponse;
        return this;
    }

    global FlexHttpCalloutMock withConfig(HttpRequestMatcher matcher, FlexHttpResponseProvider provider) {
        mockConfigs.add(new MockConfig(matcher, provider));
        return this;
    }

    global FlexHttpCalloutMock ifUrlEqualsReturn(String url, Object body) {
        return withConfig(new FlexHttpRequestMatcher(FlexHttpRequestMatcher.REQ_URL, FlexHttpRequestMatcher.OPER_EQUALS, url), new FlexHttpResponseProvider(body));
    }
    
    global FlexHttpCalloutMock ifUrlEqualsReturn(String url, Integer httpCode, Object body) {
        return withConfig(new FlexHttpRequestMatcher(FlexHttpRequestMatcher.REQ_URL, FlexHttpRequestMatcher.OPER_EQUALS, url), new FlexHttpResponseProvider(httpCode, body));
    }

    global FlexHttpCalloutMock ifUrlEqualsIcReturn(String url, Object body) {
        return withConfig(new FlexHttpRequestMatcher(FlexHttpRequestMatcher.REQ_URL, FlexHttpRequestMatcher.OPER_EQUALS_IC, url), new FlexHttpResponseProvider(body));
    }
    
    global FlexHttpCalloutMock ifUrlEqualsIcReturn(String url, Integer httpCode, Object body) {
        return withConfig(new FlexHttpRequestMatcher(FlexHttpRequestMatcher.REQ_URL, FlexHttpRequestMatcher.OPER_EQUALS_IC, url), new FlexHttpResponseProvider(httpCode, body));
    }

    global FlexHttpCalloutMock ifUrlContainsReturn(String url, Object body) {
        return withConfig(new FlexHttpRequestMatcher(FlexHttpRequestMatcher.REQ_URL, FlexHttpRequestMatcher.OPER_CONTAINS, url), new FlexHttpResponseProvider(body));
    }
    
    global FlexHttpCalloutMock ifUrlContainsReturn(String url, Integer statusCode, Object body) {
        return withConfig(new FlexHttpRequestMatcher(FlexHttpRequestMatcher.REQ_URL, FlexHttpRequestMatcher.OPER_CONTAINS, url), new FlexHttpResponseProvider(statusCode, body));
    }

    global FlexHttpCalloutMock ifUrlContainsIcReturn(String url, Object body) {
        return withConfig(new FlexHttpRequestMatcher(FlexHttpRequestMatcher.REQ_URL, FlexHttpRequestMatcher.OPER_CONTAINS_IC, url), new FlexHttpResponseProvider(body));
    }
    
    global FlexHttpCalloutMock ifUrlContainsIcReturn(String url, Integer statusCode, Object body) {
        return withConfig(new FlexHttpRequestMatcher(FlexHttpRequestMatcher.REQ_URL, FlexHttpRequestMatcher.OPER_CONTAINS_IC, url), new FlexHttpResponseProvider(statusCode, body));
    }

    global FlexHttpCalloutMock ifUrlEndsWithReturn(String url, Object body) {
        return withConfig(new FlexHttpRequestMatcher(FlexHttpRequestMatcher.REQ_URL, FlexHttpRequestMatcher.OPER_ENDS_WITH, url), new FlexHttpResponseProvider(body));
    }
    
    global FlexHttpCalloutMock ifUrlEndsWithReturn(String url, Integer statusCode, Object body) {
        return withConfig(new FlexHttpRequestMatcher(FlexHttpRequestMatcher.REQ_URL, FlexHttpRequestMatcher.OPER_ENDS_WITH, url), new FlexHttpResponseProvider(statusCode, body));
    }

    global FlexHttpCalloutMock ifUrlEndsWithIcReturn(String url, Object body) {
        return withConfig(new FlexHttpRequestMatcher(FlexHttpRequestMatcher.REQ_URL, FlexHttpRequestMatcher.OPER_ENDS_WITH_IC, url), new FlexHttpResponseProvider(body));
    }
    
    global FlexHttpCalloutMock ifUrlEndsWithIcReturn(String url, Integer statusCode, Object body) {
        return withConfig(new FlexHttpRequestMatcher(FlexHttpRequestMatcher.REQ_URL, FlexHttpRequestMatcher.OPER_ENDS_WITH_IC, url), new FlexHttpResponseProvider(statusCode, body));
    }

    global FlexHttpCalloutMock ifUrlStartsWithReturn(String url, Object body) {
        return withConfig(new FlexHttpRequestMatcher(FlexHttpRequestMatcher.REQ_URL, FlexHttpRequestMatcher.OPER_STARTS_WITH, url), new FlexHttpResponseProvider(body));
    }

    global FlexHttpCalloutMock ifUrlStartsWithReturn(String url, Integer statusCode, Object body) {
        return withConfig(new FlexHttpRequestMatcher(FlexHttpRequestMatcher.REQ_URL, FlexHttpRequestMatcher.OPER_STARTS_WITH, url), new FlexHttpResponseProvider(statusCode, body));
    }

    global FlexHttpCalloutMock ifUrlStartsWithIcReturn(String url, Object body) {
        return withConfig(new FlexHttpRequestMatcher(FlexHttpRequestMatcher.REQ_URL, FlexHttpRequestMatcher.OPER_STARTS_WITH_IC, url), new FlexHttpResponseProvider(body));
    }

    global FlexHttpCalloutMock ifUrlStartsWithIcReturn(String url, Integer statusCode, Object body) {
        return withConfig(new FlexHttpRequestMatcher(FlexHttpRequestMatcher.REQ_URL, FlexHttpRequestMatcher.OPER_STARTS_WITH_IC, url), new FlexHttpResponseProvider(statusCode, body));
    }

    global FlexHttpCalloutMock ifUrlEqualsCountReturn(String url, Integer count, Integer httpStatus, Object body) {
        return withConfig(new FlexHttpRequestMatcher(FlexHttpRequestMatcher.REQ_URL, FlexHttpRequestMatcher.OPER_EQUALS, url, count, null), new FlexHttpResponseProvider(httpStatus, body));
    }

    global FlexHttpCalloutMock ifBodyContainsReturn(String reqBody, Object body) {
        return withConfig(new FlexHttpRequestMatcher(FlexHttpRequestMatcher.REQ_BODY, FlexHttpRequestMatcher.OPER_CONTAINS, reqBody), new FlexHttpResponseProvider(body));
    }
    
    global FlexHttpCalloutMock ifBodyContainsReturn(String reqBody, Integer statusCode, Object body) {
        return withConfig(new FlexHttpRequestMatcher(FlexHttpRequestMatcher.REQ_BODY, FlexHttpRequestMatcher.OPER_CONTAINS, reqBody), new FlexHttpResponseProvider(statusCode,body));
    }

    global FlexHttpCalloutMock ifBodyEqualsReturn(String reqBody, Object body) {
        return withConfig(new FlexHttpRequestMatcher(FlexHttpRequestMatcher.REQ_BODY, FlexHttpRequestMatcher.OPER_EQUALS, reqBody), new FlexHttpResponseProvider(body));
    }
    
    global FlexHttpCalloutMock ifBodyEqualsReturn(String reqBody, Integer statusCode, Object body) {
        return withConfig(new FlexHttpRequestMatcher(FlexHttpRequestMatcher.REQ_BODY, FlexHttpRequestMatcher.OPER_EQUALS, reqBody), new FlexHttpResponseProvider(statusCode, body));
    }

    global FlexHttpCalloutMock ifBodyStartsWithReturn(String reqBody, Object body) {
        return withConfig(new FlexHttpRequestMatcher(FlexHttpRequestMatcher.REQ_BODY, FlexHttpRequestMatcher.OPER_STARTS_WITH, reqBody), new FlexHttpResponseProvider(body));
    }
    
    global FlexHttpCalloutMock ifBodyStartsWithReturn(String reqBody, Integer statusCode, Object body) {
        return withConfig(new FlexHttpRequestMatcher(FlexHttpRequestMatcher.REQ_BODY, FlexHttpRequestMatcher.OPER_STARTS_WITH, reqBody), new FlexHttpResponseProvider(statusCode, body));
    }

    global FlexHttpCalloutMock ifBodyEndsWithReturn(String reqBody, Object body) {
        return withConfig(new FlexHttpRequestMatcher(FlexHttpRequestMatcher.REQ_BODY, FlexHttpRequestMatcher.OPER_ENDS_WITH, reqBody), new FlexHttpResponseProvider(body));
    }
    
    global FlexHttpCalloutMock ifBodyEndsWithReturn(String reqBody, Integer statusCode, Object body) {
        return withConfig(new FlexHttpRequestMatcher(FlexHttpRequestMatcher.REQ_BODY, FlexHttpRequestMatcher.OPER_ENDS_WITH, reqBody), new FlexHttpResponseProvider(statusCode, body));
    }

    global HttpResponse respond(HttpRequest req) {

        System.debug('Received a http request ' + req + '. going to process using mock configs ' + mockConfigs);
		
        HttpRequestMatcherRequest matcherReq = new HttpRequestMatcherRequest();
        matcherReq.currentRequest = req;
        matcherReq.previousCalls = calloutCalls;
        
        HttpResponseProviderRequest providerReq = new HttpResponseProviderRequest();
        providerReq.currentRequest = req;
        providerReq.previousCalls = calloutCalls;

        HttpResponse resp = null;
        	
        if (mockConfigs.isEmpty()) {
            resp = defaultResponse;
        } else {
            MockConfig matchedConfig = null;
            for (MockConfig config : mockConfigs) {
                //System.debug('Checking is requestMatch [' + config.requestMatch +'] matches the http request ' + req);
                if (config.requestMatcher.isMatches(matcherReq)) {
                    matchedConfig = config;
                    break;
                }
            }
            
            if (matchedConfig == null) {
                System.debug('None of the configured mock responses matched the http request ' + req 
                             + ' so going to use the default response (if configured) ' + defaultResponse);
                resp = defaultResponse;
            } else {
                resp = matchedConfig.responseProvider.getResponse(providerReq);
            }
        }

        calloutCalls.add(new HttpCalloutCall(req, resp));
        if (resp == null) {
            throw new LibshareException('Couldnot identify a mock response for ' + req);
        }
        
        return resp;
    }
    
    global FlexHttpCalloutMock setMock() {
        Test.setMock(HttpCalloutMock.class, this);
        return this;
    }
    
    global FlexHttpCalloutMock clear() {
		defaultResponse = null;
 		calloutCalls.clear();
        mockConfigs.clear();
        return this;
    }

    global FlexHttpCalloutMock clearConfigs() {
        mockConfigs.clear();
        return this;
    }
    
    global List<HttpCalloutCall> getCalloutCalls() {
        return calloutCalls;
    }
}