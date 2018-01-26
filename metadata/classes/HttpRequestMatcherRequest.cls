global class HttpRequestMatcherRequest {
    global HttpRequest currentRequest {get;set;}
    global List<HttpCalloutCall> previousCalls {get;set;}
    
    global HttpRequestMatcherRequest() {
        previousCalls = new List<HttpCalloutCall>();
    }

    global HttpRequestMatcherRequest(List<HttpCalloutCall> previousCalls, HttpRequest currentRequest) {
        this.previousCalls = (List<HttpCalloutCall>) Utils.INSTANCE.firstNotNull(previousCalls, new List<HttpCalloutCall>());
        this.currentRequest = currentRequest;
    }
}