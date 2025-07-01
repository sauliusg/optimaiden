with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;
with Ada.Strings;           use Ada.Strings;
with Ada.Strings.Fixed;     use Ada.Strings.Fixed;

with Util.Streams.Texts;
with Util.Serialize.IO.JSON;
with AWS.MIME; use AWS.MIME;

with Structure_To_JSON; use Structure_To_JSON;

package body Optimaiden_Record_Handler is
   
   overriding
   function Dispatch
     (
      Handler : Optimaiden_Record_Handler_Type;
      Request : AWS.Status.Data
     ) return AWS.Response.Data is
      Output : aliased Util.Streams.Texts.Print_Stream;
      Stream : Util.Serialize.IO.JSON.Output_Stream;
      
      -- e.g.: "/structures/1000000"
      URL : constant String := AWS.Status.URI (Request);
      Slash_Idx : constant Integer := Index (URL, "/", Going => Backward);
      COD_ID : constant String := URL (Slash_Idx + 1 .. URL'Last);
      
      COD_Base : constant String := "/home/saulius/struct/cod/cif";
      D1 : constant String := COD_ID (COD_ID'First .. COD_ID'First);
      D2 : constant String := COD_ID (COD_ID'First + 1 .. COD_ID'First + 2);
      D3 : constant String := COD_ID (COD_ID'First + 3 .. COD_ID'First + 4);
      
      CIF_File_Name : constant Unbounded_String :=
        To_Unbounded_String (COD_Base & "/"& D1 & "/" & D2 & "/" & D3 & "/" & 
                               COD_ID & ".cif");
      
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

   overriding function Clone (Element : Optimaiden_Record_Handler_Type)
                             return Optimaiden_Record_Handler_Type is
   begin
      return Element;
   end Clone;
   
end Optimaiden_Record_Handler;
