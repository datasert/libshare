Overview
==
Libshare is a set of reusable modules inspired by years of developing Salesforce apps for enterprises. It is released as managed package so that you can use without having to worry about managing the code yourself in the org. However you are free to just use the code as is.

It is licensed under [Apache License 2.0](https://tldrlegal.com/license/apache-license-2.0-(apache-2.0)).

Install
==
Latest version: 1.1
* [Sandbox](https://test.salesforce.com/packaging/installPackage.apexp?p0=04t1N000001LzPk)
* [Production](https://test.salesforce.com/packaging/installPackage.apexp?p0=04t1N000001LzPk)

Modules
==

This package provides following modules.

* **Settings**: Reusable application settings store and easy to use API to interact with it
* **Fluent Asserts**: Fluent asserts inspired of Java worlds Assertj

Namespace
==
Libshare Salesforce package namespace is `lib`

Settings
==
We have seen that folks find clever use of things to suit their needs. Before Custom Settings/Metadata, many folks were using Custom Labels to store application settings. It was very inconvenient and to change something you had to deploy something again, which broke the primise of dynamic configuration.

With custom settings, Salesforce provided a "standard" way of managing application data. While it is powerful, people started abusing Custom Settings. Each developer end up creating one custom settings object to store one value for thier app, which is hard to maintain and manage.

This settings module is built on top of Custom Settings and tries to provide one place to store all application configuration. It provides an easy to use API to interact with settings.

Features
--
Here are some of the notable features of Settings module.

* Single consistent and reusable place to all application configuration
* Easy to use API to get/set settings
* Support for storing values longer than 255 bytes, upto 25,500 bytes
* Supports `string`, `integer`, `decimal`, `boolean`, `date`, `datetime`, `list`, `map`, `set` and `json`
* Supports specifying the default value for each settings in the application code.
* Supports identifying some settings as Environment specific and provides api to clear those values when Sandbox is refreshed

Storage
--
It creates a `lib__Settings__c` custom settings object with following fields and stores all configuration

|  Label | API | Type | Description |
|--------|-----|------|-------------|
| Name | Name | String | Standard name of Custom Settings. Settings key will be stored here |
| Type | Type__c | String | String indicating what type of value this setting stores. It should be one of `string`, `integer`, `decimal`, `boolean`, `date`, `datetime`, `list`, `map`, `set` and `json`. Optional and if blank, defaults to `string`  |
| Value | Value__c | String | Stores the actual value of the setting. Note all type of values are persisted as Strings and converted to apprpriate type during the retrieval |
|Length|Length__c|Integer|Indicates maximum length of value stored in this setting. Optional. If blank, defaults to 255. Can be upto 25,000. If length is more than 255, then multiple keys will be created with `{basekey}__{n}` where base key key application uses and n is multi part key number. For if you set a setting `AppClientId` with value length of 256 bytes, then two keys will created. One as `AppClientId` and `AppClientId__1`|
|Env Specific|Env_Specific__c|Boolean|If checked, indicates that this setting is specific this environment and should not be copied over to other environments. For ex., service urls, user ids or passwords. This helps to identify settings to be cleared when copied over from Prod to Sandbox. There is also an API that one can execute to clear all these type of settings. `lib.sf.settings.clearnEnvSpecificValues()`|

API
--
All settings apis are accessed via `lib.sf.settings` reference. This returns instance of [Settings.cls](/datasert/libshare/metadata/classes/Settings.cls).

This the only API that is exposed in the package. This class provides methods to get and set settings.

Usage
--
Here are general outline of three methods for each type of supported types.

```
//Returns the value for given Key. If Key is not defined or if value is empty, then it throws SettingsException
get{Type}({Key});

//Returns the value defined for Key. If Key is not defined or if value is empty, then returns the DefaultValue
get{Type}({Key}, {DefaultValue});

//Sets the Key to given value. If setting doesn't exist, then creates new and sets it.
set{Type}({Key}, {Value});
```

In above example, Type could be one of `String`, `Integer`, `Decimal`, `Date`, `DateTime`, `Boolean`, `Json`, `List`, `Map`, `Set`

Values Longer than 255 bytes
--
Settings modules supports setting and getting values longer than 255 bytes by splitting the value into segments of 255 bytes each and storing them in multiple keys. Each of these additional keys are named as `{BaseKey}__{nn}` where `BaseKey` is key specified by Users and `nn` is number from 1 till 99.

Limitations
--
Key maximum size is 38 bytes. If Key needs to support value more than 255 bytes, then Key maximum size 34 bytes.

Env Specific Settings
--
There are always some settings that are specific to each environment. 

An example from prior experience: One of the customers we worked with had stored payment system urls, credentials. When we refreshed sandbox, values copied over but forgot to update them and end up in posting non-production transactions to production payment system.

Set flag each of such settings in `Env_Specific__c` and call api `lib.sf.settings.clearnEnvSpecificValues()` when refreshed. You could also make this part of your refresh script so that it always get cleared when refreshed.

Examples
--

* `Integer maxValue = lib.sf.settings.getInteger('ProcessingMaxValue', 1000);`

    In this example, we init the maxValue from settings `ProcessingMaxValue`. If setting not defined, then it defaults to 1000.

    This pattern of "soft-coding" the settings helps avoid the Settings clutter and yet provides a means to override values in production if need arises.

* `List<String> states = lib.sf.settings.getList('States');`

    In this example we get the list of Strings from Setting `States`. The actual value would be stored as `California;Nevada` with `;` as the value separators. The settings code will split the values before converting to List.

Fluent Assertions
==
We feel that Salsforce is missing good support for good assertions. For example., to check something is not null, we need to call `System.assertNotEquals(null, someresult)`. While this works, but not very intuituve.

Fluent assertions tries to bring easy to use API to assertions in Salesforce.

Features
--
Here are some of the notable features of Fluent Assertions.

* Typed support for asserting privimites, objects and exceptions
* Chaniable assert methods so value being asserted can be tested for various conditions
* Use custom AssertException vs System default

API
--
All settings apis are accessed via `lib.sf.assert` reference. This returns instance of [Assert](/datasert/libshare/metadata/classes/Assert.cls).

This the only API that is exposed in the package and is starting point to access all other methods.

Apart from Typed assert classes, `lib.sf.assert` also has few apis to support general assertions as follows.

```
Assert fail();
Assert fail(String message);
Assert check(Boolean result);
check(Boolean result, String message);
Assert expectedException();
Assert expectedException(String msg);
expectedException(System.Type cls);
```

Usage
--
You typically call reference `lib.sf.assert.that(value)` and depending on the type of {value}, method returns one of [StringAssert](/datasert/libshare/metadata/classes/StringAssert.cls), [IntegerAssert](/datasert/libshare/metadata/classes/IntegerAssert.cls), [DecimalAssert](/datasert/libshare/metadata/classes/DecimalAssert.cls), [BooleanAssert](/datasert/libshare/metadata/classes/BooleanAssert.cls), [DateAssert](/datasert/libshare/metadata/classes/DateAssert.cls), [DateTimeAssert](/datasert/libshare/metadata/classes/DateTimeAssert.cls), [ObjectAssert](/datasert/libshare/metadata/classes/ObjectAssert.cls), or [ExceptionAssert](/datasert/libshare/metadata/classes/ExceptionAssert.cls).

Each of these typed assert classes supports various assert methods of two varients, one without custom message and one with custom message as follows.

```
StringAssert endsWith(String other);
StringAssert endsWith(String other, String msg);
```

Example
--
Here is an example of using String assert.

```
@IsTest
public class ExampleTest {
    static lib.assert assert = lib.sf.assert;

    testmethod public static void test_testValue() {
        String value = //get value from some method
        assert.that(value)
            .isNotNull()
            .contains('Customer')
            .endsWith('.');
    }

    testmethod public static void test_testValueWithCustomMessage() {
        String value = //get value from some method
        assert.that(value)
            .isNotNull('Cannot be null')
            .contains('Customer', 'Should contain Customer')
            .endsWith('.', 'Should end with a dot');
    }
}
```

Release Notes
==

Version 1.1
--
* Optimize settings for single value as that is mosed often used

Version 1.0
--
* Initial version of package with Settings and Fluent Assertions