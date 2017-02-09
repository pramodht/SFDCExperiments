global class ProjectCalloutService {
	
	@InvocableMethod
	public static void postOpportunityToPMS(List<Id> opIdList){
		
		List <Opportunity> opts = [SELECT ID,Name,Account.Name,CloseDate,Amount FROM Opportunity WHERE Id in :opIdList Limit 1];  
		Opportunity o = new Opportunity();
		
		String jsonInput = '';
		
		if (opts.size() > 0){ 
			
			o = opts[0];
			
			jsonInput = '{\n' +
				        ' "opportunityId" : "'+o.Id+'",\n'+
				        ' "opportunityName" : "'+o.Name+'",\n'+
				        ' "accountName" : "'+o.Account.Name+'",\n'+
				        ' "closeDate" : "'+String.ValueOf(o.CloseDate).mid(0,10)+'",\n'+   
				        ' "amount" : '+o.Amount.setScale(0)+'\n'+
				        '}';
			System.debug('[ATTDEV] Value of jsonInput1: ' + jsonInput); 
			
		}

		ID jobID = System.enqueueJob(new QueueablePMSCall(jsonInput));
            
		//QueueablePMSCall.doCallout(jsonInput);
    }
	
	global class QueueablePMSCall implements System.Queueable, Database.AllowsCallouts
    {
        string jsonInput;
		
		public QueueablePMSCall(string pJsonInput){			
    		this.jsonInput = pJsonInput;
        }

        public void execute(QueueableContext context)
        {                        
    		System.debug('[ATTDEV] Value of jsonInput: ' + this.jsonInput); 
			
			ServiceTokens__c s = ServiceTokens__c.getValues('ProjectServiceToken');
			
			HTTPRequest req = new HTTPRequest();
	        
			req.setEndPoint('callout:ProjectService');
			
	        req.setMethod('POST');
	        req.setHeader('token',s.Token__c);
	        
	        //System.debug('[ATTDEV] Value of s.Token__c: ' + s.Token__c);
	        req.setHeader('Content-Type', 'application/json;charset=UTF-8');

	        req.setBody(jsonInput);
	        
	        System.debug('[ATTDEV] Value of req: ' + req);
	        
	        HTTP h = new HTTP();
	        
	        HTTPResponse response = h.send(req);
	        
	        if (response.getStatusCode() != 201) {
	            System.debug('[ATTDEV] The status code returned was not expected: ' +
	                response.getStatusCode() + ' ' + response.getStatus());
	        } else {
	            System.debug('[ATTDEV] Value of response body: '+ response.getBody());
	        }

        }
        
    }
	
	
}