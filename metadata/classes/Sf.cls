global class Sf {
    global static Settings settings {get {
        if (settings == null) {
            settings = new Settings();
        }
        return settings;
    }private set;}

    global static Assert assert {get {
        if (assert == null) {
            assert =  new Assert();
        }
        return assert;
    }private set;}

    global static Utils utils {get {
        if (utils == null) {
            utils = new Utils();
        }
        return utils;
    }private set;}

    global static AppLogger appLogger {get {
        if (appLogger == null) {
            appLogger =  new AppLogger();
        }
        return appLogger;
    }private set;}

    global static AppLogBuilder newAppLog() {
        return newAppLog(null, null);
    }

    global static AppLogBuilder newAppLog(String module, String action) {
        return new AppLogBuilder().module(module).action(action);
    }
}