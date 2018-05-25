public class FlsUtils {
	
    public static DescribeSObjectResult describeSobject(String sobj) {
        Schema.DescribeSObjectResult[] dResult = Schema.describeSObjects(new List<String> {sobj});
        return dResult[0];
    }
    
    public static DescribeSObjectResult describeSobject(Sobject sobj) {
        return sobj.getSObjectType().getDescribe();
    }
    
    public static boolean isCreateable(Sobject sobj) {
        return describeSobject(sobj).isCreateable();
    }
	
    public static void ensureCreateable(Sobject sobj) {
        if (!isCreateable(sobj)) {
            throw new LibshareException('Sobject ' + sobj +' is not createable!');
        }
    }
    
    public static boolean isUpdateable(Sobject sobj) {
        return describeSobject(sobj).isUpdateable();
    }

    public static void ensureUpdateable(Sobject sobj) {
        if (!isUpdateable(sobj)) {
            throw new LibshareException('Sobject ' + sobj +' is not updateable!');
        }
    }

    public static boolean isDeletable(Sobject sobj) {
        return describeSobject(sobj).isDeletable();
    }

    public static void ensureDeletable(Sobject sobj) {
        if (!isDeletable(sobj)) {
            throw new LibshareException('Sobject ' + sobj +' is not deletable!');
        }
    }
}