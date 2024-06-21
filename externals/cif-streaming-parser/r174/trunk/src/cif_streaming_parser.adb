with Ada.Containers; use Ada.Containers;
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;
with Ada.Text_IO; use Ada.Text_IO;
with CExceptions_Ada; use CExceptions_Ada;
with Cif_Options_Ada; use Cif_Options_Ada;
with Logging; use Logging;
with Interfaces.C; use Interfaces.C;
with Interfaces.C.Strings; use Interfaces.C.Strings;

package body Cif_Streaming_Parser is

  Parsing_Stopped : Boolean;

  task Cif_Parser_Task is
     entry Begin_Parsing (Cif_Filename : Unbounded_String;
                          Cif_Options : Cif_Option_T);
  end Cif_Parser_Task;

  task body Cif_Parser_Task is
     Task_Cif_Filename : Unbounded_String;
     Task_Cif_Options : Cif_Option_T;
     Task_Error_Code_Access : Error_Code_T_Access;
  begin
     -- On some OSes, notably on Debian-10 and Ubuntu-20.04, the BSS
     --  segment seems to be uninitialised, and the parser fails with
     --  Assertion "`!cif_cc' failed" in
     --  src/externals/codcif/cif_grammar.y:502. To avoid this, the
     --  static global variables in the C code are now initialised
     --  explicitly:
     Cif1_Init_Parser;
     Cif2_Init_Parser;
     loop
        select
           accept Begin_Parsing (Cif_Filename : in Unbounded_String;
                                 Cif_Options : in Cif_Option_T) do
              Task_Cif_Filename := Cif_Filename;
              Task_Cif_Options := Cif_Options;
              Task_Error_Code_Access := Parse_Cif_From_File_Error_Code;
           end Begin_Parsing;
           declare
              Filename_Char_Array :  char_array := To_C (To_String (Task_Cif_Filename), Append_Nul => TRUE);
           begin
              Parse_Cif_From_File_With_Error_Code (Filename_Char_Array, Task_Cif_Options);
           end;
        or
           terminate;
        end select;
     end loop;
  end Cif_Parser_Task;

  function Is_Queue_Empty return Boolean is
  begin
    return Get_Queue_Item_Count (Cif_Queue) = 0; 
  end Is_Queue_Empty;

  procedure Enqueue_Datablock (DA : in Datablock_Access) is
  begin
    Enqueue_Datablock (Cif_Queue, DA);
  end Enqueue_Datablock;
  
  procedure Dequeue_Datablock (CDA : out Controlled_Datablock) is
  begin
    Dequeue_Datablock (Cif_Queue, CDA);
  end Dequeue_Datablock;

  Error_Code : aliased Error_Code_T;
  
  procedure Parse_Cif_From_File (Filename : in Unbounded_String) is
     Cif_Options  : Cif_Option_T;
  begin
     Cif_Options := Cif_Option_Default;
     Cif_Parser_Task.Begin_Parsing (Filename, Cif_Options);
  end Parse_Cif_From_File;

  procedure Enqueue_Datablock (Q : in out Queue;
                               DA : in Datablock_Access) is
     CD : Controlled_Datablock;
  begin
     Log (Enqueue_Datablock, "Beginning. Block: " & Get_Datablock_Name (DA));
    
     CD := Create_Controlled_Datablock (DA);
     Q.Enqueue (CD);
    
    Log (Enqueue_Datablock,
      "Finished. Block " &
      Get_Datablock_Name (CD.Access_Datablock.Ptr));
  end Enqueue_Datablock;

  procedure Dequeue_Datablock (Q   : in out Queue;
                               CDA : out Controlled_Datablock) is
  begin
    Log (Dequeue_Datablock, "Beginning");
    
    Q.Dequeue (CDA);
    
    Log (Dequeue_Datablock,
      "Finished. Block " &
      Get_Datablock_Name (CDA.Access_Datablock.Ptr));
  end Dequeue_Datablock;

  function Get_Queue_Item_Count (Q : in Queue)
    return Count_Type is
  begin
    return Current_Use (Q);
  end  Get_Queue_Item_Count;

  procedure Enable_Parsing is
  begin
    Parsing_Stopped := False;
  end Enable_Parsing;

  procedure Stop_Parsing is
  begin
    Flush_Queue;
    Parsing_Stopped := True;
  end Stop_Parsing;

  function Is_Parsing_Stopped return Boolean is
  begin
    return Parsing_Stopped;
  end Is_Parsing_Stopped;

  procedure Flush_Queue is
    DQ_DB : Controlled_Datablock;
  begin
    while not Is_Queue_Empty loop
      Dequeue_Datablock (DQ_DB);
    end loop;
  end Flush_Queue;

  procedure Flush_Queue (Q : in out Queue) is
    DQ_DB : Controlled_Datablock;
  begin
    while Get_Queue_Item_Count (Q) > 0 loop
      Dequeue_Datablock (Q, DQ_DB);
    end loop;
  end Flush_Queue;

end Cif_Streaming_Parser;
