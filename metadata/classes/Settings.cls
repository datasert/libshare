global class Settings {
	
    private static final Integer SINGLE_VALUE_MAX_LENGTH = 255;
    private static final Integer MAX_KEY_LENGTH = 38;
    private static final Integer MAX_SPLIT_KEYS = 99;
    private static final Integer MAX_MULTI_PART_KEY_LENGTH = 34;
    private static final Integer MAX_TOTAL_VALUE_LENGTH = (MAX_SPLIT_KEYS + 1) * SINGLE_VALUE_MAX_LENGTH;
    
    //Public constructor so it can only be created by Sf.cls
    public Settings() {
        //default
    }
    
 	global void setString(String key, String value) {
        
        System.debug('Setting setting ' + key +'=' + value); 

        if (String.isBlank(key)) {
            throw new SettingsException('Settings key cannot be blank');
        }

  		key = key.trim();
        value = value == null ? '' : value.trim();

        Settings__c baseSetting = Settings__c.getValues(key);
		Decimal maxValueLength = Math.min(MAX_TOTAL_VALUE_LENGTH, baseSetting != null ? baseSetting.Length__c : Math.max(255, value.length()));
		boolean multiPartKey = maxValueLength > SINGLE_VALUE_MAX_LENGTH;
        
        System.debug('maxValueLength=' + maxValueLength);
        System.debug('multiPartKey=' + multiPartKey);
        System.debug('baseSetting=' + baseSetting);
        
        validateKey(key, value, multiPartKey);
        validateValue(value, multiPartKey);
        
        if (multiPartKey) {
            setMultiPartString(key, value, baseSetting, maxValueLength);
        } else {
            if (baseSetting == null) {
                baseSetting = new Settings__c();
                baseSetting.name = key;
                
                System.debug('Setting max length to ' + maxValueLength);
                baseSetting.Length__c = maxValueLength;
            }

            baseSetting.Value__c = value;
            upsert baseSetting;
        }
    }

    private void setMultiPartString(String key, String value, Settings__c baseSetting, Decimal maxValueLength) {
        List<Settings__c> upserts = new List<Settings__c>();
        List<Settings__c> deletes = new List<Settings__c>();
    	Integer numOfSplitKeys = Integer.valueOf(Math.ceil(maxValueLength / SINGLE_VALUE_MAX_LENGTH)) - 1;
        List<String> values = splitValue(value, SINGLE_VALUE_MAX_LENGTH);
        
        for (Integer i = 0; i <= numOfSplitKeys; i++) {
            String splitKey = getSplitKey(key, i);
            Settings__c setting = Settings__c.getValues(splitKey);
            
            if (i == 0 && values.isEmpty()) {
                setting.Value__c = null;
                upserts.add(setting);

            } else if (i >= values.size()) {
				//We need to remove this setting as value doesn't need this key. However if setting
				//is already null (doesn't exist) then we don't need do anything
				//However, we do not delete the base key setting as it consists of 
                if (setting != null) {
                    deletes.add(setting);
                }
            } else {
                //If setting is null, we need to create setting and set value.
                if (setting == null) {
                    setting = new Settings__c();
                    setting.name = splitKey;
                    setting.Length__c = maxValueLength;
                    
                    //This is split key so we will copy some values from base setting
                    if (i > 0 && baseSetting != null) {
                        setting.Env_Specific__c = baseSetting.Env_Specific__c;
                    }
                }
                
                setting.Value__c = values.get(i);
                upserts.add(setting);
            }
        }
	
        if (!deletes.isEmpty()) {
            delete deletes;
        }

        if (!upserts.isEmpty()) {
            upsert upserts;
        }
    }
    
    private void validateKey(String key, String value, boolean multiPartKey) {
        if (String.isBlank(key)) {
            throw new SettingsException('Settings key cannot be blank');
        }
        
        if (key.contains('__')) {
            throw new SettingsException('Key cannot contain two consecutive underscores');
        }
		
        if (multiPartKey) {
            if (key.length() > MAX_MULTI_PART_KEY_LENGTH) {
                throw new SettingsException('Settings with length more than ' + SINGLE_VALUE_MAX_LENGTH 
                                            + ' bytes are extended length keys and it cannot be more than ' 
                                            + MAX_MULTI_PART_KEY_LENGTH + ' bytes.');
            }
        } else {
            if (key.length() > MAX_KEY_LENGTH) {
                throw new SettingsException('Settings key cannot be more than ' + MAX_KEY_LENGTH + ' bytes');
            }
        }
    }
    
    private void validateValue(String value, boolean multiPartKey) {
        if (multiPartKey) {
            if (value.length() > MAX_TOTAL_VALUE_LENGTH) {
                throw new SettingsException('Maximum value length cannot be more than ' + MAX_TOTAL_VALUE_LENGTH + ' bytes');
            }
        } else {
            if (value.length() > SINGLE_VALUE_MAX_LENGTH) {
                throw new SettingsException('Maximum value length cannot be more than ' + SINGLE_VALUE_MAX_LENGTH + ' bytes');
            }
        }
    }
    
    private List<String> splitValue(String value, Integer maxLength) {
        List<String> values = new List<String>();
        if (String.isBlank(value)) {
            return values;
        }
        
        value = value.trim();
        while(value.length() > 0) {
            if (value.length() <= maxLength) {
                values.add(value);
                break;
            }
            
            values.add(value.substring(0, maxLength));
            value = value.substring(maxLength);
        }
        
        return values;
    }
	
	@TestVisible    
    private String getSplitKey(String key, Integer index) {
        return index == 0? key : key + '__' + index;
    }

    global String getString(String key, String defaultValue) {
        System.debug('Getting setting for key=' + key); 

        if (String.isBlank(key)) {
            throw new SettingsException('Settings key cannot be blank');
        }

  		key = key.trim();

        Settings__c baseSetting = Settings__c.getValues(key);
        if (baseSetting == null) {
        	System.debug('Setting is does not exist for key ' + key + ' so returning default ' + defaultValue);
            return defaultValue;
        }
        
		Decimal maxValueLength = Math.min(MAX_TOTAL_VALUE_LENGTH, baseSetting.Length__c == null ? 255 : baseSetting.Length__c);
		boolean multiPartKey = maxValueLength > SINGLE_VALUE_MAX_LENGTH;
        
        System.debug('maxValueLength=' + maxValueLength);
        System.debug('multiPartKey=' + multiPartKey);
        System.debug('baseSetting=' + baseSetting);
        
        String value = '';
        if (multiPartKey) {
	    	Integer numOfSplitKeys = Integer.valueOf(Math.ceil(maxValueLength / SINGLE_VALUE_MAX_LENGTH)) - 1;
            
            for (Integer i = 0; i <= numOfSplitKeys; i++) {
                String splitKey = getSplitKey(key, i);
                Settings__c setting = Settings__c.getValues(splitKey);
                if (setting == null) {
                    break;
                }
                
                if (String.isNotBlank(setting.Value__c)) {
                    value += setting.Value__c.trim();
                }
            }
        } else {
            value = baseSetting.Value__c == null ? '' : baseSetting.Value__c;
        }
		
        value = value.trim();
        
        if (String.isBlank(value)) {
        	System.debug('Setting is null/blank for key ' + key + ' so returning default ' + defaultValue);
            return defaultValue;
        }
        
        System.debug('Returning the Setting ' + key + '=' + value);        
        return value;
    }

    global String getString(String key) {
        String value = getString(key, null);
        if (value == null) {
            throw new SettingsException('String setting is null for key "' + key + '"');
        }

        return value;
    }

    global void setInteger(String key, Integer value) {
        setString(key, value == null ? null : String.valueOf(value));
    }

    global Integer getInteger(String key) {
        Integer value = getInteger(key, null);
        if (value == null) {
            throw new SettingsException('Integer setting is null for key "' + key + '"');
        }
        
        return value;
    }

    global Integer getInteger(String key, Integer defaultValue) {
        String stringValue = getString(key, null);
        Integer value = defaultValue;
        
        if (String.isNotBlank(stringValue)) {
            value = Integer.valueOf(stringValue);
        }
        
        System.debug('Returning the Integer setting for ' + key + ' as ' + value);
        return value;
    }
    
    global void setDecimal(String key, Decimal value) {
        setString(key, value==null?null:String.valueOf(value));
    }

    global Decimal getDecimal(String key) {
        Decimal value = getDecimal(key, null);
        if (value == null) {
            throw new SettingsException('Decimal setting is null for key "' + key + '"');
        }
        
        return value;
    }

    global Decimal getDecimal(String key, Decimal defaultValue) {
        String stringValue = getString(key, null);
        Decimal value = defaultValue;
        
        if (String.isNotBlank(stringValue)) {
            value = Decimal.valueOf(stringValue);
        }
        
        System.debug('Returning the Decimal setting for ' + key + ' as ' + value);
        return value;
    }

    global void setBoolean(String key, Boolean value) {
        setString(key, value==null?null:String.valueOf(value));
    }
    
    global Boolean getBoolean(String key) {
        Boolean value = getBoolean(key, null);
        if (value == null) {
            throw new SettingsException('Boolean setting is null for key "' + key + '"');
        }
        
        return value;
    }

    global Boolean getBoolean(String key, Boolean defaultValue) {
        String stringValue = getString(key, null);
        
        Boolean value = defaultValue;
        
        if (String.isNotBlank(stringValue)) {
            value = Boolean.valueOf(stringValue);
        }
        
        System.debug('Returning the Boolean setting for ' + key + ' as ' + value);
        return value;
    }
    
    global void setDate(String key, Date value) {
        setString(key, value==null?null:String.valueOf(value));
    }

    global Date getDate(String key) {
        Date value = getDate(key, null);
        if (value == null) {
            throw new SettingsException('Date setting is null for key "' + key + '"');
        }
        
        return value;
    }

    global Date getDate(String key, Date defaultValue) {
        String stringValue = getString(key, null);
        
        Date value = defaultValue;
        
        if (String.isNotBlank(stringValue)) {
            value = Date.valueOf(stringValue);
        }
        
        System.debug('Returning the Date setting for ' + key + ' as ' + value);
        return value;
    }

    global void setDateTime(String key, DateTime value) {
        setString(key, value==null?null:value.formatGmt('yyyy-MM-dd\'T\'HH:mm:ss\'Z\''));
    }

    global DateTime getDateTime(String key) {
        DateTime value = getDateTime(key, null);
        if (value == null) {
            throw new SettingsException('DateTime setting is null for key "' + key + '"');
        }
        
        return value;
    }

    global DateTime getDateTime(String key, DateTime defaultValue) {
        String stringValue = getString(key, null);
        
        DateTime value = defaultValue;
        
        if (String.isNotBlank(stringValue)) {
            value = (DateTime)json.deserialize('"' + stringValue + '"', DateTime.class);
        }
        
        System.debug('Returning the DateTime setting for ' + key + ' as ' + value);
        return value;
    }
    
    global void setMap(String key, Map<String, String> value) {
        String stringValue = null;
        if (value != null && !value.isEmpty()) {
            for (String entryKey : value.keyset()) {
                if (stringValue != null) {
                    stringValue += '|';
                } else {
                    stringValue = '';
                }
                
                String entryValue = value.get(entryKey);
                stringValue += entryKey.trim() + '=>' + (String.isBlank(entryValue) ? '' : entryValue.trim());
            }
		}
        
        setString(key, stringValue);

    }

    global Map<String, String> getMap(String key) {
        Map<String, String> value = getMap(key, null);
        if (value == null) {
            throw new SettingsException('Map setting is null for key "' + key + '"');
        }
        
        return value;
    }
    
    global Map<String, String> getMap(String key, Map<String, String> defaultValue) {
        Map<String, String> mapSetting = null;
        
        //Map settings should be stored as follows.
        //key1=>value1|key2=>value2|key3=>
        String stringValue = getString(key, null);
		
        try {
            if (String.isBlank(stringValue)) {
                mapSetting = defaultValue;
                
            } else {
                mapSetting = new Map<String, String>();
                
                String[] pairs = stringValue.split('\\|');
                for(String pair : pairs) {
                    String[] keyValues = pair.split('=>');
                    if (keyValues.size() > 1) {
	                    mapSetting.put(keyValues[0].trim(), keyValues[1].trim());
                    } else {
                        mapSetting.put(keyValues[0].trim(), null);
                   	}
                }
            }
        } catch (Exception e) {
            throw new SettingsException('Exception while getting the StringMap setting for key ' + key + ' and decoding its value ' + stringValue);
        }
        
        return mapSetting;
    }

    global void setList(String key, List<String> value) {
        String stringValue = null;
        if (value != null && !value.isEmpty()) {
            for (String item : value) {
                if (stringValue != null) {
                    stringValue += '|';
                } else {
                    stringValue = '';
                }
                stringValue += item.trim();
            }
		}
        
        setString(key, stringValue);
    }
    
    global List<String> getList(String key) {
        List<String> value = getList(key, null);
        if (value == null) {
            throw new SettingsException('List setting is null for key "' + key + '"');
        }
        
        return value;
    }
    
    global List<String> getList(String key, List<String> defaultValue) {
        List<String> listSetting = null;
        
        //List settings should be stored as follows.
        //value1,value2,value3 etc
        String stringValue = getString(key, null);
		
        try {
            if (String.isBlank(stringValue)) {
                listSetting = defaultValue;
                
            } else {
                listSetting = new List<String>();
                
                String[] values = stringValue.split('\\|');
                for(String value : values) {
                    listSetting.add(value.trim());
                }
            }
        } catch (Exception e) {
            throw new SettingsException('Exception while getting the String List setting for key ' + key + ' and decoding its value ' + stringValue);
        }
        
        return listSetting;
    }
    
    global void setSet(String key, Set<String> value) {
        String stringValue = null;
        if (value != null && !value.isEmpty()) {
            for (String item : value) {
                if (stringValue != null) {
                    stringValue += '|';
                } else {
                    stringValue = '';
                }
                stringValue += item.trim();
            }
		}
        
        setString(key, stringValue);
    }
    
    global Set<String> getSet(String key) {
        Set<String> value = getSet(key, null);
        if (value == null) {
            throw new SettingsException('Set setting is null for key "' + key + '"');
        }
        
        return value;
    }
    
    global Set<String> getSet(String key, Set<String> defaultValue) {
        Set<String> setSetting = null;
        
        //List settings should be stored as follows.
        //value1,value2,value3 etc
        String stringValue = getString(key, null);
		
        try {
            if (String.isBlank(stringValue)) {
                setSetting = defaultValue;
                
            } else {
                setSetting = new Set<String>();
                
                String[] values = stringValue.split('\\|');
                for(String value : values) {
                    setSetting.add(value.trim());
                }
            }
        } catch (Exception e) {
            throw new SettingsException('Exception while getting the String Set setting for key ' + key + ' and decoding its value ' + stringValue);
        }
        
        return setSetting;
    }

    global void setJson(String key, Object value) {
        setString(key, value == null ? null : Json.serialize(value));
    }
    
    global Map<String, Object> getJson(String key) {
        Map<String, Object> value = getJson(key, (Map<String, Object>) null);
        if (value == null) {
            throw new SettingsException('Json setting is null for key "' + key + '"');
        }
        
        return value;
    }
    
    global Map<String, Object> getJson(String key, Map<String, Object> defaultValue) {
        String stringValue = getString(key, null);
        Map<String, Object> value = defaultValue;
        
        if (String.isNotBlank(stringValue)) {
            value = (Map<String, Object>) Json.deserializeUntyped(stringValue);
        }
        
        System.debug('Returning the Json setting for ' + key + ' as ' + value);
        return value;
    }
    
    global Object getJson(String key, System.Type cls) {
        Object value = getJson(key, cls, null);
        if (value == null) {
            throw new SettingsException('Json setting is null for key "' + key + '"');
        }
        
        return value;
    }
    
    global Object getJson(String key, System.Type cls, Object defaultValue) {
        String stringValue = getString(key, null);
        Object value = defaultValue;
        
        if (String.isNotBlank(stringValue)) {
            value = Json.deserialize(stringValue, cls);
        }
        
        System.debug('Returning the Json setting for ' + key + ' as ' + value);
        return value;
    }
    
    global void clearEnvSpecificValues() {
        
        List<Settings__c> settings = [select Value__c from Settings__c where Env_Specific__c = true];
        for (Settings__c setting : settings) {
			setting.Value__c = null;
        }
        
        update settings;
    }
	
    global void clearNullValues() {
        List<Settings__c> settings = [select Value__c from Settings__c];
        
        for (Settings__c setting : settings) {
            if (setting.Value__c == 'null') {
                setting.Value__c = null;
            }
        }
        
        update settings;        
    }    
}