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
}