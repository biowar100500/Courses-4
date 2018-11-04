trigger ProductWithWarehouse on Product_Table__c (before insert) {
    if(Trigger.isInsert && Trigger.isBefore) {
        TriggerHandler.ProductAutoWarehouse(Trigger.new);
    }
}