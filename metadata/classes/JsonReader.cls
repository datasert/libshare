global virtual class JsonReader {
    private static Utils u = new Utils();
	private static Logger logger = new Logger();
    
    private Object jsonObj = null;
    private List<String> withs = new List<String>();
        
    global JsonReader(String jsonString) {
        this(Json.deserializeUntyped(jsonString));
    }

	global JsonReader(Object jsonObj) {
        this.jsonObj = jsonObj;
    }

    global JsonReader getReader(String key) {
    	return new JsonReader(getValue(key));
    }
    
    global Boolean isArray() {
        return (jsonObj instanceof List<Object>);
    }

    global String toPrettyJson() {
		return toJson(true);
    }

    global String toJson() {
		return toJson(false);
    }

    global String toJson(Boolean pretty) {
        if (jsonObj == null) {
	        jsonObj = new Map<String, Object>();
        }
        
        if (pretty) {
			return Json.serializePretty(jsonObj);
        } else {
			return Json.serialize(jsonObj);
        }
    }
	
    @TestVisible
    private JsonReader with(Integer arrayIndex) {
        return with('[' + arrayIndex + ']');
    }
    
    @TestVisible
    private JsonReader newWith(Integer arrayIndex) {
        return newWith('[' + arrayIndex + ']');
    }

    global JsonReader newWith(String with) {
		withs.clear();
        return with(with);
    }
    
    global JsonReader with(String with) {
        withs.add(with);
        return this;
    }
    
    global JsonReader endWith() {
        if (!withs.isEmpty()) {
			withs.remove(withs.size() - 1);
        }

        return this;
    }
    
    global JsonReader clearWith() {
        withs.clear();
        return this;
    }
    
    @TestVisible
    private String getWithKey(String key) {
        if (!withs.isEmpty()) {
            key = u.join('.', withs) + '.' + key;
        }
        
        return key;
    }
    
    global Object getObject() {
        return jsonObj;
    }

    global List<Object> getList(String key) {
        if (String.isBlank(key)) {
            return (List<Object>) jsonObj;
        }
        return (List<Object>) getValue(key);
    }

    global List<Object> getStringList(String key) {
        List<Object> values = getList(key);
        List<String> stringValues = null;
        if (values != null) {
            stringValues = new List<String>();
            for (Object obj : values) {
                stringValues.add(u.toString(obj));
            }
        }
        
        return stringValues;
    }

    global Map<String, Object> getMap(String key) {
        return (Map<String, Object>) getValue(key);
    }

    global Object getValue(String key) {
        Object containingObj = getContainingObject(key);
        if (containingObj == null) {
            return null;
        }
        
        return getSegmentValue(containingObj, getFinalSegment(key));
    }
    
    global String getString(String key) {
		return getString(key, null);
    }
    global String getString(String key, String defaultValue) {
        Object value = getValue(key);
        if (value == null) {
            value = defaultValue;
        }
        
        return u.toString(value);
    }

    global Integer getInteger(String key) {
        return getInteger(key, null);
    }
    global Integer getInteger(String key, Integer defaultValue) {
        Object value = getValue(key);
        if (value == null) {
            return defaultValue;
        }
        
        return Integer.valueOf(value);
    }
    
    global DateTime getDateTime(String key) {
        return getDateTime(key, null);
    }
    global DateTime getDateTime(String key, Datetime defaultValue) {
        String value = getString(key);
        if (String.isBlank(value)) {
            return defaultValue;
        }
        
        return u.parseIsoDateTime(value);
    }

    global Date getDate(String key) {
        return getDate(key, null);
    }
    global Date getDate(String key, Date defaultValue) {
        String value = getString(key);
        if (String.isBlank(value)) {
            return defaultValue;
        }
        
        return u.parseIsoDate(value);
    }

    global Boolean getBoolean(String key) {
    	return getBoolean(key, false);
    }
    global Boolean getBoolean(String key, Boolean defaultValue) {
        Object value = getValue(key);
        if (value == null) {
            return defaultValue;
        }
        
        return Boolean.valueOf(value);
    }

    global Decimal getDecimal(String key) {
    	return getDecimal(key, null);
    }
    global Decimal getDecimal(String key, Decimal defaultValue) {
        Object value = getValue(key);
        if (value == null) {
            return defaultValue;
        }
        
        return Double.valueOf(value);
    }

    global Boolean hasKey(String key) {
        Object parentObj =  getContainingObject(key);
        if (parentObj == null) {
            return false;
        }
        
        String field = getFinalSegment(key);
        if (isArray(field)) {
            if (parentObj instanceof List<Object>) {
                List<Object> listObj = (List<Object>) parentObj;
                Integer arrayIndex = Integer.valueOf(field.substringBetween('[', ']'));
                if (arrayIndex < listObj.size()) {
                    return true;
                }
            }
        } else {
            if (parentObj instanceof Map<String, Object>) {
                Map<String, Object> mapObj = (Map<String, Object>) parentObj;
                return mapObj.containsKey(field);
            }
        }
        
        return false;
    }
    
    private String getFinalSegment(String key) {
        key = getWithKey(key);
        String[] segments = key.split('\\.');
        return segments.get(segments.size() - 1);
    }
    
    /**
     * Returns the object which contains the final field which we will need to return the value for.
     * 
     * For ex., if key is foo.bar.bob.alice, this will return the object the key "foo.bar.bob" points to. Then calling
     * method can look for key "alice" in returned object.
     *
     * For If it is an array, the index is considered part of the value. For ex., if you have foo.bar[1].bob then
     * returned object points to "foo.bar[1]". If key is "foo.bar[1]" then return object points to "foo"
     */
    private Object getContainingObject(String key) {
        key = getWithKey(key);
        
        Object currentObj = jsonObj;
        
        String[] segments = key.split('\\.');

        for (Integer segmentIndex = 0; segmentIndex < (segments.size() - 1); segmentIndex++) {
            if (currentObj == null) {
                return null;
            }

            currentObj = getSegmentValue(currentObj, segments.get(segmentIndex));
        }
        
        return currentObj;
    }

    private Boolean isArray(String key) {
        return key.indexOf('[') >= 0;
    }

    global Object getSegmentValue(Object currentObj, String keySegment) {
        if (isArray(keySegment)) {
            return getArraySegmentValue(currentObj, keySegment);
        } else {
            if (!(currentObj instanceof Map<String, Object>)) {
                return null;
            }
            return ((Map<String, Object>)currentObj).get(keySegment);
        }
    }

    /**
     * Parses the key segment containing array index, and returns the appropriate value from passed in array object.
     * 
     * If passed in object is not an array, then returns null.
     */
    private Object getArraySegmentValue(Object arrayContainingObj, String arrayKeySegment) {

        String arrayField = arrayKeySegment.substringBefore('[');
        Integer arrayIndex = Integer.valueOf(arrayKeySegment.substringBetween('[', ']'));

        //First we need to find the array object and then we will return the value with required index.
        List<Object> arrayObj = null;

        if (String.isBlank(arrayField)) {
            //This is the case of when we have root array without any field prefix. For ex., 
            //"[]"

            if (!(arrayContainingObj instanceof List<Object>)) {
                //If containing object is not actually an array, then we have a mismatch. So return null.
                return null;
            }
            arrayObj = (List<Object>) arrayContainingObj;

        } else {
            if (!(arrayContainingObj instanceof Map<String, Object>)) {
                return null;
            }
            Object objTemp = ((Map<String, Object>)arrayContainingObj).get(arrayField);
            if (!(objTemp instanceof List<Object>)) {
                return null;
            }

            arrayObj = (List<Object>) objTemp;
        }
        
        if (arrayObj == null) {
            return null;
        }

        if (arrayIndex >= arrayObj.size()) {
            return null;
        }

        return arrayObj.get(arrayIndex);
    }
}