@isTest
private class TestProductListController {
    @isTest static void TestGetProducts() {
        Product_Table__c p1 = new Product_Table__c(Name='testproduct1',Product_Description__c ='111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111');
        Product_Table__c p2 = new Product_Table__c(Name='testproduct2',Product_Description__c ='22222222');
        List<Product_Table__c> product = new List<Product_Table__c>{p1,p2};
            insert product;
        p1.Product_Description__c = p1.Product_Description__c.SubString(0, 100) + '...';
        ProductListController test = new ProductListController();
        List<Product_Table__c> result = test.getProducts();
        System.assertEquals(product, result);
    }
}