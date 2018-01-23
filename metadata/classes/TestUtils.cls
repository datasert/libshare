global class TestUtils {
    public static final String Prop_CurrentDateTime = 'CurrentDateTime';
    public static final String Prop_CurrentDate = 'CurrentDate';
    public static final String Prop_HttpCalloutMock = 'HttpCalloutMock';
    
    /**
     * General parameters that can be referred in the code primarly
     * while running the test. This can be used to shield any random value
     */
    global static Map<String, Object> testParams = new Map<String, Object>();
	
    global static Object get(String param, Object defaultValue) {
        Object value = testParams.get(param);
        return value == null ? defaultValue : value;
    }
    
    global static Object get(String param) {
		return get(param, null);
    }

    global static void set(String param, Object value) {
		testParams.put(param, value);
    }

    global static void setCurrentDateTime(DateTime value) {
		testParams.put(Prop_CurrentDateTime, value);
    }

    global static DateTime getCurrentDateTime() {
		return (DateTime) testParams.get(Prop_CurrentDateTime);
    }

    global static void setCurrentDate(Date value) {
		testParams.put(Prop_CurrentDate, value);
    }

    global static Date getCurrentDate() {
		return (Date) testParams.get(Prop_CurrentDate);
    }

    global static void setHttpMock(HttpCalloutMock value) {
		testParams.put(Prop_HttpCalloutMock, value);
    }

    global static HttpCalloutMock getHttpMock() {
		return (HttpCalloutMock) testParams.get(Prop_HttpCalloutMock);
    }

    global static void clear(String param) {
		testParams.remove(param);
    }

    global static Boolean isTrue(String param) {
        return isTrue(testParams.get(param));
    }

    global static String getString(String param) {
        return getString(param, null);
    }
    
    global static String getString(String param, String defaultValue) {
        Object value = testParams.get(param);
        if (value == null) {
            return defaultValue;
        }
        
        String stringValue = String.valueOf(value);
        if (String.isBlank(stringValue)) {
            return defaultValue;
        }
        
        return stringValue.trim();
    }

    private static Boolean isTrue(Object obj) {
        if (obj == null) {
            return false;
            
        } else if (obj instanceof Boolean) {
            return (Boolean) obj;
            
        } else {
            return Boolean.valueOf(String.valueOf(obj));
        }
    }
}