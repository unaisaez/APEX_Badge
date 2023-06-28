public class QuoteGeneratorBatch implements Database.Batchable<sObject> {
    
    public Database.QueryLocator start(Database.BatchableContext BC) {
       String query = 'SELECT ID, Name FROM Healthcare_Quote_Staging__c WHERE LastModifyDate > YESTERDAY';
       return Database.getQueryLocator(query);
    }

    public void execute(Database.BatchableContext BC, list<Healthcare_Quote_Staging__c> staging){

            //Preparing the list to insert QLIs - one for each OLI
            List<Quote> lstQ = new List<Quote>();
            List<QuoteLineItem> lstQLI = new List<QuoteLineItem>();

            //Fetching all the Staging LIs belonging to the staging quotes
            List<Healthcare_QuoteDetail_Staging__c> sLis =[select id, Name, Healthcare_Quote_Staging__c from Healthcare_QuoteDetail_Staging__c where Healthcare_Quote_Staging__c in :staging];
            
            //Preparing a Map of each Staging Quote and their corrresponding LineItems 
            Map<Id,List<Healthcare_QuoteDetail_Staging__c>> mapIdSli = new Map<Id,List<Healthcare_QuoteDetail_Staging__c>>();
            for (Healthcare_QuoteDetail_Staging__c sli : sLis) {
                if (mapIdSli.containsKey(sli.Healthcare_Quote_Staging__c)) {
                    mapIdSli.get(sli.Id).add(sli);
                } else {
                    List<Healthcare_QuoteDetail_Staging__c> lstSlis = new List<Healthcare_QuoteDetail_Staging__c>();
                    lstSlis.add(sli);
                    mapIdSli.put(sli.Healthcare_Quote_Staging__c, lstSlis);
                }
            }
            
            //Preparing the new quotes - one for each Healthcare_Quote_Staging__c            
            for (Healthcare_Quote_Staging__c oq : staging) {
                Quote q = new Quote();
                q.name = 'Quote-' + oq.name;
                //ExternalID from the staging table to track details
                //q.ExternalID = oq.Id;
                lstQ.add(q);
            }
            
            //Inserting the new quotes
            insert lstQ;

            //Prepare Line Items to 
            for (Quote q : lstQ) {
                List<Healthcare_QuoteDetail_Staging__c> lstOlis = mapIdSli.get(q.Id/*q.ExternalId*/);
                if (lstOlis != null) {
                    for (Healthcare_QuoteDetail_Staging__c oli : lstOlis) {
                        QuoteLineItem qli = new QuoteLineItem();
                        qli.quoteId = q.Id;
                        lstQLI.add(qli);
                    }
                }
            }
       
            //Inserting the new QLIs
            insert lstQLI;
        }

    public void finish(Database.BatchableContext BC){
        AsyncApexJob a = [SELECT Id, Status, NumberOfErrors, JobItemsProcessed, TotalJobItems, CreatedBy.Email FROM AsyncApexJob WHERE Id = :BC.getJobId()];
        // Send an email to the Apex job's submitter notifying of job completion.
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        String[] toAddresses = new String[] {a.CreatedBy.Email};
        mail.setToAddresses(toAddresses);
        mail.setSubject('Quote Calculation ' + a.Status);
        mail.setPlainTextBody
        ('The batch Apex job processed ' + a.TotalJobItems +
        ' batches with '+ a.NumberOfErrors + ' failures.');
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
    }

    
}