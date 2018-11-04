@isTest
private class TestTriggerProdWithWar {
    @isTest static void TestInsertProdWithWar() {
        Warehouse__c war = new Warehouse__c(Name = 'WarTest', 
                                            Period_Start__c = date.newinstance(2018, 11, 01),
                                            Period_End__c = date.newinstance(2018, 11, 20));
        insert war;
        Product_Table__c p = new Product_Table__c(Name = 'TestProduct1');
        insert p;
        Product_Table__c result = [SELECT Id, Name, Warehouse__c, Added_Date__c FROM Product_Table__c WHERE Id =:p.Id];
        System.assertEquals(war.Id, result.Warehouse__c);
        System.assertEquals(Date.today(), result.Added_Date__c);
    }
    @isTest static void TestInsertProdNewWar() {
        Product_Table__c p = new Product_Table__c(Name = 'TestProduct2', Added_Date__c = Date.newInstance(2018, 11, 01));
        Org_Configuration__c PeriodWare = new Org_Configuration__c(Name = 'PeriodForWarehouse',Period_Term__c = 30);
        insert PeriodWare;
        insert p;
        Product_Table__c result = [SELECT Id, Name, Warehouse__c, Added_Date__c FROM Product_Table__c WHERE Id =:p.Id];
        Warehouse__c ResultWar = [SELECT Id, Name, Period_Start__c,Period_End__c FROM Warehouse__c WHERE Id =:result.Warehouse__c];
        System.assertEquals(ResultWar.Id, result.Warehouse__c);
        Warehouse__c ExpectedWar = new Warehouse__c(Name = 'Warehouse 2018-11-01 2018-12-01', 
                                            Period_Start__c = date.newinstance(2018, 11, 01),
                                            Period_End__c = date.newinstance(2018, 12, 01),
                                            Id = result.Warehouse__c);
        System.assertEquals(ExpectedWar, ResultWar);
    }
    @isTest static void TestInsertProdBothWar() {
        List<Warehouse__c> ExpectedWarList = new List<Warehouse__c>();
        Warehouse__c war = new Warehouse__c(Name = 'WarTest', 
                                            Period_Start__c = date.newinstance(2018, 11, 01),
                                            Period_End__c = date.newinstance(2018, 11, 20));
        insert war;
        ExpectedWarList.add(war);
        Warehouse__c ExpectedWar = new Warehouse__c(Name = 'Warehouse 2018-12-01 2018-12-31', 
                                            Period_Start__c = date.newinstance(2018, 12, 01),
                                            Period_End__c = date.newinstance(2018, 12, 31));
        ExpectedWarList.add(ExpectedWar);
        Product_Table__c p1 = new Product_Table__c(Name = 'TestProduct1');
        Product_Table__c p2 = new Product_Table__c(Name = 'TestProduct2', Added_Date__c = Date.newInstance(2018, 12, 01));
        List<Product_Table__c> ProdList = new List<Product_Table__c>{p1,p2};
        Org_Configuration__c PeriodWare = new Org_Configuration__c(Name = 'PeriodForWarehouse',Period_Term__c = 30);
        insert PeriodWare;
        insert ProdList;
        List<Product_Table__c> ProdResultList = [SELECT Id, Name, Warehouse__c, Added_Date__c FROM Product_Table__c ];
        List<Warehouse__c> ResultWarList = [SELECT Id, Name, Period_Start__c,Period_End__c FROM Warehouse__c ];
        ExpectedWarList[1].Id = ResultWarList[1].Id;
        System.assertEquals(ExpectedWarList, ResultWarList);
        ProdList[0].Warehouse__c = war.Id;
        ProdList[1].Warehouse__c = ResultWarList[1].Id;
        ProdList[0].Added_Date__c = Date.today();
        System.assertEquals(ProdList, ProdResultList);
    }
}