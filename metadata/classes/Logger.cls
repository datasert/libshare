global class Logger {
    private String name;
    
    global Logger() {
        this.name = new Utils().getCallingClassAndMethod()[0];
        if (name == 'Unknown') {
            this.name = null;
        }
    }
    
    global Logger(String name) {
        this.name = name;
    }
	
    global void error(Object msg) {
		log(LoggingLevel.Error, msg, null);        
    }

    global void error(Object msg, Object arg1) {
        log(LoggingLevel.Error, msg, new Object[]{arg1});
    }

    global void error(Object msg, Object arg1, Object arg2) {
		log(LoggingLevel.Error, msg, new Object[]{arg1, arg2});
    }

    global void error(Object msg, Object arg1, Object arg2, Object arg3) {
		log(LoggingLevel.Error, msg, new Object[]{arg1, arg2, arg3});
    }

    global void error(Object msg, List<Object> args) {
        log(LoggingLevel.Error, msg, args);
    }

    global void warn(Object msg) {
		log(LoggingLevel.Warn, msg, null);        
    }

    global void warn(Object msg, Object arg1) {
        log(LoggingLevel.Warn, msg, new Object[]{arg1});
    }

    global void warn(Object msg, Object arg1, Object arg2) {
		log(LoggingLevel.Warn, msg, new Object[]{arg1, arg2});
    }

    global void warn(Object msg, Object arg1, Object arg2, Object arg3) {
		log(LoggingLevel.Warn, msg, new Object[]{arg1, arg2, arg3});
    }

    global void warn(Object msg, List<Object> args) {
        log(LoggingLevel.Warn, msg, args);
    }
    
    global void info(Object msg) {
		log(LoggingLevel.Info, msg, null);        
    }

    global void info(Object msg, Object arg1) {
        log(LoggingLevel.Info, msg, new Object[]{arg1});
    }

    global void info(Object msg, Object arg1, Object arg2) {
		log(LoggingLevel.Info, msg, new Object[]{arg1, arg2});
    }

    global void info(Object msg, Object arg1, Object arg2, Object arg3) {
		log(LoggingLevel.Info, msg, new Object[]{arg1, arg2, arg3});
    }

    global void info(Object msg, List<Object> args) {
        log(LoggingLevel.Info, msg, args);
    }
	
    global void debug(Object msg) {
		log(LoggingLevel.Debug, msg, null);        
    }

    global void debug(Object msg, Object arg1) {
        log(LoggingLevel.Debug, msg, new Object[]{arg1});
    }

    global void debug(Object msg, Object arg1, Object arg2) {
		log(LoggingLevel.Debug, msg, new Object[]{arg1, arg2});
    }

    global void debug(Object msg, Object arg1, Object arg2, Object arg3) {
		log(LoggingLevel.Debug, msg, new Object[]{arg1, arg2, arg3});
    }

    global void debug(Object msg, List<Object> args) {
        log(LoggingLevel.Debug, msg, args);
    }

    private void log(LoggingLevel level, Object msg, List<Object> args) {
        System.debug(level, formatMessage(msg, args));
    }
    
    @TestVisible
    private Object formatMessage(Object msg, List<Object> args) {
        if (args == null || args.isEmpty()) {
            return getLoggerPrefix() + msg;
        }
        
        List<String> strLst = new List<String>();
        for (Object val : args) {
            strLst.add(String.valueOf(val));
        }
        
        return getLoggerPrefix() + String.format(String.valueOf(msg), strLst);
    }
    
    private String getLoggerPrefix() {
        return String.isBlank(name) ? '' : name + ': ';
    }
}