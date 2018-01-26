global virtual class HttpClient {
    protected HttpClientRequest defaults = new HttpClientRequest();
    public static HttpClient INSTANCE = new HttpClient();
    
    global HttpClient() {
        //default
    }
    
    global HttpClient(String baseUrl) {
        defaults.url(baseUrl);
    }

    global HttpClient(String baseUrl, Map<String, Object> headers) {
        defaults.url(baseUrl).headers(headers);
    }

    global HttpClient(HttpClientRequest defaults) {
        defaults(defaults);
    }

    global virtual HttpClientRequest defaults() {
        return defaults;
    }
    
    global virtual HttpClient defaults(HttpClientRequest defaults) {
        this.defaults = (HttpClientRequest) Utils.instance.firstNotNull(defaults, new HttpClientRequest());
		return this;
    }

    global virtual HttpClientRequest req() {
		return req(null, null, null);
    }

    global virtual HttpClientRequest req(String method, String url, Object body) {
		return new HttpClientRequest(defaults, method, url, body);
    }

    global virtual HttpClientRequest getReq() {
		return req(HttpConsts.METHOD_GET, null, null);
    }

    global virtual HttpClientRequest getReq(String url) {
		return req(HttpConsts.METHOD_GET, url, null);
    }

    global virtual String get(String url) {
		return getReq(url).sendToString();
    }

    global virtual Object get(String url, System.Type cls) {
		return getReq(url).sendToObject(cls);
    }

    global virtual HttpClientRequest postReq() {
		return req(HttpConsts.METHOD_POST, null, null);
    }

    global virtual HttpClientRequest postReq(String url, Object body) {
		return req(HttpConsts.METHOD_POST, url, body);
    }
    
    global virtual String post(String url, Object body) {
		return postReq(url, body).sendToString();
    }

    global virtual Object post(String url, Object body, System.Type cls) {
		return postReq(url, body).sendToObject(cls);
    }
    
    global virtual HttpClientRequest putReq() {
		return req(HttpConsts.METHOD_PUT, null, null);
    }

    global virtual HttpClientRequest putReq(String url, Object body) {
		return req(HttpConsts.METHOD_PUT, url, body);
    }
    
    global virtual String put(String url, Object body) {
		return putReq(url, body).sendToString();
    }

    global virtual Object put(String url, Object body, System.Type cls) {
		return putReq(url, body).sendToObject(cls);
    }
    
    global virtual HttpClientRequest patchReq() {
		return req(HttpConsts.METHOD_PATCH, null, null);
    }

    global virtual HttpClientRequest patchReq(String url, Object body) {
		return req(HttpConsts.METHOD_PATCH, url, body);
    }
    
    global virtual String patch(String url, Object body) {
		return patchReq(url, body).sendToString();
    }

    global virtual Object patch(String url, Object body, System.Type cls) {
		return patchReq(url, body).sendToObject(cls);
    }
    
    global virtual HttpClientRequest deleteReq() {
		return req(HttpConsts.METHOD_DELETE, null, null);
    }

    global virtual HttpClientRequest deleteReq(String url) {
		return req(HttpConsts.METHOD_DELETE, url, null);
    }
    
    global virtual String httpDelete(String url) {
		return deleteReq(url).sendToString();
    }

    global virtual Object httpDelete(String url, System.Type cls) {
		return deleteReq(url).sendToObject(cls);
    }
}