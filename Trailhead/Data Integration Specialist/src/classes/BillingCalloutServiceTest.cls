@isTest(SeeAllData=true)
private class BillingCalloutServiceTest {
	
	static testMethod void testCallout() {
		
		Test.startTest();
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
	    		Status__c = 'Running',
	    		Billable_Amount__c = 10,
	    		End_Date__c = Date.newInstance(2018,12,31),
	    		Start_Date__c = Date.newInstance(2017,12,31)
	    );
	    insert p;
		
	    p.Status__c = 'Billable';
	    
	    // This causes a fake response to be generated
        Test.setMock(WebServiceMock.class, new BillingCalloutServiceMock());
	    
	    update p; 
	    
	 // This causes a fake response to be generated
        Test.setMock(WebServiceMock.class, new BillingCalloutServiceMockFailure());
	    
        p.Status__c = 'Billable';
        update p;
        
	    Test.stopTest();
		
	}
	
	
}