public with sharing class ClientPlanController {
    public Id recordId {get;set;}
    public Account acc {get;set;}
    public List<Account> accList{get;set;}
    public List<Contact> ctcList{get;set;}
    public List<Opportunity> oppList{get;set;}
    public List<Entitlement> entList{get;set;}
    public Decimal totalamount {get;set;}
    public PageReference pdfPage;
   
    public ClientPlanController (){
        
        totalamount = 0;
        pdfPage = ApexPages.currentpage();
        recordId = ApexPages.currentpage().getParameters().get('id');
        accList = [SELECT Id, Name, (select Id, Name from Account.contacts), (select Id, name, amount from Account.opportunities), (select Id, name from Account.entitlements) from Account where Id = :recordId];

        if (accList.isEmpty()){
            Client_Plan__c newId = [SELECT Account__c from Client_Plan__c where ID = :recordId LIMIT 1];
            accList = [SELECT Id, Name, (select Id, Name from Account.contacts), (select Id, name, amount from Account.opportunities), (select Id, name from Account.entitlements) from Account where Id = :newId.Account__c];
            recordId = newId.Account__c;
        }

        for(Account a: accList){
            acc = a;
            ctcList = a.contacts;
            oppList = a.opportunities;
            entList = a.entitlements;
            /* PROCESS CONTACT INFORMATION
            for (Contact C: a.contacts){
                i++;
            }*/
           
            for (Opportunity o: a.opportunities){
                totalamount = totalamount + o.amount ;
            }

             /* PROCESS ENTITLEMENT INFORMATION
            for (Entitlement e: a.entitlements){
                i++;
            }*/
        }
    }
    
    public PageReference savePDF() {
        
                 
         Blob pdfContent = ApexPages.currentpage().getContentAsPDF();
        
         ContentVersion cv = new ContentVersion();
         cv.VersionData = pdfContent;
         cv.Title = 'Client Plan' + Date.today();
         cv.PathOnClient = 'ClientPlan_' + Date.today() + '.pdf' ;
         insert cv;                
         cv = [SELECT Id, ContentDocumentId FROM ContentVersion WHERE Id = :cv.Id LIMIT 1];
             
         ContentDocumentLink cdl = new ContentDocumentLink();
         cdl.ContentDocumentId = cv.ContentDocumentId;
         cdl.ShareType = 'I';
         cdl.LinkedEntityId = acc.Id;
         insert cdl;

         PageReference acctPage = new ApexPages.StandardController(acc).view();
            acctPage.setRedirect(true);
            return acctPage;
 
         //return pdfPage;
       
      }
}