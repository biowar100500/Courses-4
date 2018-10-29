public class DetailProductController {
    public Product_Table__c getProduct() {
        return [SELECT Id, Name, Image_Url__c, Product_Description__c, Units_Available__c FROM Product_Table__c
                WHERE Id = :ApexPages.currentPage().getParameters().get('Id')];
    }
}