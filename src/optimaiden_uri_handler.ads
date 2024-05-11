with AWS.Dispatchers;
with AWS.Status;
with AWS.Response;

package Optimaiden_Uri_Handler is
   
   type Optimaiden_Uri_Handler_Type is new AWS.Dispatchers.Handler 
     with null record;
   
   overriding
   function Dispatch
     (
      Handler : in Optimaiden_Uri_Handler_Type;
      Request : in AWS.Status.Data
     ) return AWS.Response.Data;
   
private
   overriding function Clone (Element : in Optimaiden_Uri_Handler_Type)
                             return Optimaiden_Uri_Handler_Type;
end;
