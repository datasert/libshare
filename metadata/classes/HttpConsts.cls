global class HttpConsts {
	global static final String METHOD_GET = 'GET';
	global static final String METHOD_POST = 'POST';
	global static final String METHOD_PUT = 'PUT';
	global static final String METHOD_PATCH = 'PATCH';
	global static final String METHOD_DELETE = 'DELETE';

    global static final String HEADER_AUTHORIZATION_BEARER = 'Bearer';
	global static final String HEADER_AUTHORIZATION = 'Authorization';
	global static final String HEADER_CONTENT_DISPOSITION = 'Content-Disposition';
	global static final String HEADER_CONTENT_LENGTH = 'Content-Length';
	global static final String HEADER_CONTENT_TYPE = 'Content-Type';

	global static final String CONTENT_TYPE_JSON = 'application/json; charset=UTF-8';
	global static final String CONTENT_TYPE_FORM_URL_ENCODED = 'application/x-www-form-urlencoded';

    global static final String NAMED_CREDENTIALS_URL_PREFIX = 'callout:';
}