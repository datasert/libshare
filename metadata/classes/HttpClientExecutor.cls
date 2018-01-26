global virtual class HttpClientExecutor {
    private static Utils u = Utils.INSTANCE;
    private static Logger log = new Logger('HttpClientExecutor');

    global virtual HttpClientResponse execute(HttpClientRequest defaultRequest, HttpClientRequest req) {
		applyDefaults(defaultRequest, req);
        
        String finalUrl = req.url().trim();
        
        if (req.pathParams() != null && !req.pathParams().isEmpty()) {
            finalUrl = u.replaceVars(finalUrl, req.pathParams(), 'url');
        }
        
        if (!req.queryParams().isEmpty()) {
            String parmsString = u.join('&', '=', 'url', req.queryParams());
            
            if (finalUrl.indexOf('?') >= 0) {
                finalUrl += '&' + parmsString;
            } else {
                finalUrl += '?' + parmsString;
            }
        }
        
        HttpRequest httpReq = new HttpRequest();

        httpReq.setEndpoint(finalUrl);
        httpReq.setMethod(req.method());
        httpReq.setTimeout((Integer) u.firstNotNull(req.readTimeout(), 120 * 1000));
        if (String.isNotBlank(req.clientCert())) {
	        httpReq.setClientCertificateName(req.clientCert());
        }
        httpReq.setCompressed(u.toBoolean(req.compressed(), true));
        
        Object body = req.body();
        if (body != null) {
            if (body instanceof Blob) {
                httpReq.setBodyAsBlob((Blob) body);
                
            } else if (body instanceof Dom.Document) {
                httpReq.setBodyDocument((Dom.Document) body);
                
            } else {
                String strBody = null;
                if (body instanceof String) {
                    strBody = (String) body;
                } else {
                    strBody = Json.serializePretty(body);
                }
                
                httpReq.setBody(strBody);
            }
        }

        if (!req.headers().containsKey(HttpConsts.HEADER_CONTENT_TYPE)) {
            req.contentTypeJson();
        }
        for(String key : req.headers().keySet()) {
            httpReq.setHeader(key, u.emptyIfNull(u.toString(req.headers().get(key))));
        }

        HttpClientResponse resp = null;
        try {
            resp = new HttpClientResponse(send(req, httpReq));
        } catch(Exception e) {
            throw new LibshareException('Exception while sending http request ' + httpReq + ' ' + u.getStackTrace(e), e);
        }
        
        if (resp.statusCode() >= 300) {
            throw new HttpException(req, resp);
        }

        return resp;
    }
	
    protected virtual HttpResponse send(HttpClientRequest req, HttpRequest httpReq) {
        return send(req, httpReq, 0);
    }
    
    protected virtual HttpResponse send(HttpClientRequest req, HttpRequest httpReq, Integer retryCount) {
        try {
            System.debug('Sending the http request. ' + httpReq);
	        StopWatch sw = new StopWatch();
			
            HttpResponse resp = new System.Http().send(httpReq);
            
            if (u.toBoolean(req.logBody(), true)) {
	            log.debug('Received the http response in ' + sw.getElapsedTime() + 'ms. status=' + resp.getStatus() +', body=' +resp.getBody());
            } else {
	            log.debug('Received the http response in ' + sw.getElapsedTime() + 'ms. status=' + resp.getStatus());
            }

            return resp;
            
        } catch (System.CalloutException e) {
            //If it is system callout exception, it means there was something wrong while connecting to external system.
            //We will retry configured number of times to re-run the transaction.
            if (isRetry(req, retryCount)) {
                log.warn('Got ' + e.getMessage() +' while sending http request so going to retry the request');
                return send(req, httpReq, retryCount + 1);
            }
            
            throw e;
        }
    }
    
    @TestVisible
    private boolean isRetry(HttpClientRequest req, Integer retryCount) {
        return u.toBoolean(req.retry(), false) && retryCount < u.toInteger(req.retryAttempts(), 3);
    }
    
    @TestVisible
    protected virtual HttpClientRequest applyDefaults(HttpClientRequest defaultReq, HttpClientRequest req) {
        if (defaultReq == null) {
            return req;
        }
        
        req.body(u.firstNotNull(req.body(), defaultReq.body()));
        req.compressed((Boolean) u.firstNotNull(req.compressed(), defaultReq.compressed()));
        req.clientCert((String) u.firstNotNull(req.clientCert(), defaultReq.clientCert()));
        req.readTimeout((Integer) u.firstNotNull(req.readTimeout(), defaultReq.readTimeout()));
        req.retryAttempts((Integer) u.firstNotNull(req.retryAttempts(), defaultReq.retryAttempts()));
			
        applyDefaults(req.pathParams(), defaultReq.pathParams());
        applyDefaults(req.queryParams(), defaultReq.queryParams());
        applyDefaults(req.headers(), defaultReq.headers());

        if (!isUrlAbsolute(req.url()) && String.isNotBlank(defaultReq.url())) {
            req.url(defaultReq.url().trim() + req.url().trim());
        }
        
        return req;
    }

    @TestVisible
    protected virtual boolean isUrlAbsolute(String url) {
        url = url.trim().toLowerCase();
        return url.startsWith('http') || url.startsWith('https') || url.startsWith(HttpConsts.NAMED_CREDENTIALS_URL_PREFIX);
    }
    
    @TestVisible
    protected virtual Map<String, Object> applyDefaults(Map<String, Object> vars, Map<String, Object> defaultVars) {
        for (String key : defaultVars.keySet()) {
            if (!vars.containsKey(key)) {
                vars.put(key, defaultVars.get(key));
            }
        }
        
        return vars;
    }
}