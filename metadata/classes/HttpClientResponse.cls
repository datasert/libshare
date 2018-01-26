global class HttpClientResponse {
    global HttpResponse resp {get;set;}
    
    global HttpClientResponse(HttpResponse resp) {
        this.resp = resp;
    }
    
    global String body() {
        return resp.getBody();
    }
    
    global String getBody() {
        return resp.getBody();
    }

    global Blob bodyAsBlob() {
        return resp.getBodyAsBlob();
    }

    global Blob getBodyAsBlob() {
        return resp.getBodyAsBlob();
    }

    global Dom.Document bodyAsDocument() {
        return resp.getBodyDocument();
    }

    global JsonMapper bodyAsJsonMapper() {
        return new JsonMapper(body());
    }
    
    global Object bodyAsObject(System.Type type) {
		return Json.deserialize(body(), type);
    }

    global String header(String name) {
        return resp.getHeader(name);
    }

    global Map<String, String> headers() {
        Map<String, String> headers = new Map<String, String>();
        for (String key : resp.getHeaderKeys()) {
            if (key == null) {
                continue; //sometimes headers are null
            }
            headers.put(key, resp.getHeader(key));
        }
        
        return headers;
    }

    global HttpResponse httpResponse() {
        return resp;
    }
    
    global Integer statusCode() {
        return resp.getStatusCode();
    }

    global String status() {
        return resp.getStatus();
    }

    global Boolean isStatus(Integer code) {
        return statusCode() == code;
    }

    global Boolean isStatus2xx() {
        return statusCode() >= 200 && statusCode() <= 299;
    }

    global Boolean isStatus3xx() {
        return statusCode() >= 300 && statusCode() <= 399;
    }

    global Boolean isStatus4xx() {
        return statusCode() >= 400 && statusCode() <= 499;
    }

    global Boolean isStatus5xx() {
        return statusCode() >= 500 && statusCode() <= 599;
    }

    /**
     * Checks if http response body contains the specified string, case sensitive and return true
     * if it does and false otherwise.
     */
    global Boolean isBodyContains(String value) {
		return body().contains(value);
    }

    /**
     * Checks if http response body contains the specified string, case insensitive (it converts body/value into lowercase and compares) and return true
     * if it does and false otherwise.
     */
    public Boolean isBodyContainsIc(String value) {
		return body().toLowerCase().contains(value.toLowerCase());
    }
    
    public override String toString() {
        
        String responseHeaderString = null;
        for (String header : resp.getHeaderKeys()) {
            if (header == null) {
                continue; //sometimes headers are null
            }
            responseHeaderString = (responseHeaderString==null?'':responseHeaderString + ', ') + header + '=' + resp.getHeader(header);
        }
        
        String value = 'Response:\nStatus: ' + resp.getStatusCode() + ' ' + resp.getStatus()
            + '\nHeaders: ' + responseHeaderString + '\nResponse:\n' + body();
       
        return value;
    }
}