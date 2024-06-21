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
      CDA : Controlled_Datablock;
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
   
   function Get_Integer_Value
     (
      CDA : Controlled_Datablock;
      Tag_Index : Integer;
      Value_Index : Integer
     ) return Integer is
      
      Value_String : String :=
        Get_Tag_Value (CDA, Tag_Index, Value_Index);

   begin
      return Integer'Value (Value_String);
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
   
   procedure Write_Entity
     (
      Stream : in out Util.Serialize.IO.JSON.Output_Stream;
      Name   : in String;
      Value  : in Integer
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
      CDA : Controlled_Datablock
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

   procedure Write_Float_If_Exists
     (
      Stream : in out Util.Serialize.IO.JSON.Output_Stream;
      JSON_Name : Unbounded_String;
      CIF_Tag_Name : Unbounded_String;
      CDA : Controlled_Datablock
     ) is
   begin
      Write_Float_If_Exists
        (
         Stream,
         To_String (JSON_Name),
         To_String (CIF_Tag_Name),
         CDA
        );
   end;

   procedure Write_Integer_If_Exists
     (
      Stream : in out Util.Serialize.IO.JSON.Output_Stream;
      JSON_Name : String;
      CIF_Tag_Name : String;
      CDA : Controlled_Datablock
     ) is
      Tag_Index : Integer := Get_Tag_Index (CDA, CIF_Tag_Name);
   begin
      if Tag_Index >= 0 then
         Write_Entity
           (
            Stream, JSON_Name,
            Get_Integer_Value (CDA, Tag_Index, 0)
           );
      end if;
   end;

   procedure Write_Integer_If_Exists
     (
      Stream : in out Util.Serialize.IO.JSON.Output_Stream;
      JSON_Name : Unbounded_String;
      CIF_Tag_Name : Unbounded_String;
      CDA : Controlled_Datablock
     ) is
   begin
      Write_Integer_If_Exists
        (
         Stream,
         To_String (JSON_Name),
         To_String (CIF_Tag_Name),
         CDA
        );
   end;

   type Access_All_String is access all String;
   
   type CIF_JSON_Mapping is record
      JSON_Name : Unbounded_String;
      CIF_Tag : Unbounded_String;
   end record;
   
   function Make_Mapping (J, C : String) return CIF_JSON_Mapping is
   begin
      return (To_Unbounded_String (J), To_Unbounded_String (C));
   end;
   
   CIF_Real_Value_Tags : constant array (Integer range <>) 
     of CIF_JSON_Mapping :=
     (
      Make_Mapping ("_cod_a", "_cell_length_a"),
      Make_Mapping ("_cod_b", "_cell_length_b"),
      Make_Mapping ("_cod_c", "_cell_length_c"),
      Make_Mapping ("_cod_alpha", "_cell_angle_alpha"),
      Make_Mapping ("_cod_beta",  "_cell_angle_beta"),
      Make_Mapping ("_cod_gamma", "_cell_angle_gamma")
     );
      
   CIF_Integer_Value_Tags : constant array (Integer range <>) 
     of CIF_JSON_Mapping :=
     (
      1 => Make_Mapping ("_cod_Z", "_cell_formula_units_Z")
     );
      
   procedure Write
     (
      Stream : out Util.Serialize.IO.JSON.Output_Stream;
      CIF_File_Name : Unbounded_String
     ) is
      CDA : Controlled_Datablock;
      
   begin
      Stream.Start_Document;
      Stream.Start_Array ("data");
      
      Enable_Parsing;

      Parse_Cif_From_File (CIF_File_Name);
      
      loop  
         exit when Is_Parsing_Stopped;

         Dequeue_Datablock (CDA);

         Stream.Start_Entity ("");
         Stream.Start_Entity ("attributes");
         
         for M of CIF_Real_Value_Tags loop
            Write_Float_If_Exists (Stream, M.JSON_Name, M.CIF_Tag, CDA);
         end loop;
                         
         for M of CIF_Integer_Value_Tags loop
            Write_Integer_If_Exists (Stream, M.JSON_Name, M.CIF_Tag, CDA);
         end loop;
                         
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
