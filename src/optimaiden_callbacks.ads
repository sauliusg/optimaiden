with AWS.Response;
with AWS.Status;

package  Optimaiden_Callbacks is

   function HW_CB (Request : AWS.Status.Data) return AWS.Response.Data;
   
end Optimaiden_Callbacks;
