with Util.Streams.Texts;
with Util.Serialize.IO.JSON;
with AWS.MIME; use AWS.MIME;

with Structure_To_JSON; use Structure_To_JSON;

package body Optimaiden_Structure_Handler is
   
   overriding
   function Dispatch
     (
      Handler : Optimaiden_Structure_Handler_Type;
      Request : AWS.Status.Data
     ) return AWS.Response.Data is
      Output : aliased Util.Streams.Texts.Print_Stream;
      Stream : Util.Serialize.IO.JSON.Output_Stream;
   begin
      Output.Initialize (Size => 10000);
      Stream.Initialize (Output => Output'Unchecked_Access);
      
      Write (Stream, CIF_File_Name);

      return AWS.Response.Build
        (
         AWS.MIME.Application_JSON,
         Util.Streams.Texts.To_String (Output)
        );
   end Dispatch;

   overriding function Clone (Element : Optimaiden_Structure_Handler_Type)
                             return Optimaiden_Structure_Handler_Type is
   begin
      return Element;
   end Clone;
   
end Optimaiden_Structure_Handler;
