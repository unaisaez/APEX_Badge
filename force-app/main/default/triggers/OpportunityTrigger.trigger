trigger OpportunityTrigger on Opportunity (after insert, after update, before insert, before update) {
    OppTriggerHandler handler = new OppTriggerHandler(Trigger.isExecuting, Trigger.size);
    switch on Trigger.operationType {
        when BEFORE_INSERT {
            // handler.beforeInsert(Trigger.new);
        }
        when BEFORE_UPDATE {
            // handler.beforeUpdate(Trigger.old, Trigger.new, Trigger.oldMap, Trigger.newMap);
        }
        when BEFORE_DELETE {
            // handler.beforeDelete(Trigger.old, Trigger.oldMap);
        }
        when AFTER_INSERT {
            // handler.afterInsert(Trigger.new, Trigger.newMap);
        }
        when AFTER_UPDATE {
            // handler.afterUpdate(Trigger.old, Trigger.new, Trigger.oldMap, Trigger.newMap);
        }
        when AFTER_DELETE {
            // handler.afterDelete(Trigger.old, Trigger.oldMap);
        }
        when AFTER_UNDELETE {
            // handler.afterUndelete(Trigger.new, Trigger.newMap);
        }
    }

}