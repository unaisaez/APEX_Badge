public with sharing class OppTriggerHandler implements TriggerHandler {
        private boolean triggerIsExecuting;
        private integer triggerSize;
        public OppTriggerHelper helper;
        public OppTriggerHandler(boolean triggerIsExecuting, integer triggerSize) {
            this.triggerIsExecuting = triggerIsExecuting;
            this.triggerSize = triggerSize;
            this.helper = new OppTriggerHelper();
        }
        public void beforeInsert(List<Opportunity> newOpportunitys) {
            // helper.doTask1();
            // helper.doTask2();
        }
        public void beforeUpdate(List<Opportunity> oldOpportunitys, List<Opportunity> newOpportunitys, Map<ID, SObject> oldOpportunityMap, Map<ID, SObject> newOpportunityMap) {
            // helper.doTask3();
            // helper.doTask4();
        }
        public void beforeDelete(List<Opportunity> oldOpportunitys, Map<ID, SObject> oldOpportunityMap) {
            // helper.doTask5();
            // helper.doTask1();
        }
        public void afterInsert(List<Opportunity> newOpportunitys, Map<ID, SObject> newOpportunityMap) {
            // helper.doTask2();
            // helper.doTask3();
        }
        public void afterUpdate(List<Opportunity> oldOpportunitys, List<Opportunity> newOpportunitys, Map<ID, SObject> oldOpportunityMap, Map<ID, SObject> newOpportunityMap) {
            // helper.doTask4();
            // helper.doTask5();
        }
        public void afterDelete(List<Opportunity> oldOpportunitys, Map<ID, SObject> oldOpportunityMap) {
            // helper.doTask3();
            // helper.doTask1();
        }
        public void afterUndelete(List<Opportunity> newOpportunitys, Map<ID, SObject> newOpportunityMap) {
            // helper.doTask4();
            // helper.doTask2();
        }
    
}