public with sharing class ProcessConfigurations {
    @AuraEnabled(cacheable=true)
    public static List<ProcessConfiguration__mdt> getConfigs(String objectDes){
        try {
            return [SELECT RelatedObject__c, Object__c, Field__c FROM ProcessConfiguration__mdt WHERE RelatedObject__c = :objectDes];
            
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled(cacheable=true)
    public static sObject createRecord (String parentID, String objectType){
        try {
            
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
        return null;
    } 

    @AuraEnabled(cacheable=true)
    public static List<String> getFieldList (String objectType){
        SObjectType contactType = Schema.getGlobalDescribe().get(objectType);
        Map<String,Schema.SObjectField> mfields = contactType.getDescribe().fields.getMap();

        List<String> sObjectDetailsList = new List<String>();
        for(String s : mfields.keySet()){
            sObjectDetailsList.add(String.valueOf(mfields.get(s)));
        }
        return sObjectDetailsList;
    } 

}