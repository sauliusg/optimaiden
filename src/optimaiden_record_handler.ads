with AWS.Dispatchers;
with AWS.Status;
with AWS.Response;

package Optimaiden_Record_Handler is
   
   type Optimaiden_Record_Handler_Type is new AWS.Dispatchers.Handler
     with null record;

   overriding
   function Dispatch
     (
      Handler : Optimaiden_Record_Handler_Type;
      Request : AWS.Status.Data
     ) return AWS.Response.Data;

private

   overriding function Clone (Element : Optimaiden_Record_Handler_Type)
                             return Optimaiden_Record_Handler_Type;

end Optimaiden_Record_Handler;
