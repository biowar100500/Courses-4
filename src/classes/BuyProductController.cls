public class BuyProductController {
    public Contact contact {get;set;}
    public Integer UnitCount {get;set;}
    public Decimal TotalAmount {get;set;}
    public Product_Table__c product;
    public BuyProductController() {
        contact = new Contact();
        product = new Product_Table__c();
        UnitCount = 1;
    } 
    
    public Product_Table__c getProduct() {
        product = [SELECT Id, Name, Unit_Price__c, Units_Available__c FROM Product_Table__c
                   WHERE Id = :ApexPages.currentPage().getParameters().get('Id')];
        TotalAmount = product.Unit_Price__c;
        return product;
    }
    public PageReference ColculateTotalAmount() {     
        String UnitCountStr = ApexPages.currentPage().getParameters().get('UnitCountParam');
        if(UnitCountStr!='') {
            UnitCount = Integer.valueOf(UnitCountStr);
        }
        else {
            TotalAmount = NULL;
            UnitCount = 0;
            return NULL;
        }
        if(UnitCount > 0) {
            TotalAmount = UnitCount * product.Unit_Price__c;
        }
        else {
            TotalAmount = NULL;
            UnitCount = 0;
        }
        return NULL;  
        
    }
    public void Buy() {
        if(UnitCount > 0) {           
            
            if((product.Units_Available__c - UnitCount) >= 0 ) {
                List<Contact> contactSearch = new List<Contact>();
                contactSearch = [SELECT Id, FirstName, LastName FROM Contact
                                 WHERE Email = :contact.Email];
                if(contactSearch.size() > 0) {
                    contactSearch[0].FirstName = contact.FirstName;
                    contactSearch[0].LastName = contact.LastName;
                    update contactSearch[0];
                }
                else {
                    contactSearch.add(contact);
                    insert contactSearch;
                }
                Order_Table__c order = new Order_Table__c();
                order.Product__c = product.Id;
                order.Units__c = UnitCount;
                order.Order_Amount__c = TotalAmount;
                order.Contact__c = contactSearch[0].Id;
                insert order;
                product.Units_Available__c = product.Units_Available__c - UnitCount;
                update product;
                ApexPages.addmessage(new ApexPages.Message(ApexPages.severity.CONFIRM , 'Order was created.'));
            }    
            else {
                ApexPages.addmessage(new ApexPages.Message(ApexPages.severity.ERROR , 'Not so many products available.'));
                
            }
        }
        else {
            ApexPages.addmessage(new ApexPages.Message(ApexPages.severity.ERROR , 'Invalid Unit Count.'));
        }   
    }
}