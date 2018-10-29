public class ProductListController {
    public List<Product_Table__c> getProducts() {   
        List<Product_Table__c> results = Database.query(
            'SELECT Id, Name, Image_Url__c, Product_Description__c, Unit_Price__c ' +
            'FROM Product_Table__c '+'LIMIT 100');
        for(Product_Table__c CurDesc : results)
        {
            if(CurDesc.Product_Description__c != NULL && CurDesc.Product_Description__c.length() > 100)
            {
                CurDesc.Product_Description__c = CurDesc.Product_Description__c.SubString(0, 100) + '...';
            }
        }
        return results;
    }
}