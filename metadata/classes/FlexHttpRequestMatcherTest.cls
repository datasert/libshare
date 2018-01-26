@IsTest
public class FlexHttpRequestMatcherTest {
	static Assert assert = sf.assert;
    static HttpRequest req1;
    static HttpRequest req2;
    static FlexHttpRequestMatcher matcher = new FlexHttpRequestMatcher();
    
    static void setup() {
        req1 = new HttpRequest();
        req1.setEndpoint('https://www.datasert.com');
        req1.setBody('The ISVforce Guide is written for independent software vendors (ISVs) who want to build and sell applications using the Lightning Platform platform.');
        req1.setMethod('GET');
		req1.setHeader('X-Req1', 'Value1');
        
        req2 = new HttpRequest();
        req2.setEndpoint('https://www.google.com');
        req2.setBody('Salesforce Platform provides an integrated architecture that lets you focus on building solutions rather than infrastructure');
        req2.setMethod('POST');
		req2.setHeader('X-SomeHeader', 'Value2');
    }
    
    testmethod public static void test_single_matchers() {
		setup();
            
        //Since there are match entries, it wont match
        assert.that(matcher.isMatches(new HttpRequestMatcherRequest(null, req1))).isEqualsTo(false);
        assert.that(matcher.isMatches(null)).isEqualsTo(false);
        
        assertMatch(req1, 'method', 'equals', 'GET', true);
        assertMatch(req2, 'method', 'equals', 'GET', false);
        
        assertMatch(req1, 'url', 'equals', 'https://www.datasert.org', false);
        assertMatch(req1, 'url', 'equals', 'https://www.datasert.com', true);
        assertMatch(req1, 'url', 'equals', 'https://www.DATASERT.com', false);
        assertMatch(req1, 'url', 'equalsIc', 'https://www.DATASERT.com', true);
        assertMatch(req1, 'url', 'contains', 'google', false);
        assertMatch(req1, 'url', 'contains', 'datasert', true);
		assertMatch(req1, 'url', 'contains', 'Datasert', false);
        assertMatch(req1, 'url', 'containsIc', 'Datasert', true);
        assertMatch(req1, 'url', 'startsWith', 'ftp', false);
        assertMatch(req1, 'url', 'startsWith', 'https', true);
        assertMatch(req1, 'url', 'startsWith', 'HTTPS', false);
        assertMatch(req1, 'url', 'startsWithIc', 'HTTPS', true);
        assertMatch(req1, 'url', 'endsWith', '.org', false);
        assertMatch(req1, 'url', 'endsWith', '.com', true);
        assertMatch(req1, 'url', 'endsWith', '.COM', false);
        assertMatch(req1, 'url', 'endsWithIc', '.COM', true);
        assertMatch(req1, 'url', 'matches', 'ftp.*\\.com', false);
        assertMatch(req1, 'url', 'matches', 'http.*\\.com', true);

        assertMatch(req1, 'url', 'notequals', 'https://www.datasert.org', true);
        assertMatch(req1, 'url', 'notequals', 'https://www.datasert.com', false);
        assertMatch(req1, 'url', 'notequals', 'https://www.DATASERT.com', true);
        assertMatch(req1, 'url', 'notequalsIc', 'https://www.DATASERT.com', false);
        assertMatch(req1, 'url', 'notcontains', 'google', true);
        assertMatch(req1, 'url', 'notcontains', 'datasert', false);
		assertMatch(req1, 'url', 'notcontains', 'Datasert', true);
        assertMatch(req1, 'url', 'notcontainsIc', 'Datasert', false);
        assertMatch(req1, 'url', 'notstartsWith', 'ftp', true);
        assertMatch(req1, 'url', 'notstartsWith', 'https', false);
        assertMatch(req1, 'url', 'notstartsWith', 'HTTPS', true);
        assertMatch(req1, 'url', 'notstartsWithIc', 'HTTPS', false);
        assertMatch(req1, 'url', 'notendsWith', '.org', true);
        assertMatch(req1, 'url', 'notendsWith', '.com', false);
        assertMatch(req1, 'url', 'notendsWith', '.COM', true);
        assertMatch(req1, 'url', 'notendsWithIc', '.COM', false);
        assertMatch(req1, 'url', 'notmatches', 'ftp.*\\.com', true);
        assertMatch(req1, 'url', 'notmatches', 'http.*\\.com', false);
        
        try {
            assertMatch(req1, 'url', 'notvalid', 'http.*\\.com', false);
            assert.expectedException();
        } catch (Exception e) {
            //ignore, expected
        }
        
        //test constructor
        matcher = new FlexHttpRequestMatcher('url', 'equals', 'https://www.datasert.com');
        assert.that(matcher.isMatches(new HttpRequestMatcherRequest(null, req1))).isEqualsTo(true);
    }
 	
    testmethod public static void test_multi_matchers() {
        setup();
        
        matcher
            .clear()
            .match('url', 'equals', 'https://www.datasert.com')
            .match('url', 'startsWith', 'https');
        
        assert.that(matcher.isMatches(new HttpRequestMatcherRequest(null, req1))).isEqualsTo(true);

        matcher
            .clear()
            .match('url', 'equals', 'https://www.datasert.com')
            .match('url', 'startsWith', 'ftp');

        assert.that(matcher.isMatches(new HttpRequestMatcherRequest(null, req1))).isEqualsTo(false);
    }
    
    testmethod public static void test_minMaxMatches() {
        setup();
        
        matcher = new FlexHttpRequestMatcher('url', 'equals', 'https://www.datasert.com', 2, 4);
        
        HttpRequestMatcherRequest matcherReq = new HttpRequestMatcherRequest(null, req1);
        
        assert.that(matcher.isMatches(matcherReq)).isEqualsTo(false);
        assert.that(matcher.isMatches(matcherReq)).isEqualsTo(true);
        assert.that(matcher.isMatches(matcherReq)).isEqualsTo(true);
        assert.that(matcher.isMatches(matcherReq)).isEqualsTo(true);
        assert.that(matcher.isMatches(matcherReq)).isEqualsTo(false);
    }

    testmethod public static void test_fieldTypes() {
        setup();
		
        assertMatch(req1, 'body', 'contains', 'ISVforce', true);
        assertMatch(req2, 'body', 'contains', 'ISVforce', false);
        
        assertMatch(req1, 'header:X-SomeHeader', 'equals', 'Value2', false);
        assertMatch(req2, 'header:X-SomeHeader', 'equals', 'Value2', true);
        
        try {
            assertMatch(req1, 'notvalid', 'equals', 'http.*\\.com', false);
            assert.expectedException();
        } catch (Exception e) {
            //ignore, expected
        }
    }

    static void assertMatch(HttpRequest req, String field, String operator, Object value, boolean match) {
        matcher.clear().match(field, operator, value);
        assert.that(matcher.isMatches(new HttpRequestMatcherRequest(null, req))).isEqualsTo(match);
    }
}