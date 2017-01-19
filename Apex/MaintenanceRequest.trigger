trigger MaintenanceRequest on Case (after update) {

	// This is an after update trigger, but you can use the same structure for other trigger events.
	// Remember: One trigger per object. 
	
	//Create a Map to store the Maintenance Requests to evaluate:
    Map<Id, Case> casesToEvaluate = new Map<Id, Case>();
    
    if(Trigger.isAfter && Trigger.isUpdate){
        for(Case maintenance : Trigger.new){
        	// Check if this Maintenance Type and Status follow the requirements:
            if((maintenance.Type.contains('Repair') || maintenance.Type.contains('Routine Maintenance')) && maintenance.Status == 'Closed'){
                casesToEvaluate.put(maintenance.Id,maintenance);
            }
        }       
    }
    // Simple! With the collection of Cases in a Map, we can invoke the method from the handler class:
    MaintenanceRequestHelper.updateWorkOrders(casesToEvaluate);
}