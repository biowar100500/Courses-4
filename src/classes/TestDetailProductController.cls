@isTest
private class TestDetailProductController {
    @isTest static void TestGetProduct() {
        Product_Table__c p2 = new Product_Table__c(Name='testproduct2',Product_Description__c ='22222222');
        insert p2;
        PageReference pageRef = Page.DetailProduct;
        Test.setCurrentPage(pageRef);
        pageRef.getParameters().put('id',p2.Id);
        List<Product_Table__c> product = new List<Product_Table__c>{p2};
            DetailProductController test = new DetailProductController();
        List<Product_Table__c> result = new List<Product_Table__c>{test.getProduct()};
            System.assertEquals(product, result);
        
    }       
}