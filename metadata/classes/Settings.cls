global class Settings {
	
    private static final Integer MAX_VALUE_LENGTH = 255;
    private static final Integer MAX_KEY_LENGTH = 38;
    private static final Integer MAX_SPLIT_KEYS = 99;
    private static final Integer MAX_MULTI_PART_KEY_LENGTH = 34;
    private static final Integer MAX_TOTAL_VALUE_LENGTH = (MAX_SPLIT_KEYS + 1) * MAX_VALUE_LENGTH;
    
    //Public constructor so it can only be created by Sf.cls
    public Settings() {
        //default
    }
    
 	global void setString(String key, String value) {
        logDebug('Setting string ' + key +'=' + value); 
    	
        validateKey(key, value);
  		key = key.trim();
		
        validateValue(value);
        value = value == null ? null : value.trim();
        
        List<Settings__c> upserts = new List<Settings__c>();
        List<Settings__c> deletes = new List<Settings__c>();

        List<String> values = splitValue(value, MAX_VALUE_LENGTH);
        Settings__c baseSetting = Settings__c.getValues(key);
        
        for (Integer i = 0; i <= MAX_SPLIT_KEYS; i++) {
            String splitKey = getSplitKey(key, i);
            Settings__c setting = Settings__c.getValues(splitKey);
            
            if (i == 0 && values.isEmpty()) {
                //Value is empty. If setting is not null, we will just set to null
                //If setting is null, we need to create setting and set value.
                if (setting == null) {
                    setting = new Settings__c();
                    setting.name = splitKey;
                }
                
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
    
    private void validateKey(String key, String value) {
        if (String.isBlank(key)) {
            throw new SettingsException('Settings key cannot be blank');
        }
        
        if (key.contains('__')) {
            throw new SettingsException('Key cannot contain two consecutive underscores');
        }
        
        if (String.isNotBlank(value) && value.trim().length() > MAX_VALUE_LENGTH) {
            if (key.length() > MAX_MULTI_PART_KEY_LENGTH) {
                throw new SettingsException('Settings key with value size more than ' + MAX_VALUE_LENGTH 
                                            + ' bytes cannot be more than ' + MAX_MULTI_PART_KEY_LENGTH + ' bytes. This is to support storing multi-part keys.');
            }
        } else {
            if (key.length() > MAX_KEY_LENGTH) {
                throw new SettingsException('Settings key cannot be more than ' + MAX_KEY_LENGTH + ' bytes');
            }
        }
    }
    
    private void validateValue(String value) {
        if (String.isNotBlank(value) && value.trim().length() > MAX_TOTAL_VALUE_LENGTH) {
            throw new SettingsException('Maximum value length cannot be more than ' + MAX_TOTAL_VALUE_LENGTH + ' bytes');
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
        String value = '';
        for (Integer i = 0; i <= MAX_SPLIT_KEYS; i++) {
            String splitKey = getSplitKey(key, i);
        	Settings__c setting = Settings__c.getValues(splitKey);
            if (setting == null) {
                break;
            }
            
            if (String.isNotBlank(setting.Value__c)) {
	            value += setting.Value__c.trim();
            }
        }
		
        value = value.trim();
        
        if (String.isBlank(value)) {
        	logDebug('Setting is null/blank for key ' + key + ' so returning default ' + defaultValue);
            return defaultValue;
        }
        
        logDebug('Returning the Setting ' + key + '=' + value);        
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
        
        logDebug('Returning the Integer setting for ' + key + ' as ' + value);
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
        
        logDebug('Returning the Decimal setting for ' + key + ' as ' + value);
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
        
        logDebug('Returning the Boolean setting for ' + key + ' as ' + value);
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
        
        logDebug('Returning the Date setting for ' + key + ' as ' + value);
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
        
        logDebug('Returning the DateTime setting for ' + key + ' as ' + value);
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
        
        logDebug('Returning the Json setting for ' + key + ' as ' + value);
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
        
        logDebug('Returning the Json setting for ' + key + ' as ' + value);
        return value;
    }
    
    global void clearEnvSpecificSettings() {
        
        List<Settings__c> settings = [select Value__c from Settings__c where Env_Specific__c = true];
        for (Settings__c setting : settings) {
			setting.Value__c = null;
        }
        
        update settings;
    }
	
    global void clearNullStrings() {
        List<Settings__c> settings = [select Value__c from Settings__c];
        
        for (Settings__c setting : settings) {
            if (setting.Value__c == 'null') {
                setting.Value__c = null;
            }
        }
        
        update settings;        
    }    
    
    private void logDebug(String msg) {
        System.debug(msg);
    }
}