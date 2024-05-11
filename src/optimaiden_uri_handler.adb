with AWS.MIME; use AWS.MIME;

package body Optimaiden_Uri_Handler is
   
   overriding
   function Dispatch
     (
      Handler : in Optimaiden_Uri_Handler_Type;
      Request : in AWS.Status.Data
     ) return AWS.Response.Data is
   begin
      return AWS.Response.Build (AWS.MIME.Text_Plain, "info will go here");
   end;
   
   overriding function Clone (Element : in Optimaiden_Uri_Handler_Type)
                             return Optimaiden_Uri_Handler_Type is
   begin
      return Element;
   end;
end;
