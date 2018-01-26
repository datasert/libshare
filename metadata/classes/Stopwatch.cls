/**
 * Class implements the functionality to capture the elapsed time and consumed limits 
 * to measure the resources consumed by block of code.
 * <p>
 * When a new instance if created, current time and current limits will be marked. Those resources
 * will be used to measure time and limits consumed at end of the measuring.
 */
global class Stopwatch {
	private static Utils u = new Utils();
    
    private static Map<String, Integer> maxLimits = new Map<String, Integer>{
        'AggregateQueries' => Limits.getLimitAggregateQueries(),
        'Callouts' => Limits.getLimitCallouts(),
        'CpuTime' => Limits.getLimitCpuTime(),
        'DatabaseTime' => Limits.getLimitDatabaseTime(),
        'DmlRows' => Limits.getLimitDmlRows(),
        'DmlStatements' => Limits.getLimitDmlStatements(),
        'EmailInvocations' => Limits.getLimitEmailInvocations(),
        'EmailInvocations' => Limits.getLimitEmailInvocations(),
        'FindSimilarCalls' => Limits.getLimitFindSimilarCalls(),
        'FutureCalls' => Limits.getLimitFutureCalls(),
        'HeapSize' => Limits.getLimitHeapSize(),
        'MobilePushApexCalls' => Limits.getLimitMobilePushApexCalls(),
        'Queries' => Limits.getLimitQueries(),
        'QueryLocatorRows' => Limits.getLimitQueryLocatorRows(),
        'QueryRows' => Limits.getLimitQueryRows(),
        'QueueableJobs' => Limits.getLimitQueueableJobs(),
        'RunAs' => Limits.getLimitRunAs(),
        'SavepointRollbacks' => Limits.getLimitSavepointRollbacks(),
        'Savepoints' => Limits.getLimitSavepoints(),
        'SoslQueries' => Limits.getLimitSoslQueries()
    };

    private DateTime startTime;
	private Map<String, Integer> startLimits = new Map<String, Integer>();
    private List<SavedMeasure> savedMeasures = new List<SavedMeasure>();
    
    global class SavedMeasure {
        global String name {get;set;}
        global Integer elapsedTime {get;set;}
        global Map<String, Integer> consumedLimits {get;set;}

        global SavedMeasure() {
            consumedLimits = new Map<String, Integer>();
        }
            
        global SavedMeasure(String name, Integer elapsedTime, Map<String, Integer> consumedLimits) {
            this.name = name;
            this.elapsedTime = elapsedTime;
            this.consumedLimits = consumedLimits;
        }
    }
    
    /**
     * Creates a new instance of Stopwatch and marks the current resources
     */
    global Stopwatch() {
		reset();
    }
    
    /**
     * Returns the number of milli seconds which are elapsed since this object was created or since last reset.
     */ 
    global Integer getElapsedTime() {
        return (Integer) (DateTime.now().getTime() - startTime.getTime());
    }
	
    /**
     * Returns the elapsed time in string format for loggging.
     */ 
    global String getElapsedTimeString() {
        return u.getDurationTiny(getElapsedTime());
    }
	

    /**
     * Resets the elapsed time and consumed limits to start point.
     */
    global void reset() {
        startTime = DateTime.now();
        startLimits = getCurrentLimits();
    }
    
    /**
     * Saves the current elapsed time and consumed limits against given module name. Stopwatch
     * keeps all saved entries in a list, which can be retrieved using getSavedEntries method.
     */
    global void saveAndReset(String name) {
        savedMeasures.add(new SavedMeasure(name, getElapsedTime(), getConsumedLimits()));
		reset();
    }
    
    /**
     * Returns the Saved Measures in a string form for easy display.
     */
	global String getSavedMeasuresString(){
	    String output = '';
	    for (Stopwatch.SavedMeasure entry : getSavedMeasures()) {
            if (String.isNotBlank(output)) {
                output += ', ';
            }
	    	output += 'name=' + entry.name + ', elapsedTime=' + u.getDurationTiny(entry.elapsedTime) + ', consumedLimits=[' + getLimitsString(entry.consumedLimits) +']';
	    }
	    return  output;
    }
    
    private SavedMeasure createOverallSavedMeasure() {
        SavedMeasure overall = new SavedMeasure();
        overall.name = 'Overall';
        
        for (SavedMeasure measure : savedMeasures) {
            overall.elapsedTime = u.add(overall.elapsedTime, measure.elapsedTime);
            
            for (String key : measure.consumedLimits.keySet()) {
	            overall.consumedLimits.put(key, u.add(overall.consumedLimits.get(key), measure.consumedLimits.get(key)));
            }
        }
                    
		return overall;
    }
    
    /**
     * Returns the list of saved entries.
     */
	global List<SavedMeasure> getSavedMeasures(){
        List<SavedMeasure> all = new List<SavedMeasure>();
		all.add(createOverallSavedMeasure());
        all.addAll(savedMeasures);
        
        return all;
    }
     
    /**
     * Returns the map of LimitName=ConsumedUnits map of all consumed limits.
     * If a limit is not consumed, then it is not returned in the map.
     */
    global Map<String, Integer> getConsumedLimits() {
        Map<String, Integer> newLimits = getCurrentLimits();
        for (String key : startLimits.keySet()) {
            Integer elapsedValue = newLimits.get(key) - startLimits.get(key);
            if (elapsedValue == 0) {
                newLimits.remove(key);
            } else {
                newLimits.put(key, elapsedValue);
            }
        }
        
        return newLimits;
    }
	
    /**
     * Returns the current limits in a easy as easy to use Map
     */
    global Map<String, Integer> getCurrentLimits() {
        
        Map<String, Integer> limitsMap = new Map<String, Integer>();
        limitsMap.put('AggregateQueries', Limits.getAggregateQueries());
        limitsMap.put('Callouts', Limits.getCallouts());
        limitsMap.put('CpuTime', Limits.getCpuTime());
        limitsMap.put('DatabaseTime', Limits.getDatabaseTime());
        limitsMap.put('DmlRows', Limits.getDmlRows());
        limitsMap.put('DmlStatements', Limits.getDmlStatements());
        limitsMap.put('EmailInvocations', Limits.getEmailInvocations());
        limitsMap.put('EmailInvocations', Limits.getEmailInvocations());
        limitsMap.put('FindSimilarCalls', Limits.getFindSimilarCalls());
        limitsMap.put('FutureCalls', Limits.getFutureCalls());
        limitsMap.put('HeapSize', Limits.getHeapSize());
        limitsMap.put('MobilePushApexCalls', Limits.getMobilePushApexCalls());
        limitsMap.put('Queries', Limits.getQueries());
        limitsMap.put('QueryLocatorRows', Limits.getQueryLocatorRows());
        limitsMap.put('QueryRows', Limits.getQueryRows());
        limitsMap.put('QueueableJobs', Limits.getQueueableJobs());
        limitsMap.put('RunAs', Limits.getRunAs());
        limitsMap.put('SavepointRollbacks', Limits.getSavepointRollbacks());
        limitsMap.put('Savepoints', Limits.getSavepoints());
        limitsMap.put('SoslQueries', Limits.getSoslQueries());
        
        return limitsMap;
    }
    
    /**
     * Returns the current consumed limits in a string form for easy logging
     */
    global String getConsumedLimitsString() {
        return getLimitsString(getConsumedLimits());
    }
    
    private String getLimitsString(Map<String, Integer> consumedLimits) {
        List<String> keys = new List<String>();
        keys.addAll(consumedLimits.keySet());
        keys.sort();
        
        String value = '';
        for (String key : keys) {
            if (!String.isBlank(value)) {
                value += ', ';
            }
            
            value += key + '=' + consumedLimits.get(key) + '/' + maxLimits.get(key);
        }
        
        return value;
    }
    
    /**
     * Returns the current elapsed time and consumed limits for logging purpose.
     */
    global override String toString() {
        return 'elapsedTime=' + u.getDurationTiny(getElapsedTime()) + ', consumedLimits=[' + getConsumedLimitsString() + ']';
    }
}