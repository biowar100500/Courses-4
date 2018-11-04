public class TriggerHandler {
    public static void ProductAutoWarehouse(List<Product_Table__c> NewProdList) {
        
        List<Warehouse__c> WarList = new List<Warehouse__c>();
        String queryStr = 'SELECT Id, Name, Period_Start__c, Period_End__c FROM Warehouse__c WHERE ';
        for (Product_Table__c p: NewProdList) {
            if(p.Added_Date__c == NULL) {
                p.Added_Date__c = Date.today();
            }
            queryStr += '(Period_Start__c <= '+ DateTime.newInstance(p.Added_Date__c, Time.newInstance(0, 0, 0, 0)).format('yyyy-MM-dd') + 
                ' AND Period_End__c >= ' + DateTime.newInstance(p.Added_Date__c, Time.newInstance(0, 0, 0, 0)).format('yyyy-MM-dd') + ') OR ';      
        }
        queryStr = queryStr.removeEnd(' OR ');
        WarList = Database.query(queryStr);
        for (Product_Table__c p: NewProdList) {
            for (Warehouse__c w: WarList) {
                if(w.Period_Start__c <= p.Added_Date__c && w.Period_End__c >= p.Added_Date__c && p.Warehouse__c == NULL) {
                    p.Warehouse__c = w.Id;
                } 
            }
        }
        List<Product_Table__c> ProdNewWar = new List<Product_Table__c>();
        for(Product_Table__c p: NewProdList) {        
            if(p.Warehouse__c == NULL) {
                ProdNewWar.add(p);          
            }
        }
        List<Warehouse__c> WarResult = new List<Warehouse__c>();
        Org_Configuration__c myCS = Org_Configuration__c.getValues('PeriodForWarehouse');
        for(Product_Table__c p: ProdNewWar) {
            Warehouse__c war = new Warehouse__c(Name = 'Warehouse '+ DateTime.newInstance(p.Added_Date__c, Time.newInstance(0, 0, 0, 0)).format('yyyy-MM-dd') + 
                                                ' ' + DateTime.newInstance(p.Added_Date__c.addDays(Integer.valueOf(myCS.Period_Term__c)), Time.newInstance(0, 0, 0, 0)).format('yyyy-MM-dd'), 
                                                Period_Start__c = p.Added_Date__c,
                                                Period_End__c = p.Added_Date__c.addDays(Integer.valueOf(myCS.Period_Term__c)));
            WarResult.add(war);    
        }
        if(WarResult.size() > 0) {
            insert WarResult;
        }
        for(Integer i = 0;i<ProdNewWar.size();i++) {
            ProdNewWar[i].Warehouse__c = WarResult[i].Id;
        }
    }
}