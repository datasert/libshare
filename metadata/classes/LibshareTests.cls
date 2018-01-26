@IsTest
public class LibshareTests {
    
    testmethod public static void include_tests() {
        new SfTest();
        new SettingsTest();

        new AssertTest();

        new StringAssertTest();
        new IntegerAssertTest();
        new DecimalAssertTest();
        new BooleanAssertTest();
        new DateAssertTest();
        new DatetimeAssertTest();
        
        new LoggerTest();
        new UtilsTest();
        new AppLoggerTest();
        new AppLogBuilderTest();
        
        new FlexHttpCalloutMockTest();
        new FlexHttpRequestMatcherTest();
        new FlexHttpResponseProviderTest();
        new JsonMapperTest();
        new SettingsPostSandboxCopyHandlerTest();
        new StopwatchTest();
        new DbChangesTest();
    }
}