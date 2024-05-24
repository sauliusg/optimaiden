with AWS.Dispatchers;
with AWS.Status;
with AWS.Response;

package Optimaiden_Info_Handler is

   type Optimaiden_Info_Handler_Type is new AWS.Dispatchers.Handler
     with null record;

   overriding
   function Dispatch
     (
      Handler : Optimaiden_Info_Handler_Type;
      Request : AWS.Status.Data
     ) return AWS.Response.Data;

private

   overriding function Clone (Element : Optimaiden_Info_Handler_Type)
                             return Optimaiden_Info_Handler_Type;

end Optimaiden_Info_Handler;
