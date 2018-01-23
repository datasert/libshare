global class AppLogBuilder {
	private App_Log__c appLog = new App_Log__c();
    private static Utils u = new Utils();
    
    public AppLogBuilder() {
    }
    
    global AppLogBuilder module(String value) {
        appLog.Module__c = value;
        return this;
    }

    global AppLogBuilder action(String action) {
        appLog.Action__c = action;
        return this;
    }

    global AppLogBuilder typeError() {
        appLog.Type__c = 'Error';
        return this;
    }
    
    global AppLogBuilder typeDebug() {
        appLog.Type__c = 'Debug';
        return this;
    }
    
    global AppLogBuilder appTask(App_Task__c value) {
        return appTask(value.id);
    }

    global AppLogBuilder appTask(Id value) {
        appLog.App_Task_Id__c = value;
        return this;
    }

    global AppLogBuilder externalId(String value) {
        appLog.External_Id__c = value;
        return this;
    }

    global AppLogBuilder message(String value) {
        appLog.Message__c = value;
        return this;
    }

    global AppLogBuilder record(Sobject value) {
        appLog.Record_Id__c = value.id;
        appLog.Sobject__c = u.getSobject(value);
        return this;
    }

    global AppLogBuilder value1(String value) {
        appLog.Value1__c = value;
        return this;
    }

    global AppLogBuilder value2(String value) {
        appLog.Value2__c = value;
        return this;
    }

    global AppLogBuilder value3(String value) {
        appLog.Value3__c = value;
        return this;
    }

    global AppLogBuilder value4(String value) {
        appLog.Value4__c = value;
        return this;
    }

    global AppLogBuilder value5(String value) {
        appLog.Value5__c = value;
        return this;
    }
    
    global AppLogBuilder append(String value) {
		Sf.appLogger.append(appLog, value);
        return this;
    }
    
    global AppLogBuilder append(String message, Exception e) {
		Sf.appLogger.append(appLog, message, e);
        return this;
    }

    global App_Log__c getAppLog() {
        return appLog;
    }
    
    global AppLogBuilder setAppLog(App_Log__c appLog) {
        this.appLog = appLog;
        return this;
    }

    global void save() {
        Sf.appLogger.save(appLog);
    }

    global void stash() {
        Sf.appLogger.stash(appLog);
    }
}