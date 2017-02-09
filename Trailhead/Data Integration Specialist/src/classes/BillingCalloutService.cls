public class BillingCalloutService {
    //Implement business and callout logic methods here
	
	
	@future (callout=true)
	public static void callBillingService(Id id, String ProjectRef, Decimal BillingAmount ){
		
		ServiceCredentials__c s = ServiceCredentials__c.getValues('BillingServiceCredential');
		
		System.debug('[ATTDEV] Value of s: ' + s); 
		
		BillingServiceProxy.project bspProject = new BillingServiceProxy.project();
		
		bspProject.username = s.Username__c;
		bspProject.password = s.Password__c;
		bspProject.projectRef = ProjectRef;
		bspProject.billAmount = BillingAmount;
		
		System.debug('[ATTDEV] Value of bspProject: ' + bspProject);
		
		BillingServiceProxy.billProjectRequest_element bsp_element = new BillingServiceProxy.billProjectRequest_element();
		bsp_element.project = bspProject;
		
		BillingServiceProxy.InvoicesPortSoap11 invoice = new BillingServiceProxy.InvoicesPortSoap11();
		
		String result = invoice.billProject(bsp_element.project);
		
		List<Project__c> lstProjects = [select id, name, Status__c from Project__c where Id =: id limit 1];
		if (lstProjects.size() > 0){
			Project__c p = lstProjects[0];
			
			p.Status__c = 'Billed';
			update p;
			
		}
		
	}
	
	
	
}