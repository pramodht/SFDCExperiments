//ProjectCalloutServiceMockFailure
global class ProjectCalloutServiceMockFailure implements HttpcalloutMock{
   //Implement http mock callout failure here 
   //Implement http mock callout here
   global HttpResponse respond(Httprequest request){
       HttpResponse response = new Httpresponse();
       String resBody = '[Status=Created, StatusCode=501]';
       response.setBody(resBody);
       response.setStatusCode(501);
       return response;
   }
}