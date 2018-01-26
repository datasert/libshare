global class FlexHttpResponseProvider implements HttpResponseProvider {
    private Object body;
    private Integer statusCode;
    private Map<String, String> headers = new Map<String, String>();
    
    global FlexHttpResponseProvider() {
        //default
    }
    
    global FlexHttpResponseProvider(Object body) {
        this(200, body);
    }

    global FlexHttpResponseProvider(Integer statusCode, Object body) {
        this.statusCode = statusCode;
        this.body = body;
    }

    global FlexHttpResponseProvider body(Object body) {
        this.body = body;
        return this;
    }
    
    global FlexHttpResponseProvider statusCode(Integer statusCode) {
        this.statusCode = statusCode;
        return this;
    }
    
    global FlexHttpResponseProvider header(String key, String value) {
        headers.put(key, value);
        return this;
    }
    
    global HttpResponse getResponse(HttpResponseProviderRequest req) {
        if (body instanceof Exception) {
            throw ((Exception) body);
        }
        
        HttpResponse resp = new HttpResponse();
        
        if (body instanceof Blob) {
	        resp.setBodyAsBlob((Blob) body);
            
        } else if (body instanceof String) {
            resp.setBody((String) body);

        } else if (body != null) {
            resp.setBody(Json.serialize(body));
        }
        
        resp.setStatusCode((Integer) Utils.INSTANCE.firstNotNull(statusCode, 200));
        for (String headerName : headers.keySet()) {
            resp.setHeader(headerName, headers.get(headerName));
        }
        
        return resp;
    }
}