global virtual class Utils {
    global virtual Boolean isTrue(Object obj) {
        if (obj == null) {
            return false;

        } else if (obj instanceof Boolean) {
            return (Boolean) obj;

        } else {
            return Boolean.valueOf(String.valueOf(obj));
        }
    }

    global virtual String encode(String value, String encodeMode) {
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

    global virtual String encodeUrl(String value) {
        if (value == null) {
            return null;
        }
        return EncodingUtil.urlEncode(value, 'UTF-8');
    }

    global virtual String encodeXml(String value) {
        if (value == null) {
            return null;
        }
        return value.escapeXml();
    }

    global virtual String encodeHtml(String value) {
        if (value == null) {
            return null;
        }
        return value.escapeHtml4();
    }

    global virtual String encodeBase64(String value) {
        if (value == null) {
            return null;
        }
        return EncodingUtil.base64Encode(Blob.valueOf(value));
    }

    global virtual String encodeBase64(Blob value) {
        if (value == null) {
            return null;
        }
        return EncodingUtil.base64Encode(value);
    }

    global virtual String encodeBase64UrlSafe(Blob value) {
        if (value == null) {
            return null;
        }

        String encoded = EncodingUtil.base64Encode(value);
        encoded = encoded.replaceAll('\\+', '-');
        encoded = encoded.replaceAll('/', '_');
        encoded = encoded.replaceAll('=', '');
        return encoded;
    }
    
    global virtual String encodeBase64UrlSafe(String value) {
        if (value == null) {
            return null;
        }
        
		return encodeBase64UrlSafe(Blob.valueOf(value));
    }

    global virtual String decodeUrl(String value) {
        if (value == null) {
            return null;
        }

        return EncodingUtil.urlDecode(value, 'UTF-8');
    }

    global virtual String decodeXml(String value) {
        if (value == null) {
            return null;
        }

        return value.unescapeXml();
    }

    global virtual String decodeHtml(String value) {
        if (value == null) {
            return null;
        }

        return value.unescapeHtml4();
    }

    global virtual String decodeBase64(String value) {
        if (value == null) {
            return null;
        }

        return EncodingUtil.base64Decode(value).toString();
    }

    global virtual Blob decodeBase64AsBlob(String value) {
        if (value == null) {
            return null;
        }

        return EncodingUtil.base64Decode(value);
    }

    global virtual Integer normalize(Integer value, Integer min, Integer defaultValue, Integer max) {
        if (value == null) {
            value = defaultValue;
        }
        
        if (min != null && value < min) {
            value = min;
        }
        
        if (max != null && value > max) {
            value = max;
        }
        
        return value;
    }

    global virtual String replaceVars(String value, Map<String, Object> tokens) {
    	return replaceVars(value, tokens, null);
    }
    
    global virtual String replaceVars(String value, Map<String, Object> tokens, String escapeMode) {
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
    
    global virtual String replaceVars(String message, String token, Object value) {
        return replaceVars(message, token, value, null);
    }
    
    global virtual String replaceVars(String message, String token, Object value, String encodeMode) {
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
    
    global virtual String toString(Object value) {
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
    global virtual Integer diffInDays(DateTime d1, DateTime d2)  {
        if (d1 == null || d2 == null) {
            return null;
        }
		
		Integer diff = (Integer) Math.abs((d1.getTime() - d2.getTime()) / (1000 * 60 * 60 * 24));
        System.debug('Difference between ' + d1 + ' and ' + d2 + ' is ' + diff + ' days');
        return diff;
    }

    global virtual String formatIsoDateTime(DateTime dateTimeVal) {
        if (dateTimeVal == null) {
            return null;
        }
        return dateTimeVal.formatGmt('yyyy-MM-dd\'T\'HH:mm:ss\'Z\'');
    }

    global virtual DateTime parseIsoDateTime(String dateTimeString) {
        if (String.isBlank(dateTimeString)) {
            return null;
        }
        return (DateTime)json.deserialize('"' + dateTimeString + '"', DateTime.class);
    }
    
    global virtual String formatIsoDate(Date dt) {
        if (dt == null) {
            return null;
        }
        
        DateTime dtt = DateTime.newInstanceGmt(dt, Time.newInstance(0, 0, 0, 0));
        return dtt.formatGmt('yyyy-MM-dd');
    }

    global virtual Date parseIsoDate(String dateString) {
        if (String.isBlank(dateString)) {
            return null;
        }
        return (Date) parseIsoDateTime(dateString + 'T00:00:00Z').dateGmt();
    }

    global virtual String emptyIfNull (String value) {
        return value == null ? '' : value;
    }

    global virtual List<ApexPages.Message> getPageErrors() {
        return getPageMessages(ApexPages.Severity.ERROR);
    }
    
    global virtual List<ApexPages.Message> getPageInfos() {
        return getPageMessages(ApexPages.Severity.INFO);
    }

    global virtual List<ApexPages.Message> getPageMessages(ApexPages.Severity severity) {
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
    global virtual void addPageInfo(String messageString) {
        ApexPages.Message message = new ApexPages.Message(ApexPages.severity.INFO, messageString);
        ApexPages.addMessage(message);
    }
    
    global virtual void addPageError(String message) {
        ApexPages.Message messageObj = new ApexPages.Message(ApexPages.severity.ERROR, message);
        ApexPages.addMessage(messageObj);
    }
    
    global virtual void addPageError(Exception e) {
        System.debug(getStackTrace(e));
        addPageError(e.getMessage());
    }
    
    global virtual PageReference getCurrentPage() {
        return System.currentPageReference();
    }

    global virtual String getPageParam(String param) {
        String value = getPageParam(param, null);
        return value;
    }

    global virtual String getPageParam(String param, String defaultValue) {
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
    
    global virtual String join(Map<String, Object> parms) {
        return join(null, null, null, parms);
    }
    
    global virtual String join(String fieldSeparator, String keyValueSeparator, Map<String, Object> parms) {
        return join(fieldSeparator, keyValueSeparator, null, parms);
    }
    
    global virtual String join(String fieldSeparator, String keyValueSeparator, String encodeMode, Map<String, Object> parms) {
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
    
    global virtual String join(Object value1, String value2){
        return join('', false, new Object[]{value1, value2});
    }
    
    global virtual String join(Object value1, Object value2, Object value3){
        return join(null, false, new Object[]{value1, value2, value3});
    }

    global virtual String joinWith(String separator, Object value1, Object value2){
        return join(separator, false, new Object[]{value1, value2});
    }

    global virtual String joinWith(String separator, Object value1, Object value2, Object value3){
        return join(separator, false, new Object[]{value1, value2, value3});
    }

    global virtual String join(List<Object> strings){
        return join(null, false, strings);
    }

    global virtual String join(String separator, List<Object> strings){
        return join(separator, false, strings);
    }
    
    global virtual String join(String separator, Boolean skipNulls, List<Object> strings) {
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
    
    global virtual String getStackTrace(Exception e) {
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
    global virtual Exception getRootCause(Exception e) {
        if (e == null || e.getCause() == null) {
            return e;
        }
        
        return getRootCause(e.getCause());
    }

    global virtual DateTime now() {
        if (Test.isRunningTest() && TestUtils.getCurrentDateTime() != null) {
            return TestUtils.getCurrentDateTime();
        }
        
        return DateTime.now();
    }

    global virtual Date today() {
        if (Test.isRunningTest() && TestUtils.getCurrentDate() != null) {
            return TestUtils.getCurrentDate();
        }
        
        return Date.today();
    }

    global virtual SObject firstNotNull(SObject obj1, SObject obj2) {
        return obj1 != null ? obj1 : obj2;
    }

    global virtual Object firstNotNull(Object obj1, Object obj2) {
        return obj1 != null ? obj1 : obj2;
    }

    global virtual String firstNotBlank(String v1, String v2) {
        return String.isBlank(v1) ? v2 : v1;
    }

    global virtual String truncateEnd(String value, Integer size) {
        if (value == null) {
            return null;
        }
        
        if (value.length() <= size) {
            return value;
        }
        
        return value.substring(0, size);
    }
    
    global virtual String truncateStart(String value, Integer size) {
        if (value == null) {
            return null;
        }
        
        if (value.length() <= size) {
            return value;
        }
        
        return value.substring(value.length() - size);
    }

    global virtual boolean equalsIc(String value1, String value2) {
        if (value1 == null && value2 == null) {
            return true;
        }

        if (value1 == null || value2 == null) {
            return false;
        }
        
        return value1.equalsIgnoreCase(value2);
    }

    global virtual Integer increment(Integer value) {
        return increment(value, 1);
    }

    global virtual Integer increment(Integer value, Integer incrementValue) {
        return (value == null || value == 0) ? incrementValue : value + incrementValue;
    }

    global virtual Decimal increment(Decimal value) {
		return increment(value, 1);
    }
    
    global virtual Decimal increment(Decimal value, Integer incrementValue) {
        return (value == null || value == 0.0) ? incrementValue: value + incrementValue;
    }

    global virtual String getSobject(Id sobjId) {
        if (sobjId == null) {
            return sobjId;
        }
        
        return sobjId.getSobjectType().getDescribe().getName();
    }

    global virtual String getSobject(Sobject sobj) {
        if (sobj == null) {
            return null;
        }
        
        return sobj.getSObjectType().getDescribe().getName();
    }
    
    global virtual List<String> split(String text, Integer size) {
	    List<String> splits = new List<String>();
        if (text == null) {
            return splits;
        }
        
        for (Integer start = 0; start < text.length(); start += size) {
            splits.add(text.substring(start, Math.min(text.length(), start + size)));
        }
        
    	return splits;
    }
    
    global virtual Exception createTestException() {
        try {
            Integer value = 100 / 0;
            return null;
        } catch (Exception e) {
            return e;
        }
    }
    
    global virtual String[] getCallingClassAndMethod() {
        return getClassAndMethod(createTestException(), 3);
    }

    global virtual String[] getClassAndMethod(Exception e) {
        return getClassAndMethod(e, 0);
    }
    
    global virtual String[] getClassAndMethod(Exception e, Integer lineNum) {
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
            }
            
            return resp;
        } catch (Exception e1) {
            System.debug('Excpetion while getting the class and method name from Exeption ' + getStackTrace(e1));
            return UnknownClassAndMethod;
        }
    }
}