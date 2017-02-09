//ProjectCalloutServiceTest

@isTest(SeeAllData=true)
private class ProjectCalloutServiceTest {
  //Implement mock callout tests here
  public static testMethod void testSuccess(){
      Account acc = new Account(Name='Test Account');
      insert acc;
      Opportunity opp = new Opportunity(Name='Test Opportunity',
                        AccountId=acc.id, CloseDate=System.Today(),
                        Amount=12480.00,
                        Type='New Project',
                        StageNAme='Qualification');
      insert opp;
      
      ServiceTokens__c s = ServiceTokens__c.getValues('ProjectServiceToken');
      
      List<Id> oppts = new List<Id>{opp.id};
      
      System.debug('[ATTDEV] Value of oppts: ' + oppts); 
      
      Test.startTest();
      
      // Set mock callout class 
      Test.setMock(HttpCalloutMock.class, new ProjectCalloutServiceMock());
            
      // This causes a fake response to be sent
      // from the class that implements HttpCalloutMock.
      ProjectCalloutService.postOpportunityToPMS(oppts);
      
      Test.stopTest();
      opp.StageName='Closed Won';
      update opp;
      
  }
  public static testMethod void testFailure(){
      Account acc = new Account(Name='Test Account');
      insert acc;
      Opportunity opp = new Opportunity(Name='Test Opportunity',
                        AccountId=acc.id, CloseDate=System.Today(),
                        Amount=12480.00,
                        Type='New Project',
                        StageNAme='Qualification');
      insert opp;
      
      List<Id> oppts = new List<Id>{opp.id}; 
      
      System.debug('[ATTDEV] Value of oppts: ' + oppts); 
      
      Test.startTest();
      
      // Set mock callout class 
      Test.setMock(HttpCalloutMock.class, new ProjectCalloutServiceMockFailure());
            
      // This causes a fake response to be sent
      // from the class that implements HttpCalloutMock. 
      ProjectCalloutService.postOpportunityToPMS(oppts);
      
      Test.stopTest();
      opp.StageName='Closed Won';
      update opp;
  }
}