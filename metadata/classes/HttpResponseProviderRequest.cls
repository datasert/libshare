global class HttpResponseProviderRequest {
    global HttpRequest currentRequest {get;set;}
    global List<HttpCalloutCall> previousCalls {get;set;}
    
    global HttpResponseProviderRequest() {
        previousCalls = new List<HttpCalloutCall>();
    }
}