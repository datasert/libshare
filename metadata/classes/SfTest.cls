@IsTest
public class SfTest {
    testmethod public static void test() {
        System.assertNotEquals(null, Sf.settings);
        System.assertNotEquals(null, Sf.assert);
    }
}