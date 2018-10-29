@isTest
private class TestBuyProductController { 
    @isTest static void TestOrderCreatedNewContact() {
        Product_Table__c p2 = new Product_Table__c(Name='testproduct2',Unit_Price__c = 10.00 ,Units_Available__c = 10);
        insert p2;
        PageReference pageRef = Page.BuyProduct;
        Test.setCurrentPage(pageRef);
        pageRef.getParameters().put('id',p2.Id);
        BuyProductController testContr = new BuyProductController();
        testContr.product = testContr.getProduct();
        System.assertEquals(p2, testContr.product);
        pageRef.getParameters().put('UnitCountParam','2');
        testContr.ColculateTotalAmount();
        System.assertEquals((p2.Unit_Price__c*2), testContr.TotalAmount);
        testContr.contact.LastName = 'Fedunich';
        testContr.contact.FirstName = 'Fedya';
        testContr.contact.Email = 'Fedunich@mail.ru';
        testContr.Buy();
        Order_Table__c resultorder = [SELECT Id, Name, Product__c, Units__c, Order_Amount__c, Contact__c FROM Order_Table__c
                                      WHERE Product__c = :p2.Id];
        Order_Table__c expectedorder = new Order_Table__c(Name = p2.Name + ' 20', Product__c = p2.Id, Units__c = 2, 
                                                          Order_Amount__c = (p2.Unit_Price__c*2),Contact__c = testContr.contact.Id, Id = resultorder.Id);
        System.assertEquals(expectedorder, resultorder);
        ApexPages.Message m = new ApexPages.Message(ApexPages.severity.CONFIRM , 'Order was created.');
        List<ApexPages.Message> expectedMsg = new List<ApexPages.Message>{m};
            System.assertEquals(expectedMsg, ApexPages.getMessages());       
    }
    @isTest static void TestOrderCreatedUpdateContact() {
        Product_Table__c p2 = new Product_Table__c(Name='testproduct2',Unit_Price__c = 10.00 ,Units_Available__c = 10);
        insert p2;
        PageReference pageRef = Page.BuyProduct;
        Test.setCurrentPage(pageRef);
        pageRef.getParameters().put('id',p2.Id);
        BuyProductController testContr = new BuyProductController();
        testContr.product = testContr.getProduct();
        System.assertEquals(p2, testContr.product);
        pageRef.getParameters().put('UnitCountParam','2');
        testContr.ColculateTotalAmount();
        System.assertEquals((p2.Unit_Price__c*2), testContr.TotalAmount);
        Contact updatecontact = new Contact(LastName = 'Sergeevski', Email = 'Fedunich@mail.ru');
        insert updatecontact;
        testContr.contact.LastName = 'Fedunich';
        testContr.contact.FirstName = 'Fedya';
        testContr.contact.Email = 'Fedunich@mail.ru';
        testContr.Buy();
        Order_Table__c resultorder = [SELECT Id, Name, Product__c, Units__c, Order_Amount__c, Contact__c FROM Order_Table__c
                                      WHERE Product__c = :p2.Id];
        Order_Table__c expectedorder = new Order_Table__c(Name = p2.Name + ' 20', Product__c = p2.Id, Units__c = 2, 
                                                          Order_Amount__c = (p2.Unit_Price__c*2),Contact__c = updatecontact.Id, Id = resultorder.Id);
        System.assertEquals(expectedorder, resultorder);
        ApexPages.Message m = new ApexPages.Message(ApexPages.severity.CONFIRM , 'Order was created.');
        List<ApexPages.Message> expectedMsg = new List<ApexPages.Message>{m};
            System.assertEquals(expectedMsg, ApexPages.getMessages()); 
    }
    @isTest static void TestErrorInvalidCount() {
        Product_Table__c p2 = new Product_Table__c(Name='testproduct2',Unit_Price__c = 10.00 ,Units_Available__c = 10);
        insert p2;
        PageReference pageRef = Page.BuyProduct;
        Test.setCurrentPage(pageRef);
        pageRef.getParameters().put('id',p2.Id);
        BuyProductController testContr = new BuyProductController();
        testContr.getProduct();
        // Unit Count NULL//
        pageRef.getParameters().put('UnitCountParam','');
        testContr.ColculateTotalAmount();
        System.assertEquals(NULL, testContr.TotalAmount);
        testContr.contact.LastName = 'Fedunich';
        testContr.contact.FirstName = 'Fedya';
        testContr.contact.Email = 'Fedunich@mail.ru';
        testContr.Buy();
        ApexPages.Message m = new ApexPages.Message(ApexPages.severity.ERROR , 'Invalid Unit Count.');
        List<ApexPages.Message> expectedMsg = new List<ApexPages.Message>{m};
            System.assertEquals(expectedMsg, ApexPages.getMessages());
        // Unit Count -2//
        pageRef.getParameters().put('UnitCountParam','-2');
        testContr.ColculateTotalAmount();
        System.assertEquals(NULL, testContr.TotalAmount);
        testContr.Buy();
        ApexPages.Message m2 = new ApexPages.Message(ApexPages.severity.ERROR , 'Invalid Unit Count.');
        List<ApexPages.Message> expectedMsg2 = new List<ApexPages.Message>{m2};
            System.assertEquals(expectedMsg2, ApexPages.getMessages());
    }
    @isTest static void TestErrorNotProduct() {
        Product_Table__c p2 = new Product_Table__c(Name='testproduct2',Unit_Price__c = 10.00 ,Units_Available__c = 10);
        insert p2;
        PageReference pageRef = Page.BuyProduct;
        Test.setCurrentPage(pageRef);
        pageRef.getParameters().put('id',p2.Id);
        BuyProductController testContr = new BuyProductController();
        testContr.getProduct();
        pageRef.getParameters().put('UnitCountParam','20');
        testContr.ColculateTotalAmount();
        System.assertEquals((p2.Unit_Price__c*20), testContr.TotalAmount);
        testContr.Buy();
        ApexPages.Message m = new ApexPages.Message(ApexPages.severity.ERROR , 'Not so many products available.');
        List<ApexPages.Message> expectedMsg = new List<ApexPages.Message>{m};
            System.assertEquals(expectedMsg, ApexPages.getMessages());
    }
}