//ProjectCalloutServiceMock

global class ProjectCalloutServiceMock implements HttpcalloutMock{
   //Implement http mock callout here
   global HttpResponse respond(Httprequest request){
       HttpResponse response = new Httpresponse();
       String resBody = '[Status=Created, StatusCode=201]';
       response.setHeader('Content-Type','application/json');
       response.setBody(resBody);
       response.setStatusCode(201);
       return response;
   }
}