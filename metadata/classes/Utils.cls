global class Utils {
    private static final List<String> durationNamesLong = new List<String>{' years', ' months', ' days', ' hours', ' minutes', ' seconds', ' milliseconds'};
    private static final List<String> durationNamesShort = new List<String>{' yrs', ' mths', ' days', ' hrs', ' mins', ' secs', ' millis'};
    private static final List<String> durationNamesTiny = new List<String>{'y', 'mn', 'd', 'h', 'm', 's', 'ms'};
    public static final Long MILLIS = 1000;
    public static final Long SECS = 1000 * 60;
    public static final Long MINS = 60 * SECS;
    public static final Long HRS = 60 * MINS;
    public static final Long DAYS = 24 * HRS;
    public static final Long MONTHS = 30 * DAYS;
    public static final Long YEARS = 12 * MONTHS;
    
    global static final Utils INSTANCE = new Utils();
	    
    global String encode(String value, String encodeMode) {
        if (String.isBlank(value)) {
            return value;
        }
        
        if (String.isBlank(encodeMode)) {
            throw new LibshareException('Escape mode cannot be blank');
        }
        
        encodeMode = encodeMode.trim().toLowerCase();
            
        if (encodeMode == 'url') {
            value = encodeUrl(value);
            
        } else if (encodeMode == 'xml') {
            value = encodeXml(value);
            
        } else if (encodeMode == 'html') {
            value = encodeHtml(value);
            
        } else if (encodeMode == 'base64') {
            value = encodeBase64(value);

        } else if (encodeMode == 'base64urlsafe') {
            value = encodeBase64UrlSafe(value);
            
        } else {
            throw new LibshareException('Unrecognized encode mode ' + encodeMode + '. Valid values are [url, xml, html, base64, base64urlsafe]');
        }
        
        return value;
    }

    global String encodeUrl(String value) {
        if (value == null) {
            return null;
        }
        return EncodingUtil.urlEncode(value, 'UTF-8');
    }

    global String encodeXml(String value) {
        if (value == null) {
            return null;
        }
        return value.escapeXml();
    }

    global String encodeHtml(String value) {
        if (value == null) {
            return null;
        }
        return value.escapeHtml4();
    }

    global String encodeBase64(String value) {
        if (value == null) {
            return null;
        }
        return EncodingUtil.base64Encode(Blob.valueOf(value));
    }

    global String encodeBase64(Blob value) {
        if (value == null) {
            return null;
        }
        return EncodingUtil.base64Encode(value);
    }

    global String encodeBase64UrlSafe(Blob value) {
        if (value == null) {
            return null;
        }

        String encoded = EncodingUtil.base64Encode(value);
        encoded = encoded.replaceAll('\\+', '-');
        encoded = encoded.replaceAll('/', '_');
        encoded = encoded.replaceAll('=', '');
        return encoded;
    }
    
    global String encodeBase64UrlSafe(String value) {
        if (value == null) {
            return null;
        }
        
		return encodeBase64UrlSafe(Blob.valueOf(value));
    }

    global String decodeUrl(String value) {
        if (value == null) {
            return null;
        }

        return EncodingUtil.urlDecode(value, 'UTF-8');
    }

    global String decodeXml(String value) {
        if (value == null) {
            return null;
        }

        return value.unescapeXml();
    }

    global String decodeHtml(String value) {
        if (value == null) {
            return null;
        }

        return value.unescapeHtml4();
    }

    global String decodeBase64(String value) {
        if (value == null) {
            return null;
        }

        return EncodingUtil.base64Decode(value).toString();
    }

    global Blob decodeBase64AsBlob(String value) {
        if (value == null) {
            return null;
        }

        return EncodingUtil.base64Decode(value);
    }
    
    global Boolean toBoolean(Object obj) {
        return toBoolean(obj, false);
    }
    
    global Boolean toBoolean(Object obj, boolean defaultValue) {
        if (obj == null) {
            return defaultValue;

        } else if (obj instanceof Boolean) {
            return (Boolean) obj;

        } else {
            return Boolean.valueOf(String.valueOf(obj));
        }
    }


    global Integer toInteger(Object value, Integer defaultValue) {
		return toInteger(value, null, defaultValue, null);
    }
    
    global Integer toInteger(Object value, Integer min, Integer defaultValue, Integer max) {
        if (value == null) {
            value = defaultValue;
        }
        
        Integer intValue = Integer.valueOf(value);
        
        if (min != null && intValue < min) {
            intValue = min;
        }
        
        if (max != null && intValue > max) {
            intValue = max;
        }
        
        return intValue;
    }

    global String replaceVars(String value, Map<String, Object> tokens) {
    	return replaceVars(value, tokens, null);
    }
    
    global String replaceVars(String value, Map<String, Object> tokens, String escapeMode) {
        System.debug('Value [' + value + '] before merging with tokens [' + tokens + ']');
        if (String.isBlank(value) || tokens == null || tokens.isEmpty()) {
            return value;
        }

        for (String token : tokens.keyset()) {
            Object tokenValue = tokens.get(token);
            value = replaceVars(value, token, tokenValue, escapeMode);
        }

        System.debug('Value [' + value + '] after merging with tokens [' + tokens + ']');
        
        return value;
    }
    
    global String replaceVars(String message, String token, Object value) {
        return replaceVars(message, token, value, null);
    }
    
    global String replaceVars(String message, String token, Object value, String encodeMode) {
        if (String.isBlank(message) || String.isBlank(token)) {
            return message;
        }
        
        //There are special chars which needs to be replaced in value.
        String strValue = toString(value);
        if (String.isNotBlank(encodeMode)) {
            strValue = encode(strValue, encodeMode);
        }
        
        return message.replaceAll('\\$\\{' + token + '}', emptyIfNull(strValue));
    }
    
    global String toString(Object value) {
        if (value == null) {
            return null;
        }
		
        if (value instanceof Date) {
            return formatIsoDate((Date) value);
        }

        if (value instanceof DateTime) {
            return formatIsoDateTime((DateTime) value);
        }
        
        return String.valueOf(value);
    }
    
    /**
     * Calculates the difference between two datetimes in days. If either of dates is null, then response is null as well.
     */ 
    global Integer diffInDays(DateTime d1, DateTime d2)  {
        if (d1 == null || d2 == null) {
            return null;
        }
		
		Integer diff = (Integer) Math.abs((d1.getTime() - d2.getTime()) / (1000 * 60 * 60 * 24));
        System.debug('Difference between ' + d1 + ' and ' + d2 + ' is ' + diff + ' days');
        return diff;
    }

    global String formatIsoDateTime(DateTime dateTimeVal) {
        if (dateTimeVal == null) {
            return null;
        }
        return dateTimeVal.formatGmt('yyyy-MM-dd\'T\'HH:mm:ss\'Z\'');
    }

    global DateTime parseIsoDateTime(String dateTimeString) {
        if (String.isBlank(dateTimeString)) {
            return null;
        }
        return (DateTime)json.deserialize('"' + dateTimeString + '"', DateTime.class);
    }
    
    global String formatIsoDate(Date dt) {
        if (dt == null) {
            return null;
        }
        
        DateTime dtt = DateTime.newInstanceGmt(dt, Time.newInstance(0, 0, 0, 0));
        return dtt.formatGmt('yyyy-MM-dd');
    }

    global Date parseIsoDate(String dateString) {
        if (String.isBlank(dateString)) {
            return null;
        }
        return (Date) parseIsoDateTime(dateString + 'T00:00:00Z').dateGmt();
    }

    global String emptyIfNull (String value) {
        return value == null ? '' : value;
    }

    global List<ApexPages.Message> getPageErrors() {
        return getPageMessages(ApexPages.Severity.ERROR);
    }
    
    global List<ApexPages.Message> getPageInfos() {
        return getPageMessages(ApexPages.Severity.INFO);
    }

    global List<ApexPages.Message> getPageMessages(ApexPages.Severity severity) {
        List<ApexPages.Message> messages = new List<ApexPages.Message>();
        for(ApexPages.Message msg : ApexPages.getMessages()) {
            if (msg.getSeverity() == severity) {
                messages.add(msg);
            }
        }
        
        return messages;
    }
    
    /**
     * Adds a info message with specified label to the ApexMessages.
     */
    global void addPageInfo(String messageString) {
        ApexPages.Message message = new ApexPages.Message(ApexPages.severity.INFO, messageString);
        ApexPages.addMessage(message);
    }
    
    global void addPageError(String message) {
        ApexPages.Message messageObj = new ApexPages.Message(ApexPages.severity.ERROR, message);
        ApexPages.addMessage(messageObj);
    }
    
    global void addPageError(Exception e) {
        System.debug(getStackTrace(e));
        addPageError(e.getMessage());
    }
    
    global PageReference getCurrentPage() {
        return System.currentPageReference();
    }

    global String getPageParam(String param) {
        String value = getPageParam(param, null);
        return value;
    }

    global String getPageParam(String param, String defaultValue) {
        PageReference page = getCurrentPage();
        if (page == null) {
            debug('Current page is null while getting the parameter ' + param);
            return null;
        }
        
        Map<String, String> parameters = page.getParameters();
        String value = parameters.get(param);
        if (value == null || (value == '' && defaultValue != null)) {
            debug('Parameters value is null for ' + param + ' so assigning the default value=' + defaultValue);
            value = defaultValue;
        }

        debug('Returning parameter ' + param + '=' + value);
        return value;
    }
    
    private void debug(String message) {
        System.debug(message);
    }
    
    global String join(Map<String, Object> parms) {
        return join(null, null, null, parms);
    }
    
    global String join(String fieldSeparator, String keyValueSeparator, Map<String, Object> parms) {
        return join(fieldSeparator, keyValueSeparator, null, parms);
    }
    
    global String join(String fieldSeparator, String keyValueSeparator, String encodeMode, Map<String, Object> parms) {
        String output = '';
        
        if (parms == null) {
            return null;
        }
        
        if (fieldSeparator == null) {
            fieldSeparator = ', ';
        }
        
        if (keyValueSeparator == null) {
            keyValueSeparator = '=';
        }

        for(String key : parms.keySet()) {
            if (String.isNotEmpty(output)) {
                output += fieldSeparator;
            }
            
            output += key + keyValueSeparator + (encodeMode == null ? parms.get(key) : encode(toString(parms.get(key)), encodeMode));
        }
        
        return output;
    }
    
    global String join(Object value1, String value2){
        return join('', false, new Object[]{value1, value2});
    }
    
    global String join(Object value1, Object value2, Object value3){
        return join(null, false, new Object[]{value1, value2, value3});
    }

    global String joinWith(String separator, Object value1, Object value2){
        return join(separator, false, new Object[]{value1, value2});
    }

    global String joinWith(String separator, Object value1, Object value2, Object value3){
        return join(separator, false, new Object[]{value1, value2, value3});
    }

    global String join(List<Object> strings){
        return join(null, false, strings);
    }

    global String join(String separator, List<Object> strings){
        return join(separator, false, strings);
    }
    
    global String join(String separator, Boolean skipNulls, List<Object> strings) {
        if(strings == null){
            return null;
        }
        if (separator == null) {
            separator = '';
        }
        String joinedString = null;
        for(Object value : strings) {
            if (skipNulls && value == null) {
                continue;
            }
            
            String strValue = firstNotBlank(toString(value), '');
            
            if (joinedString == null) {
                joinedString = strValue;
            } else {
                joinedString += separator + strValue;
            }
        }
        
        return joinedString;
    }
    
    global String getStackTrace(Exception e) {
        if (e == null) {
            return null;
        }
        
        try {
            String eString = e.getTypeName() + ': ' + e.getMessage() + '\n' + e.getStackTraceString().substringBefore('Caused by').trim();
            
            if (e.getCause() != null) {
                eString += '\nCaused by: ' + getStackTrace(e.getCause());
            }
            
            return eString;
        } catch (Exception e1) {
            return e.getStackTraceString();
        }
    }
    
    /**
     * Returns the root cause of this exception chain.
     */
    global Exception getRootCause(Exception e) {
        if (e == null || e.getCause() == null) {
            return e;
        }
        
        return getRootCause(e.getCause());
    }

    global DateTime now() {
        if (Test.isRunningTest() && TestUtils.getCurrentDateTime() != null) {
            return TestUtils.getCurrentDateTime();
        }
        
        return DateTime.now();
    }

    global Date today() {
        if (Test.isRunningTest() && TestUtils.getCurrentDate() != null) {
            return TestUtils.getCurrentDate();
        }
        
        return Date.today();
    }

    global SObject firstNotNull(SObject obj1, SObject obj2) {
        return obj1 != null ? obj1 : obj2;
    }

    global Object firstNotNull(Object obj1, Object obj2) {
        return obj1 != null ? obj1 : obj2;
    }

    global Object firstNotNull(Object obj1, Object obj2, Object obj3) {
        return firstNotNull( firstNotNull(obj1, obj2), obj3);
    }

    global String firstNotBlank(String v1, String v2) {
        return String.isBlank(v1) ? v2 : v1;
    }

    global String left(String value, Integer size) {
        if (value == null) {
            return null;
        }
        
        return value.left(size);
    }
    
    global String right(String value, Integer size) {
        if (value == null) {
            return null;
        }
        
        return value.right(size);
    }

    global boolean equalsIc(String value1, String value2) {
        if (value1 == null && value2 == null) {
            return true;
        }

        if (value1 == null || value2 == null) {
            return false;
        }
        
        return value1.equalsIgnoreCase(value2);
    }

    global Integer add(Integer value, Integer incrementValue) {
        return (value == null || value == 0) ? incrementValue : value + incrementValue;
    }

    global Decimal add(Decimal value, Decimal incrementValue) {
        return (value == null || value == 0.0) ? incrementValue: value + incrementValue;
    }

    global String getSobject(Id sobjId) {
        if (sobjId == null) {
            return sobjId;
        }
        
        return sobjId.getSobjectType().getDescribe().getName();
    }

    global String getSobject(Sobject sobj) {
        if (sobj == null) {
            return null;
        }
        
        return sobj.getSObjectType().getDescribe().getName();
    }
    
    global List<String> split(String text, Integer size) {
	    List<String> splits = new List<String>();
        if (text == null) {
            return splits;
        }
        
        for (Integer start = 0; start < text.length(); start += size) {
            splits.add(text.substring(start, Math.min(text.length(), start + size)));
        }
        
    	return splits;
    }
    
    global Exception createTestException() {
        try {
            Integer value = 100 / 0;
            return null;
        } catch (Exception e) {
            return e;
        }
    }
    
    global String[] getCallingClassAndMethod() {
        return getClassAndMethod(createTestException(), 3);
    }

    global String[] getClassAndMethod(Exception e) {
        return getClassAndMethod(e, 0);
    }
    
    global String[] getClassAndMethod(Exception e, Integer lineNum) {
        return getClassAndMethod(getRootCause(e).getStackTraceString().split('\n'), lineNum);
    }

    private static String[] UnknownClassAndMethod = new String[]{'Unknown', 'Unknown'};
        
    @TestVisible
    private String[] getClassAndMethod(List<String> stacktraceLines, Integer lineNum) {
        try {
            String classMethodLine = null;
            
            //System.debug('Exception lines ' + stacktraceLines);
            if (lineNum >= stacktraceLines.size()) {
                return UnknownClassAndMethod; 
            }
            
            String stackTraceLine = stacktraceLines.get(lineNum);
            
            //Line should be of format 
            //Class.IKnockLeadSyncServiceImpl.syncLeadsToIKnock: line 349, column 1
            String[] tokens = stackTraceLine.split(':')[0].split('\\.');
            //System.debug('Token after split ' + tokens);
 
            if (tokens.size() == 0) {
                return UnknownClassAndMethod;
            }
            
            //First token is keyword Class
            Integer index = 1;
            
            //Second is class name
            String[] resp = new String[2];
            	
            //Some time namespcae comes into the picture, it will have three tokens.
            if (tokens.size() > 3) {
	            resp[0] = tokens[index] + '.' + tokens[index + 1];
	            resp[1] = tokens[index + 2];
                
            } else if (tokens.size() == 3) {
	            resp[0] = tokens[index];
	            resp[1] = tokens[index + 1];
                
            } else {
                resp[0] = tokens[index];
                resp[1] = 'Unknown';
            }
            
            return resp;
        } catch (Exception e1) {
            System.debug('Excpetion while getting the class and method name from Exeption ' + getStackTrace(e1));
            return UnknownClassAndMethod;
        }
    }
    
    /**
     * There is no good way to induce some sleep into the execution thread in Salesforce. This call simulates the sleep by doing
     * very time conuming work. This is not the best way to do it, but it gets the job done.
     * <p>
     * Note that it is not a good practice to sleep during actual live thread but is useful during testing. So use this
     * with caution.
     */
    global void sleep(Integer milliSeconds) {
        Long startingTime = System.now().getTime();
        while (System.now().getTime() - startingTime < milliSeconds)  {
            getRandomString(1000);
        }
    }

    global String getRandomString(Integer length) {
        String randomString = String.valueOf(Math.abs(Crypto.getRandomLong()));
        while(true) {
            if (randomString.length() == length) {
                break;
            }

            if (randomString.length() < length) {
                randomString += String.valueOf(Math.abs(Crypto.getRandomLong()));
            }

            if (randomString.length() > length) {
                randomString = randomString.substring(0, length);
                break;
            }
        }

        return randomString;
    }
	
    /**
     * Generates a random number between 0 (inclusive) and given upper limit (inclusive)
     */
    global Integer getRandomInteger(Integer upper) {
		return getRandomInteger(0, upper);
    }

    /**
     * Generates a random number between 0 (inclusive) and 2,147,483,647 (inclusive)
     */
    global Integer getRandomInteger() {
		return getRandomInteger(0, 2147483647);
    }

    /**
     * Generates a random number between lower (inclusive) and upper (inclusive)
     */
    global Integer getRandomInteger(Integer lower, Integer upper) {
		return Math.round(Math.random() * (upper - lower)) + lower;
    }

    global String getStaticResource(String staticResourceName) {
        List<StaticResource> srs = [select id, body from StaticResource Where Name = :staticResourceName];
        if (srs.isEmpty()) {
            throw new LibshareException('Static Resource ' + staticResourceName + ' is not defined.');
        }
        
        String contents = srs.get(0).body.toString();
        return contents;
    }
    
    global String getDurationLong(long val) {
        return getDuration(val, durationNamesLong, ', ');
    }
    
    global String getDurationShort(long val) {
        return getDuration(val, durationNamesShort, ', ');
    }

    global String getDurationTiny(long val) {
        return getDuration(val, durationNamesTiny, ' ');
    }

    global String getDuration(long val, List<String> names, String separator) {
		List<Integer> values = getDurationParts(val);
        
        String output = appendDurationName('', values, names, 0, separator);
        output = appendDurationName(output, values, names, 1, separator);
        output = appendDurationName(output, values, names, 2, separator);
        output = appendDurationName(output, values, names, 3, separator);
        output = appendDurationName(output, values, names, 4, separator);
        output = appendDurationName(output, values, names, 5, separator);
        output = appendDurationName(output, values, names, 6, separator);
        
        return output.trim();
    }
    
    private String appendDurationName(String output, List<Integer> values, List<String> valueNames, Integer index, String separator) {
        String value =  values.get(index) > 0 ? (values.get(index) + valueNames.get(index)) : '';
        if (String.isBlank(value)) {
            return output;
        }
        
        return String.isBlank(output) ? value : output + separator + value;
    }
    
    private List<Integer> getDurationParts(long val) {
        Integer ms = Integer.valueOf(Math.mod(val, MILLIS));
        Integer s = Integer.valueOf(Math.mod(val / MILLIS, 60));
        Integer m = Integer.valueOf(Math.mod(val / SECS, 60));
        Integer h = Integer.valueOf(Math.mod(val / MINS, 24));
        Integer d = Integer.valueOf(Math.mod(val / HRS, 30));
        Integer mn = Integer.valueOf(Math.mod(val / DAYS, 12));
        Integer y = Integer.valueOf(val / MONTHS);
        
        return new List<Integer>{y, mn, d, h, m, s, ms};
    }
    
    global CalloutException getCalloutException(String msg) {
        CalloutException e = new CalloutException();
        e.setMessage(msg);
        return e;        
    }
    
    global String httpGet(String url) {
		return HttpClient.INSTANCE.get(url);
    }

    global Object httpGet(String url, System.Type cls) {
		return HttpClient.INSTANCE.get(url, cls);
    }

    global String httpPost(String url, Object body) {
		return HttpClient.INSTANCE.post(url, body);
    }

    global Object httpPost(String url, Object body, System.Type cls) {
		return HttpClient.INSTANCE.post(url, body, cls);
    }

    global String httpPatch(String url, Object body) {
		return HttpClient.INSTANCE.patch(url, body);
    }

    global Object httpPatch(String url, Object body, System.Type cls) {
		return HttpClient.INSTANCE.patch(url, body, cls);
    }

    global String httpPut(String url, Object body) {
		return HttpClient.INSTANCE.put(url, body);
    }

    global Object httpPut(String url, Object body, System.Type cls) {
		return HttpClient.INSTANCE.put(url, body, cls);
    }

    global String httpDelete(String url) {
		return HttpClient.INSTANCE.httpDelete(url);
    }

    global Object httpDelete(String url, System.Type cls) {
		return HttpClient.INSTANCE.httpDelete(url, cls);
    }
}