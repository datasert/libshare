global class HttpCalloutCall {
    global HttpRequest request {get;set;}
    global HttpResponse response {get;set;}
    global DateTime invokedAt {get;set;}
    
    global HttpCalloutCall (HttpRequest request, HttpResponse response) {
        invokedAt = Utils.INSTANCE.now();
        this.request = request;
        this.response = response;
    }
}