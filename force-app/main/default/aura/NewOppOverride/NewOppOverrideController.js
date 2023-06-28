({
    handleSuccess : function(component, event, helper) {
        component.find('notifLib').showToast({
            "variant": "success",
            "title": "Record Created",
            "message": "Record ID: " + event.getParam("id")
        });
    },
    
    doInit : function(component, event, helper) {
        component.find("OppName").reset();
        component.find("StageName").reset();
        component.find("CloseDate").reset();
        component.set("v.recordId", event.getParam("id"));
    }, 
    
    handleLoad: function (component, event, helper) {
        var now = new Date(); 
        var text = now.getFullYear().toString() + "-" +  now.getMonth().toString() + "-" + now.getDay().toString() + " " +  now.getHours().toString() + ":" + now.getMinutes().toString() + ":" +  now.getSeconds().toString();

        var nameFieldValue = component.find("OppName");
        nameFieldValue.reset();
        nameFieldValue.set("v.value", text);
    }
})