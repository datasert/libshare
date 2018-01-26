@IsTest
public class FlexHttpCalloutMockTest {
	static Assert assert = sf.assert;

    testmethod public static void test_defaultResponse() {
        HttpClient client= new HttpClient();
		FlexHttpCalloutMock mock = new FlexHttpCalloutMock().setMock();
        
        mock.withDefaultResponse('Some body');
		assert.that(client.get('https://www.google.com')).isEqualsTo('Some body');

        mock.withDefaultResponse(204, 'Some body');
		assert.that(client.getReq('https://www.google.com').send().statusCode()).isEqualsTo(204);

        assert.that(mock.getCalloutCalls().size()).isEqualsTo(2);

        mock.clear();
        try {
			client.getReq('https://www.google.com').send();
            assert.expectedException();
        } catch (Exception e) {
            //ignore expected
            assert.that(mock.getCalloutCalls().size()).isEqualsTo(1);
        }
    }
    
    testmethod public static void test_variousMatchers() {
        HttpClient client = new HttpClient();
		FlexHttpCalloutMock mock = new FlexHttpCalloutMock().setMock();
        mock.withDefaultResponse('DefaultResponse');
        
		mock.ifUrlEqualsReturn('https://www.test.com', 'MatchedResponse');
        assertResp(client.getReq('https://www.test.com'), 200, 'MatchedResponse');
        assertResp(client.getReq('https://www.test2.com'), 200, 'DefaultResponse');
        
        mock.clearConfigs().ifUrlEqualsReturn('https://www.test.com', 204, 'MatchedResponse');
        assertResp(client.getReq('https://www.test.com'), 204, 'MatchedResponse');

        mock.clearConfigs().ifUrlEqualsIgnoreCaseReturn('https://www.test.com', 'MatchedResponse');
        assertResp(client.getReq('https://www.test.com'), 200, 'MatchedResponse');
        assertResp(client.getReq('https://www.TEST.com'), 200, 'MatchedResponse');

        mock.clearConfigs().ifUrlEqualsIgnoreCaseReturn('https://www.test.com', 204, 'MatchedResponse');
        assertResp(client.getReq('https://www.test.com'), 204, 'MatchedResponse');
        assertResp(client.getReq('https://www.TEST.com'), 204, 'MatchedResponse');

        mock.clearConfigs().ifUrlContainsReturn('test', 'MatchedResponse');
        assertResp(client.getReq('https://www.test.com'), 200, 'MatchedResponse');
        assertResp(client.getReq('https://www.datasert.com/test'), 200, 'MatchedResponse');
        assertResp(client.getReq('https://test.datasert.com'), 200, 'MatchedResponse');
        assertResp(client.getReq('https://www.google.com'), 200, 'DefaultResponse');
        assertResp(client.getReq('https://www.TEST.com'), 200, 'DefaultResponse');

        mock.clearConfigs().ifUrlContainsReturn('test', 204, 'MatchedResponse');
        assertResp(client.getReq('https://www.test.com'), 204, 'MatchedResponse');

        mock.clearConfigs().ifUrlContainsIgnoreCaseReturn('test', 'MatchedResponse');
        assertResp(client.getReq('https://www.test.com'), 200, 'MatchedResponse');
        assertResp(client.getReq('https://www.TEST.com'), 200, 'MatchedResponse');
        assertResp(client.getReq('https://www.datasert.com/test'), 200, 'MatchedResponse');
        assertResp(client.getReq('https://www.datasert.com/TEST'), 200, 'MatchedResponse');
        assertResp(client.getReq('https://test.datasert.com'), 200, 'MatchedResponse');
        assertResp(client.getReq('https://TEST.datasert.com'), 200, 'MatchedResponse');
        assertResp(client.getReq('https://www.google.com'), 200, 'DefaultResponse');

        mock.clearConfigs().ifUrlContainsIgnoreCaseReturn('test', 204, 'MatchedResponse');
        assertResp(client.getReq('https://www.test.com'), 204, 'MatchedResponse');
        assertResp(client.getReq('https://www.TEST.com'), 204, 'MatchedResponse');

        mock.clearConfigs().ifUrlEndsWithReturn('test', 'MatchedResponse');
        assertResp(client.getReq('https://www.test.com'), 200, 'DefaultResponse');
        assertResp(client.getReq('https://www.TEST.com'), 200, 'DefaultResponse');
        assertResp(client.getReq('https://www.datasert.com/test'), 200, 'MatchedResponse');
        assertResp(client.getReq('https://www.datasert.com/TEST'), 200, 'DefaultResponse');
        assertResp(client.getReq('https://test.datasert.com'), 200, 'DefaultResponse');
        assertResp(client.getReq('https://TEST.datasert.com'), 200, 'DefaultResponse');
        assertResp(client.getReq('https://www.google.com'), 200, 'DefaultResponse');
        
        mock.clearConfigs().ifUrlEndsWithReturn('test', 204, 'MatchedResponse');
        assertResp(client.getReq('https://www.test.com/test'), 204, 'MatchedResponse');

        mock.clearConfigs().ifUrlEndsWithIgnoreCaseReturn('test', 'MatchedResponse');
        assertResp(client.getReq('https://www.test.com'), 200, 'DefaultResponse');
        assertResp(client.getReq('https://www.TEST.com'), 200, 'DefaultResponse');
        assertResp(client.getReq('https://www.datasert.com/test'), 200, 'MatchedResponse');
        assertResp(client.getReq('https://www.datasert.com/TEST'), 200, 'MatchedResponse');
        assertResp(client.getReq('https://test.datasert.com'), 200, 'DefaultResponse');
        assertResp(client.getReq('https://TEST.datasert.com'), 200, 'DefaultResponse');
        assertResp(client.getReq('https://www.google.com'), 200, 'DefaultResponse');

        mock.clearConfigs().ifUrlEndsWithIgnoreCaseReturn('test', 204, 'MatchedResponse');
        assertResp(client.getReq('https://www.test.com/test'), 204, 'MatchedResponse');
        assertResp(client.getReq('https://www.test.com/TEST'), 204, 'MatchedResponse');
    
        mock.clearConfigs().ifUrlStartsWithReturn('https://test', 'MatchedResponse');
        assertResp(client.getReq('https://www.test.com'), 200, 'DefaultResponse');
        assertResp(client.getReq('https://www.TEST.com'), 200, 'DefaultResponse');
        assertResp(client.getReq('https://www.datasert.com/test'), 200, 'DefaultResponse');
        assertResp(client.getReq('https://www.datasert.com/TEST'), 200, 'DefaultResponse');
        assertResp(client.getReq('https://test.datasert.com'), 200, 'MatchedResponse');
        assertResp(client.getReq('https://TEST.datasert.com'), 200, 'DefaultResponse');
        assertResp(client.getReq('https://www.google.com'), 200, 'DefaultResponse');
        
        mock.clearConfigs().ifUrlStartsWithReturn('https://test', 204, 'MatchedResponse');
        assertResp(client.getReq('https://test.datasert.com'), 204, 'MatchedResponse');

        mock.clearConfigs().ifUrlStartsWithIgnoreCaseReturn('https://test', 'MatchedResponse');
        assertResp(client.getReq('https://www.test.com'), 200, 'DefaultResponse');
        assertResp(client.getReq('https://www.TEST.com'), 200, 'DefaultResponse');
        assertResp(client.getReq('https://www.datasert.com/test'), 200, 'DefaultResponse');
        assertResp(client.getReq('https://www.datasert.com/TEST'), 200, 'DefaultResponse');
        assertResp(client.getReq('https://test.datasert.com'), 200, 'MatchedResponse');
        assertResp(client.getReq('https://TEST.datasert.com'), 200, 'MatchedResponse');
        assertResp(client.getReq('https://www.google.com'), 200, 'DefaultResponse');

        mock.clearConfigs().ifUrlStartsWithIgnoreCaseReturn('https://test', 204, 'MatchedResponse');
        assertResp(client.getReq('https://test.datasert.com'), 204, 'MatchedResponse');
        assertResp(client.getReq('https://TEST.datasert.com'), 204, 'MatchedResponse');

        mock.clearConfigs().ifUrlEqualsCountReturn('https://test.datasert.com', 3, 204, 'MatchedResponse');
        assertResp(client.getReq('https://test.datasert.com'), 200, 'DefaultResponse');
        assertResp(client.getReq('https://test.datasert.com'), 200, 'DefaultResponse');
        assertResp(client.getReq('https://test.datasert.com'), 204, 'MatchedResponse');

        mock.clearConfigs().ifBodyContainsReturn('test', 'MatchedResponse');
        assertResp(client.postReq('https://test.datasert.com', 'prefix-test-suffix'), 200, 'MatchedResponse');
        assertResp(client.postReq('https://test.datasert.com', 'prefix-suffix'), 200, 'DefaultResponse');

        mock.clearConfigs().ifBodyContainsReturn('test', 204, 'MatchedResponse');
        assertResp(client.postReq('https://test.datasert.com', 'prefix-test-suffix'), 204, 'MatchedResponse');
        assertResp(client.postReq('https://test.datasert.com', 'prefix-suffix'), 200, 'DefaultResponse');

        mock.clearConfigs().ifBodyEqualsReturn('test', 'MatchedResponse');
        assertResp(client.postReq('https://test.datasert.com', 'test'), 200, 'MatchedResponse');
        assertResp(client.postReq('https://test.datasert.com', 'test-test'), 200, 'DefaultResponse');

        mock.clearConfigs().ifBodyEqualsReturn('test', 204, 'MatchedResponse');
        assertResp(client.postReq('https://test.datasert.com', 'test'), 204, 'MatchedResponse');
        assertResp(client.postReq('https://test.datasert.com', 'test-test'), 200, 'DefaultResponse');

        mock.clearConfigs().ifBodyStartsWithReturn('test', 'MatchedResponse');
        assertResp(client.postReq('https://test.datasert.com', 'test-test'), 200, 'MatchedResponse');
        assertResp(client.postReq('https://test.datasert.com', 'notest-test'), 200, 'DefaultResponse');

        mock.clearConfigs().ifBodyStartsWithReturn('test', 204, 'MatchedResponse');
        assertResp(client.postReq('https://test.datasert.com', 'test-test'), 204, 'MatchedResponse');
        assertResp(client.postReq('https://test.datasert.com', 'notest-test'), 200, 'DefaultResponse');

        mock.clearConfigs().ifBodyEndsWithReturn('test', 'MatchedResponse');
        assertResp(client.postReq('https://test.datasert.com', 'test-test'), 200, 'MatchedResponse');
        assertResp(client.postReq('https://test.datasert.com', 'test-testno'), 200, 'DefaultResponse');

        mock.clearConfigs().ifBodyEndsWithReturn('test', 204, 'MatchedResponse');
        assertResp(client.postReq('https://test.datasert.com', 'test-test'), 204, 'MatchedResponse');
        assertResp(client.postReq('https://test.datasert.com', 'test-testno'), 200, 'DefaultResponse');
    }
    
    private static void assertResp(HttpClientRequest req, Integer status, String body) {
        HttpClientResponse resp= req.send();
        assert.that(resp.statusCode()).isEqualsTo(status);
        assert.that(resp.body()).isEqualsTo(body);
    }
}