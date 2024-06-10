with AWS.MIME; use AWS.MIME;
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;
with Util.Streams.Texts;
with Util.Serialize.IO.JSON;
with Cif_Streaming_Parser; use Cif_Streaming_Parser;
with Cif_Datablock; use Cif_Datablock;

package body Optimaiden_Structure_Handler is
   
   CIF_File_Name : String := "tests/data/2000000.cif";
   
   procedure Write
     (
      Stream : out Util.Serialize.IO.JSON.Output_Stream;
      CIF_Datablock : Controlled_Datablock_Access
     ) is
   begin
      Stream.Start_Document;
      Stream.Start_Array ("data");
      
      Stream.Start_Entity ("");
      Stream.Start_Entity ("attributes");
      
      Stream.Write_Entity ("id", Get_Datablock_Name (CIF_Datablock));
      
      Stream.End_Entity ("attributes");
      Stream.Write_Entity ("type", "structures");
      Stream.End_Entity ("");
      
      Stream.End_Array ("data");
      Stream.End_Document;
   end;
   
   overriding
   function Dispatch
     (
      Handler : Optimaiden_Structure_Handler_Type;
      Request : AWS.Status.Data
     ) return AWS.Response.Data is
      Cif_Datablock :  Controlled_Datablock_Access;
      Output : aliased Util.Streams.Texts.Print_Stream;
      Stream : Util.Serialize.IO.JSON.Output_Stream;
   begin
      Parse_Cif_From_File (To_Unbounded_String (CIF_File_Name));
      Dequeue_Datablock (Cif_Datablock);
      
      Output.Initialize (Size => 10000);
      Stream.Initialize (Output => Output'Unchecked_Access);
      Write (Stream, Cif_Datablock);

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
