global virtual class HttpClientRequest {
    
    private static Utils u = new Utils();
	private static HttpClientExecutor defaultExecutor = new HttpClientExecutor();	
    
    private String url;
	private String method;
    private Object body;
    private Map<String, Object> headers = new Map<String, Object>();
    private Map<String, Object> pathParams = new Map<String, Object>();
    private Map<String, Object> queryParams = new Map<String, Object>();
	private Boolean compressed;
    private String clientCert;
    private Integer readTimeout;
    private Boolean retry;
    private Integer retryAttempts;
    private Boolean logBody;
	private HttpClientRequest defaults;
    private HttpClientExecutor executor;
    
    global HttpClientRequest() {
    }
    
    global HttpClientRequest(HttpClientRequest defaults, String method, String url, Object body) {
        this.defaults = defaults;
        this.method = method.toUpperCase();
        this.url = url;
        this.body = body;
    }
    
    global virtual HttpClientExecutor executor() {
        return executor;
    }

    global virtual HttpClientRequest executor(HttpClientExecutor executor) {
        this.executor = executor;
        return this;
    }
    
    global virtual Object body() {
        return body;
    }

    global virtual HttpClientRequest body(Object body) {
        this.body = body;
        return this;
    }

    global virtual String url() {
        return url;
    }

    global virtual HttpClientRequest url(String url) {
        this.url = url;
        return this;
    }

    global virtual String method() {
        return method;
    }

    global virtual HttpClientRequest method(String method) {
        this.method = method;
        return this;
    }

    global virtual Map<String, Object> headers() {
        return headers;
    }

    global virtual HttpClientRequest headers(Map<String, Object> headers) {
        this.headers = (Map<String, Object>) u.firstNotNull(headers, new Map<String, Object>());
        return this;
    }

    global virtual HttpClientRequest addHeaders(Map<String, Object> headers) {
        this.headers.putAll(headers);
        return this;
    }

    global virtual HttpClientRequest contentTypeJson() {
        return contentType(HttpConsts.CONTENT_TYPE_JSON);
    }
    
    global virtual HttpClientRequest contentTypeFormEncoded() {
        return contentType(HttpConsts.CONTENT_TYPE_FORM_URL_ENCODED);
    }

    global virtual HttpClientRequest contentType(String value) {
        return header(HttpConsts.HEADER_CONTENT_TYPE, value);
    }
    
    global virtual HttpClientRequest authz(String value) {
        return header(HttpConsts.HEADER_AUTHORIZATION, value);
    }

    global virtual HttpClientRequest authzBearer(String value) {
        return authz('Bearer ' + value);
    }
    
    global virtual HttpClientRequest authzBasic(String username, String password) {
		authz('Basic ' + EncodingUtil.base64Encode(Blob.valueOf(username + ':' + password)));
        return this;
    }

    global virtual boolean isHeaderSet(String name) {
        return headers.containsKey(name);
    }

    global virtual HttpClientRequest header(String name, Object value) {
        headers.put(name, value);
        return this;
    }

    global virtual Map<String, Object> pathParams() {
        return pathParams;
    }

    global virtual HttpClientRequest pathParam(String name, Object value) {
        pathParams.put(name, value);
        return this;
    }

    global virtual HttpClientRequest pathParams(Map<String, Object> pathParams) {
        this.pathParams = pathParams;
        return this;
    }

    global virtual Map<String, Object> queryParams() {
        return queryParams;
    }

    global virtual HttpClientRequest queryParams(Map<String, Object> queryParams) {
        this.queryParams = queryParams;
        return this;
    }

    global virtual HttpClientRequest queryParam(String name, Object value) {
        queryParams.put(name, value);
        return this;
    }
    
    global virtual Boolean compressed() {
        return compressed;
    }

    global virtual HttpClientRequest compressed(Boolean compressed) {
        this.compressed = compressed;
        return this;
    }
    
    global virtual Boolean retry() {
        return retry;
    }

    global virtual HttpClientRequest retry(Boolean retry) {
        this.retry = retry;
        return this;
    }

    global virtual Boolean logBody() {
        return logBody;
    }

    global virtual HttpClientRequest logBody(Boolean logBody) {
        this.logBody = logBody;
        return this;
    }

    global virtual String clientCert() {
        return clientCert;
    }

    global virtual HttpClientRequest clientCert(String clientCert) {
        this.clientCert = clientCert;
        return this;
    }

    global virtual Integer readTimeout() {
        return readTimeout;
    }

    global virtual HttpClientRequest readTimeout(Integer readTimeout) {
        this.readTimeout = readTimeout;
        return this;
    }

    global virtual Integer retryAttempts() {
        return retryAttempts;
    }
    
    global virtual HttpClientRequest retryAttempts(Integer retryAttempts) {
        this.retryAttempts = retryAttempts;
        return this;
    }

    global virtual String sendToString() {
		return send().body();
    }

    global virtual Blob sendToBlob() {
		return send().bodyAsBlob();
    }

    global virtual Object sendToObject(System.Type type) {
        return send().bodyAsObject(type);
    }

    global virtual JsonMapper sendToJsonMapper() {
		return send().bodyAsJsonMapper();
    }

    global virtual HttpClientResponse send() {
        return ((HttpClientExecutor) u.firstNotNull(defaults == null ?  null : defaults.executor(), executor(), defaultExecutor)).execute(defaults, this);
    }

    public virtual override String toString() {
        
        String requestHeaderString = null;
        if (headers != null) {
            for (String header : headers.keySet()) {
                if (header == null) {
                    continue; //sometimes headers are null
                }
                requestHeaderString = (requestHeaderString==null?'':requestHeaderString + ', ') + header + '=' + headers.get(header);
            }
        }

        String value = 'Request:\nMethod: ' + method + '\nUrl: ' + url
            + '\nHeaders: ' + requestHeaderString + '\nBody:\n' + body;
       
        return value;
    }
}