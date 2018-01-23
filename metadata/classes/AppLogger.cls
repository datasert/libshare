global class AppLogger {
    private static Integer DetailsMaxLength = 131000;
    private static Integer MessageMaxLength = 255;
    private static Integer DetailsFieldsCount = 5;
    private static Utils u = new Utils();
    private static List<App_Log__c> stashedLogs = new List<App_Log__c>();
    
    global void logError(String Message, Exception e) {
        save(append(new App_Log__c(), message, e));
    }
    
    global void save(App_Log__c appLog) {
        save(new List<App_Log__c>{appLog});
    }

    global void stash(App_Log__c appLog) {
        stashedLogs.add(appLog);
    }

    global void saveStashed() {
        save(stashedLogs);
        stashedLogs.clear();
    }
    
    global void save(List<App_Log__c> appLogs) {
        if (appLogs == null || appLogs.isEmpty()) {
            return;
        }
        
        for (App_Log__c appLog : appLogs) {
            processLog(appLog);
        }
        
        insert appLogs;
    }
	
	/**
	 * Go through the app log and normalizes the fields as below.
	 * 
	 * 1. Truncates the message to 255 chars
	 * 2. Concatinates all details fields and split them again with max possible width
	 */
    private void processLog(App_Log__c appLog) {
        String details = u.join(new Object[]{appLog.Details1__c, appLog.Details2__c, appLog.Details3__c, appLog.Details4__c, appLog.Details5__c});
        if (String.isNotBlank(details)) {
            List<String> splits = u.split(u.truncateStart(details, DetailsMaxLength * DetailsFieldsCount), DetailsMaxLength);
            
            for (Integer i = 0; i < DetailsFieldsCount; i++) {
                appLog.put('Details' + (i + 1) + '__c', i < splits.size() ? splits.get(i).trim() : null);
            }
        }
        
        if (String.isBlank(appLog.Message__c)) {
	       	appLog.Message__c = u.truncateEnd(details, MessageMaxLength);
        }
    }

    public App_Log__c append(App_Log__c appLog, String value) {
        if (String.isBlank(value)) {
            return appLog;
        }
        
        String details = u.firstNotBlank(appLog.Details1__c, '');
        details += '\n' + u.formatIsoDateTime(u.now()) + ' ' + value.trim();
        appLog.Details1__c = details;
        
        return appLog;
    }
    
    public App_Log__c append(App_Log__c appLog, String message, Exception e) {
        if (String.isBlank(message) && e == null) {
            return appLog;
        }
        
        if (e != null && (String.isBlank(appLog.Module__c) || String.isBlank(appLog.Action__c))) {
            String[] classMethod = u.getClassAndMethod(e);
            
            if (String.isBlank(appLog.Module__c)) {
                appLog.Module__c = classMethod[0];
            }

            if (String.isBlank(appLog.Action__c)) {
                appLog.Action__c = classMethod[1];
            }
        }
        
        appLog.Message__c = (u.firstNotBlank(message, e.getTypeName() + ': ' + e.getMessage())).trim();
        
        if (e != null) {
            appLog.Type__c = 'Error';
            String details = '';
            if (e instanceof LogDetailsProvider) {
                details += '\n' + ((LogDetailsProvider) e).getLogDetails();
            }
            details += '\nException: ' + u.getStackTrace(e);
			append(appLog, details.trim());
        }
        
        return appLog;
    }
}