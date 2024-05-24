with AWS.MIME; use AWS.MIME;

package body Optimaiden_Uri_Handler is

   overriding
   function Dispatch
     (
      Handler : Optimaiden_Info_Handler_Type;
      Request : AWS.Status.Data
     ) return AWS.Response.Data is
   begin
      return AWS.Response.Build (AWS.MIME.Text_Plain, "info will go here");
   end Dispatch;

   overriding function Clone (Element : Optimaiden_Info_Handler_Type)
                             return Optimaiden_Info_Handler_Type is
   begin
      return Element;
   end Clone;

   overriding
   function Dispatch
     (
      Handler : Optimaiden_Structure_Handler_Type;
      Request : AWS.Status.Data
     ) return AWS.Response.Data is
   begin
      return AWS.Response.Build (AWS.MIME.Text_Plain, "structures will go here");
   end Dispatch;

   overriding function Clone (Element : Optimaiden_Structure_Handler_Type)
                             return Optimaiden_Structure_Handler_Type is
   begin
      return Element;
   end Clone;

end Optimaiden_Uri_Handler;
