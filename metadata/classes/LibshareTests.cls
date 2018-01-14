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
    }
}