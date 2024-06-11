with Ada.Text_IO; use Ada.Text_IO;
with AWS.MIME; use AWS.MIME;
with Util.Beans;
with Util.Beans.Objects;
with Util.Streams.Texts;
with Util.Serialize.IO.JSON;
with Cif_Datablock; use Cif_Datablock;
with Cif_Streaming_Parser; use Cif_Streaming_Parser;

package body Optimaiden_Structure_Handler is
   
   function Get_Float_Value
     (
      CDA : Controlled_Datablock_Access;
      Tag_Index : Integer;
      Value_Index : Integer
     ) return Float is
      
      Value_String : String :=
        Get_Tag_Value (CDA, Tag_Index, Value_Index);

      Last_Index : Integer := Value_String'First;
        
   begin
      while Last_Index <= Value_String'Last and then
        Value_String (Last_Index) /= '(' loop
        Last_Index := Last_Index + 1;
      end loop;
      return Float'Value (Value_String (Value_String'First .. Last_Index - 1));
   end;
   
   procedure Write_Entity
     (
      Stream : in out Util.Serialize.IO.JSON.Output_Stream;
      Name   : in String;
      Value  : in Float
     ) is
      Beans_Object : Util.Beans.Objects.Object :=
        Util.Beans.Objects.To_Object (Value);
   begin
      Stream.Write_Entity (Name, Beans_Object);
   end;
   
   procedure Write_Float_If_Exists
     (
      Stream : in out Util.Serialize.IO.JSON.Output_Stream;
      JSON_Name : String;
      CIF_Tag_Name : String;
      CDA : Controlled_Datablock_Access
     ) is
      Tag_Index : Integer := Get_Tag_Index (CDA, CIF_Tag_Name);
   begin
      if Tag_Index >= 0 then
         Write_Entity
           (
            Stream, JSON_Name,
            Get_Float_Value (CDA, Tag_Index, 0)
           );
      end if;
   end;

   procedure Write
     (
      Stream : out Util.Serialize.IO.JSON.Output_Stream;
      CIF_File_Name : Unbounded_String
     ) is
      CDA : Controlled_Datablock_Access;
   begin
      Stream.Start_Document;
      Stream.Start_Array ("data");
      
      Parse_Cif_From_File (CIF_File_Name);
      
      loop  
         exit when Is_Parsing_Stopped;

         Dequeue_Datablock (CDA);

         Stream.Start_Entity ("");
         Stream.Start_Entity ("attributes");
         
         Write_Float_If_Exists (Stream, "_cod_a", "_cell_length_a", CDA);
         Write_Float_If_Exists (Stream, "_cod_b", "_cell_length_b", CDA);
         Write_Float_If_Exists (Stream, "_cod_c", "_cell_length_c", CDA);
         
         Write_Float_If_Exists (Stream, "_cod_alpha", "_cell_angle_alpha", CDA);
         Write_Float_If_Exists (Stream, "_cod_beta", "_cell_angle_beta", CDA);
         Write_Float_If_Exists (Stream, "_cod_gamma", "_cell_angle_gamma", CDA);
                         
         Stream.End_Entity ("attributes");
         
         Stream.Write_Entity ("id", Get_Datablock_Name (CDA));
         Stream.Write_Entity ("type", "structures");
         Stream.End_Entity ("");

         if Is_Queue_Empty and then Get_If_Last_Datablock_In_Stream (CDA) then
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
