with AWS.MIME; use AWS.MIME;
with Util.Streams.Texts;
with Util.Serialize.IO.JSON;
with Cif_Datablock; use Cif_Datablock;
with Cif_Streaming_Parser; use Cif_Streaming_Parser;

package body Optimaiden_Structure_Handler is
   
   procedure Write
     (
      Stream : out Util.Serialize.IO.JSON.Output_Stream
     ) is
      Cif_Datablock :  Controlled_Datablock_Access;
   begin
      Stream.Start_Document;
      Stream.Start_Array ("data");
      
      loop  
         exit when Is_Parsing_Stopped;

         Dequeue_Datablock (Cif_Datablock);

         Stream.Start_Entity ("");
         Stream.Start_Entity ("attributes");

         Stream.Write_Entity ("id", Get_Datablock_Name (CIF_Datablock));
         
         Stream.End_Entity ("attributes");
         Stream.Write_Entity ("type", "structures");
         Stream.End_Entity ("");

         if Is_Queue_Empty and 
           Get_If_Last_Datablock_In_Stream (Cif_Datablock) then
            Stop_Parsing;
         end if;
      end loop;
      
      Stream.End_Array ("data");
      Stream.End_Document;
   end;
   
   overriding
   function Dispatch
     (
      Handler : Optimaiden_Structure_Handler_Type;
      Request : AWS.Status.Data
     ) return AWS.Response.Data is
      Output : aliased Util.Streams.Texts.Print_Stream;
      Stream : Util.Serialize.IO.JSON.Output_Stream;
   begin
      Parse_Cif_From_File (CIF_File_Name);
      
      Output.Initialize (Size => 10000);
      Stream.Initialize (Output => Output'Unchecked_Access);
      
      Write (Stream);

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
