with AWS.Dispatchers;
with AWS.Status;
with AWS.Response;

package Optimaiden_Structure_Handler is

   type Optimaiden_Structure_Handler_Type is new AWS.Dispatchers.Handler
     with null record;

   overriding
   function Dispatch
     (
      Handler : Optimaiden_Structure_Handler_Type;
      Request : AWS.Status.Data
     ) return AWS.Response.Data;

private

   overriding function Clone (Element : Optimaiden_Structure_Handler_Type)
                             return Optimaiden_Structure_Handler_Type;

end Optimaiden_Structure_Handler;
