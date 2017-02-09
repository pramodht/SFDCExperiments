trigger ProjectTrigger on Project__c (after update) {
    //Call the Billing Service callout logic here
	// This is an after update trigger, but you can use the same structure for other trigger events.
	// Remember: One trigger per object.
	
	Map<Id, Project__c> projectsToEvaluate = new Map<Id, Project__c>();
	
	// Round wants to use its Salesforce org to notify Square Peg when a project is ready to bill. Your task is 
	// to trigger an outbound SOAP call anytime the project Status in their Salesforce org is set to Billable. 
	// This then triggers Square Peg’s legacy billing system to create a new invoice and bill the customer.
	
	if(Trigger.isAfter && Trigger.isUpdate){
        for(Project__c project : Trigger.new){
        	
        	Project__c oldProject = Trigger.oldMap.get(project.ID);
            if((project.Status__c == 'Billable') && (oldProject.Status__c != 'Billable')){
            	//projectsToEvaluate.put(project.Id,project);
            	BillingCalloutService.callBillingService(project.Id, project.ProjectRef__c, project.Billable_Amount__c); 
            }
        }       
    }
    // Simple! With the collection of Projects in a Map, we can invoke the method from the handler class:
	//BillingCalloutService.prepareBillingService(projectsToEvaluate);
	//BillingCalloutService.callBillingService(p.Id, p.ProjectRef__c, p.Billable_Amount__c);
	 
}