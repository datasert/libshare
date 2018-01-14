public class Asserter {
    class AssertionEntry {
        boolean result {get;set;}
        String message {get;set;}
        String stacktrace {get;set;}	
        
        AssertionEntry(boolean result, String message, String stacktrace) {
            this.result = result;
            this.message = message;
            this.stacktrace = stacktrace;
        }
    }
    
	private List<AssertionEntry> entries = new List<AssertionEntry>();
    public boolean multi {get;set;}	
    public boolean useCustomException {get;set;}	
    
    public Asserter() {
        multi = false;
        useCustomException = false;
    }
    
    public void assert(boolean result, String message) {
        if (!multi) {
            evaluateAndThrow(result, message);
        } else {
            if (!result) {
				entries.add(new AssertionEntry(result, message, null));
            }
        }
    }
    
    public void evaluate() {
        if (entries.isEmpty()) {
            return;
        }
        
		String message = null;
        for (AssertionEntry entry : entries) {
            if (message != null) {
                message += '\n-----------------------------------------------\n';
            } else {
                message = '';
            }
            message += entry.message;
            message += '\n';
            message += entry.stacktrace;
            
            message = message.trim();
        }
        
        entries.clear();
        evaluateAndThrow(false, message);
    }
    
    private void evaluateAndThrow(boolean result, String message) {
        if (useCustomException) {
            if (!result) {
                throw new AssertException(message);
            }
        } else {
            System.assert(result, message);
        }
    }
}