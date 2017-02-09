@RestResource(urlMapping='/project/*')
global with sharing class ProjectRESTService {
	
    //Implement service logic here
	
	@HttpPost
    global static String postProjectData(
    	String ProjectRef,
        String ProjectName, 
        String OpportunityId,
        Date StartDate,
        Date EndDate,
        Double Amount,
        String Status) {
		
		
		Savepoint sp = Database.setSavepoint();
		// Checks if the record already exists: 
		try{
			List<Project__c> projects = [select Billable_Amount__c, End_Date__c, Opportunity__c, ProjectRef__c, Start_Date__c, Status__c from Project__c where ProjectRef__c = :ProjectRef limit 1];
			
			Project__c p = new Project__c();

			if(projects.size() > 0){
				// updates the record
				p = projects[0];
				
				p.Billable_Amount__c = Amount;
				p.End_Date__c = EndDate;
				p.Start_Date__c = StartDate;
				//p.Opportunity__c = OpportunityId;
				p.Name = ProjectName;
				p.Status__c = Status;
						
				update p;		
			}else{
				
				p.ProjectRef__c = ProjectRef;
				p.Billable_Amount__c = Amount;
				p.End_Date__c = EndDate;
				p.Start_Date__c = StartDate;
				p.Opportunity__c = OpportunityId;
				p.Name = ProjectName;
				p.Status__c = Status;
				
				insert p;
			}
			
			//Udates the related Opportunity's Delivery/Installation Status to "In Progress"
			
			List<Opportunity> lstOpportunity = [Select id, Name, DeliveryInstallationStatus__c from Opportunity where Id =: OpportunityId limit 1];
			
			if(lstOpportunity.size() > 0){
				Opportunity o = lstOpportunity[0];
				
				o.DeliveryInstallationStatus__c = 'In progress';
				update o;
			}
			
			return 'OK'; // please consider using an static variable for this return message.
		}catch(Exception e){
			Database.rollback(sp);
			return 'Error: ' + e.getMessage();
		}
		
        
		
        
    }
}