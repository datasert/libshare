global class JsonMapper {
    private static Utils u = new Utils();
	private static Logger logger = new Logger();

    private Object jsonObj;
    private Boolean ignoreNulls = false;
    private List<String> withs = new List<String>();
    
    global JsonMapper() {
        this((Object) null);
    }
    
    global JsonMapper(Object jsonObj) {
		this.jsonObj = jsonObj;
    }

    global JsonMapper(String jsonString) {
		this(Json.deserializeUntyped(jsonString));
    }

    global JsonMapper ignoreNulls(boolean ignoreNulls) {
        this.ignoreNulls = ignoreNulls;
        return this;
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
    
    global String toPrettyJson() {
		return toJson(true);
    }

    global JsonMapper newWith(String with) {
		withs.clear();
        return with(with);
    }
    
    global JsonMapper with(String with) {
        withs.add(with);
        return this;
    }
    
    global JsonMapper endWith() {
        if (!withs.isEmpty()) {
			withs.remove(withs.size() - 1);
        }

        return this;
    }
    
    global JsonMapper clearWith() {
        withs.clear();
        return this;
    }
    
    global JsonMapper setIfNotBlank(String key, String value) {
        if (String.isNotBlank(value)) {
			return set(key, value);
        }
        
        return this;
    }
    
    global JsonMapper setIfNotNull(String key, Object value) {
        if (value != null) {
	        set(key, value);
        }
        
        return this;
    }
    
    global JsonMapper set(String key, Object value) {
        //System.debug('Writing ' + key + '=' + value);
        
        if (ignoreNulls && value == null) {
            return this;
        }
        
        if (value instanceof DateTime || value instanceof Date) {
            value = u.toString(value);
        }
        
        try {
            Object currentObj = null;
            
			key = getWithKey(key);
            
            //We need to get the object corresponding to the key. If object not there, we will need to create it.
            String[] segments = key.split('\\.');
            
            //We will process all segments except the last as last one is the actual field within the 
            //object.
            for (Integer segmentIndex = 0; segmentIndex < segments.size(); segmentIndex++) {
                String segment = segments.get(segmentIndex);
                if (segment.indexOf('[') < 0) {
                    
                    //This is not any array so we should look for an object.
                    //If current object is null, then we will use the root object, jsonObj. If jsonObject is null, then we will create one.
                    if (currentObj == null) {
                        if (jsonObj == null) {
                            jsonObj = new Map<String, Object>();
                        }
                        
                        currentObj = jsonObj;
                    }
                    
                    Map<String, Object> mapObj = (Map<String, Object>) currentObj;
                    
                    if (segmentIndex == segments.size() - 1) {
                        ((Map<String, Object>) currentObj).put(segment, value);
                       } else {
                        if (mapObj.get(segment) == null) {
                            mapObj.put(segment, new Map<String, Object>());
                        }
                        
                        currentObj = mapObj.get(segment);
                    }
                } else {
                    
                    //Segment is an array. So we will have to look for particular item within the object.
                    String arrayKey = segment.substringBefore('[');
                    Integer arrayIndex = Integer.valueOf(segment.substringBetween('[', ']'));
                    
                    if (String.isBlank(arrayKey)) {
                        
                        //If array key is null, then we are dealing with just an array.
                        if (currentObj == null) {
                            if (jsonObj == null) {
                                jsonObj = new List<Object>();
                            }
                        
                            currentObj = jsonObj;
                        }
                        
                        //Get the array within the current object by the segment key.
                        List<Object> listObj = (List<Object>) currentObj;
                        
                        //If array object is smaller than index, then grow till index
                        for (Integer i = listObj.size(); i < arrayIndex + 1; i++) {
                            listObj.add(null);                    
                        }
                        
                        //If it is the last segment, then we are looking at setting primitive value at array index. If not,
                        //then we are looking at setting object as array index.
                        if (segmentIndex == segments.size() - 1) {
                            listObj.set(arrayIndex, value);
                        } else {
                            if (listObj.get(arrayIndex) == null) {
                                listObj.set(arrayIndex, new Map<String, Object>());
                            }
                            
                            currentObj = listObj.get(arrayIndex);
                        }
                        
                    } else {
                        //If current object is null, then we will use the root object, jsonObj. If jsonObject is null, then we will create one.
                        if (currentObj == null) {
                            if (jsonObj == null) {
                                jsonObj = new Map<String, Object>();
                            }
                            
                            currentObj = jsonObj;
                        }
                        
                        //Get the array within the current object by the segment key.
                        Map<String, Object> mapObj = (Map<String, Object>) currentObj;
                        
                        List<Object> listObj = (List<Object>) mapObj.get(arrayKey);
                        if (listObj == null) {
                            listObj = new List<Object>();
                            mapObj.put(arrayKey, listObj);
                        }
                        
                        //If array object is smaller than index, then grow till index
                        for (Integer i = listObj.size(); i < arrayIndex + 1; i++) {
                            listObj.add(null);                    
                        }
                        
                        if (segmentIndex == segments.size() - 1) {
                            listObj.set(arrayIndex, value);
                            
                        } else {
                            if (listObj.get(arrayIndex) == null) {
                                listObj.set(arrayIndex, new Map<String, Object>());
                            }
                            
                            currentObj = listObj.get(arrayIndex);
                        }
                    }
                }
            }

            return this;
        } catch (Exception e) {
            throw new LibshareException('Exception while writing \'' + key + '=' + value + '\' to Json object. Error [' + e.getMessage() + ']', e);
        }
    }
    
    /**
     * Adds the given link to current document in HAL spec. See this link for more info
     * https://phlyrestfully.readthedocs.io/en/latest/halprimer.html
     */
    global JsonMapper setLink(String name, String url) {
 	    set('_links.' + name + '.href', url);
        return this;
    }

    /**
     * Adds the self link to current document in HAL spec. See this link for more info
     * https://phlyrestfully.readthedocs.io/en/latest/halprimer.html
     */
    global JsonMapper setSelfLink(String url) {
 	    set('_links.self.href', url);
        return this;
    }
    
    @TestVisible
    private String getWithKey(String key) {
        if (!withs.isEmpty()) {
            key = u.join('.', withs) + '.' + key;
        }
        
        return key;
    }

    global JsonMapper getMapper(String key) {
    	return new JsonMapper(get(key));
    }
    
    global Boolean isArray() {
        return (jsonObj instanceof List<Object>);
    }

    @TestVisible
    private JsonMapper with(Integer arrayIndex) {
        return with('[' + arrayIndex + ']');
    }
    
    @TestVisible
    private JsonMapper newWith(Integer arrayIndex) {
        return newWith('[' + arrayIndex + ']');
    }

    global Object getObject() {
        return jsonObj;
    }

    global List<Object> getList(String key) {
        if (String.isBlank(key)) {
            return (List<Object>) jsonObj;
        }
        return (List<Object>) get(key);
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
        return (Map<String, Object>) get(key);
    }

    global Object get(String key) {
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
        Object value = get(key);
        if (value == null) {
            value = defaultValue;
        }
        
        return u.toString(value);
    }

    global Integer getInteger(String key) {
        return getInteger(key, null);
    }
    global Integer getInteger(String key, Integer defaultValue) {
        Object value = get(key);
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
        Object value = get(key);
        if (value == null) {
            return defaultValue;
        }
        
        return Boolean.valueOf(value);
    }

    global Decimal getDecimal(String key) {
    	return getDecimal(key, null);
    }
    global Decimal getDecimal(String key, Decimal defaultValue) {
        Object value = get(key);
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