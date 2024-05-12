with AWS.Dispatchers;
with AWS.Status;
with AWS.Response;

package Optimaiden_Uri_Handler is

   type Optimaiden_Uri_Handler_Type is new AWS.Dispatchers.Handler
     with null record;

   overriding
   function Dispatch
     (
      Handler : Optimaiden_Uri_Handler_Type;
      Request : AWS.Status.Data
     ) return AWS.Response.Data;

private
   overriding function Clone (Element : Optimaiden_Uri_Handler_Type)
                             return Optimaiden_Uri_Handler_Type;
end Optimaiden_Uri_Handler;
