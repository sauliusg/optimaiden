with AWS.Response;
with AWS.Status;

package body Optimaiden_Callbacks is

   function HW_CB (Request : AWS.Status.Data) return AWS.Response.Data is
   begin
      return AWS.Response.Build ("text/html", "<p>Hello world !");
   end HW_CB;
   
end;
