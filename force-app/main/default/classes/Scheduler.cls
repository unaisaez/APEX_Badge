public with sharing class Scheduler {

    public Scheduler() {
    }

    public static void scheduleBatch (Integer inMin){

        QuoteGeneratorBatch qGB = new QuoteGeneratorBatch();

        String cronID = System.scheduleBatch(qGB, 'Quote upload', inMin);
        CronTrigger ct = [SELECT Id, TimesTriggered, NextFireTime
                        FROM CronTrigger WHERE Id = :cronID];

        // TimesTriggered should be 0 because the job hasn't started yet.
        System.assertEquals(0, ct.TimesTriggered);
        System.debug('Next fire time: ' + ct.NextFireTime); 
    }

    public static void executeBatch (){

        QuoteGeneratorBatch qGB = new QuoteGeneratorBatch();

        ID batchprocessid = Database.executeBatch(qGB);
        AsyncApexJob aaj = [SELECT Id, Status, JobItemsProcessed, TotalJobItems, NumberOfErrors FROM AsyncApexJob WHERE ID =: batchprocessid ];

    }
    
}