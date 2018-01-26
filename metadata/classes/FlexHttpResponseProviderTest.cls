@IsTest
public class FlexHttpResponseProviderTest {
	static Assert assert = sf.assert;
	
    testmethod public static void test_class() {
        FlexHttpResponseProvider provider = new FlexHttpResponseProvider();
        assertResp(provider.getResponse(null), 200, '', null);
        
        provider.body('Salesforce is a platform');
        assertResp(provider.getResponse(null), 200, 'Salesforce is a platform', null);

        provider.header('X-Header', 'Foo');
        assertResp(provider.getResponse(null), 200, 'Salesforce is a platform', new Map<String, String>{'X-Header' => 'Foo'});

        provider.statusCode(204);
        assertResp(provider.getResponse(null), 204, 'Salesforce is a platform', new Map<String, String>{'X-Header' => 'Foo'});

        provider = new FlexHttpResponseProvider(400, 'New body');
        assertResp(provider.getResponse(null), 400, 'New body', null);

        provider = new FlexHttpResponseProvider('New body');
        assertResp(provider.getResponse(null), 200, 'New body', null);
    }
    
    static void assertResp(HttpResponse resp, Integer statusCode, String body, Map<String, String> headers) {
		assert.that(resp.getStatusCode()).isEqualsTo(statusCode);        
		assert.that(resp.getBody()).isEqualsTo(body);
        
        if (headers == null) {
            assert.that(resp.getHeaderKeys().size()).isEqualsTo(0);
        } else {
            for (String header : headers.keySet()) {
                assert.that(resp.getHeader(header)).isEqualsTo(headers.get(header));
            }
        }
    }
}