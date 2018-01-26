global class HttpException extends Exception {
    
    private HttpClientRequest request = null;
    private HttpClientResponse response = null;
    
    global HttpException (HttpClientRequest request, HttpClientResponse response) {
        setMessage(response.statusCode() + ' [' + response.body() + ']');
        this.response = response;
        this.request = request;
    }

    global HttpClientRequest request() {
        return request;
    }
    
    global HttpClientResponse response() {
        return response;
    }
    
    global Boolean isStatus(Integer code) {
        return response.isStatus(code);
    }
    
    global Boolean isStatus2xx() {
        return response.isStatus2xx();
    }

    global Boolean isStatus3xx() {
        return response.isStatus3xx();
    }

    global Boolean isStatus4xx() {
        return response.isStatus4xx();
    }

    global Boolean isStatus5xx() {
        return response.isStatus5xx();
    }

    /**
     * Checks if http response body contains the specified string, case sensitive and return true
     * if it does and false otherwise.
     */
    global Boolean isBodyContains(String value) {
		return response.isBodyContains(value);
    }
    
    /**
     * Checks if http response body contains the specified string, case insensitive (it converts body/value into lowercase and compares) and return true
     * if it does and false otherwise.
     */
    global Boolean isBodyContainsIc(String value) {
		return response.isBodyContainsIc(value);
    }
    
    global String toString() {
		return request.toString() + '\n\n\n' + response.toString();
    }
}