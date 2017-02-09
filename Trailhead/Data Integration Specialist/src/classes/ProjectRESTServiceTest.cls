@isTest
private class ProjectRESTServiceTest {
	
	@testSetup static void setup() {
		// Create an opportunity
		
		Account testAccount = new Account();
		 testAccount.Name='Test Account' ;
		 insert testAccount;
		
		Opportunity testOpportunity = new Opportunity(
	            StageName = 'Yet to begin',
	            CloseDate = Date.newInstance(2018,12,31) ,
	            Account = testAccount,
	            Name = 'Test Opportunity Triggers' 
	            
	        );
	        insert testOpportunity;
		
		//Create an Project with a ProjectRef to be updated
	        
	    Project__c p = new Project__c(
	    		Name = 'Test Project',
	    		Opportunity__c = testOpportunity.Id,
	    		ProjectRef__c = 'ProjectRefUniqueCode',
	    		Status__c = 'Billable',
	    		Billable_Amount__c = 10,
	    		End_Date__c = Date.newInstance(2018,12,31),
	    		Start_Date__c = Date.newInstance(2017,12,31)
	    );
	    insert p;
	}

	static testMethod void testDoPost() {
		
		Test.StartTest();
		
		List<Opportunity> lstOps = [Select Id, name from Opportunity limit 1];
		Opportunity o = new Opportunity();
		if (lstOps.size() > 0){
			o = lstOps[0]; 
		}
		
		RestRequest req = new RestRequest(); 
		RestResponse res = new RestResponse();
		
		// Test First Insert: 
		req.requestURI = 'https://na35.salesforce.com/services/apexrest/project';  
		req.httpMethod = 'POST';
		
	    //req.addParameter('ProjectRef','ProjectRef2ndCode');
	    //req.addParameter('ProjectName','Project Name 02');
	    //req.addParameter('OpportunityId',o.Id);
	    //req.addParameter('StartDate',date.today().format());
	    //req.addParameter('EndDate','2099-01-01');
	    //req.addParameter('Amount',1);
	    //req.addParameter('Status','Billable');
	    
	    //req.addParameter('password','T3st789');
		
		RestContext.request = req;
		RestContext.response = res;
		
		//insert
		String results = 
				ProjectRESTService.postProjectData(	'ProjectRef2ndCode',
													'Project Name 02',
													o.Id,
													Date.newInstance(2018,12,31),
													Date.newInstance(2018,12,31),
													10,
													'Billable');
		System.assertEquals('OK', results);
		
		// update: 
		results = 
				ProjectRESTService.postProjectData(	'ProjectRef2ndCode',
													'Project Name 01',
													o.Id,
													Date.newInstance(2018,12,31),
													Date.newInstance(2018,12,31),
													100,
													'Billable');
		System.assertEquals('OK', results);
		
		Test.StopTest();

	}
}