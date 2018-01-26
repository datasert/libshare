@IsTest
public class StopwatchTest {
	static Utils u = new Utils();
    
    testmethod public static void test_elapsedTime() {
        StopWatch sw = new StopWatch();
		
        u.sleep(1100);
        
        Integer elapsedTime = sw.getElapsedTime();
        
        System.assert(elapsedTime > 900);
		System.assert(sw.getElapsedTimeString().contains('1s'));
		System.assert(sw.toString().contains('1s'));
        sw.reset();

        Integer elapsedTime2 = sw.getElapsedTime();
        
        //Since we didn't put any delay after reset before getting the elapsed time
        System.assert(elapsedTime > elapsedTime2);
        
    }

    testmethod public static void test_consumedLimits() {
        StopWatch sw = new StopWatch();
		
		List<Account> acts = [select id from account];
        	
        System.assert(sw.getConsumedLimitsString().contains('Queries'));
        
        sw.reset();

        System.assert(!sw.getConsumedLimitsString().contains('Queries'));
    }

    testmethod public static void test_savedMeasures() {
        StopWatch sw = new StopWatch();
		
		List<Account> acts = [select id from account];
		acts = [select id from account];
        	
        sw.saveAndReset('First');

		acts = [select id from account];
        sw.saveAndReset('Second');
        
        System.assertEquals(3, sw.getSavedMeasures().size());
        System.assertEquals('Overall', sw.getSavedMeasures().get(0).name);
        System.assertEquals(3, sw.getSavedMeasures().get(0).consumedLimits.get('Queries'));

        System.assertEquals('First', sw.getSavedMeasures().get(1).name);
        System.assertEquals(2, sw.getSavedMeasures().get(1).consumedLimits.get('Queries'));

        System.assertEquals('Second', sw.getSavedMeasures().get(2).name);
        System.assertEquals(1, sw.getSavedMeasures().get(2).consumedLimits.get('Queries'));
        
        System.assert(sw.getSavedMeasuresString().contains('Queries=1'));
        System.assert(sw.getSavedMeasuresString().contains('Queries=2'));
    }
}