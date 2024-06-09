with Ada.Containers; use Ada.Containers;
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;
with CExceptions_Ada; use CExceptions_Ada;
with Cif_Options_Ada; use Cif_Options_Ada;
with Cif_Datablock; use Cif_Datablock;
with Datablock_Queue; use Datablock_Queue;
with Interfaces.C; use Interfaces.C;
with Interfaces.C.Strings; use Interfaces.C.Strings;

package Cif_Streaming_Parser is

  use Datablock_Bounded_Queue;

  function Is_Queue_Empty return Boolean;

  procedure Enqueue_Datablock (DA : in Datablock_Access) with
   Export => True, External_Name => "enqueue_datablock";

  procedure Dequeue_Datablock (CDA : out Controlled_Datablock_Access) with
   Export => True, External_Name => "dequeue_datablock";

  procedure Parse_Cif_From_File (Filename : in Unbounded_String);
  
  procedure Enqueue_Datablock (Q  : in out Queue;
                               DA : in Datablock_Access);
  procedure Dequeue_Datablock (Q   : in out Queue;
                               CDA : out Controlled_Datablock_Access);

  function Get_Queue_Item_Count (Q : in Queue)
    return Count_Type;

  procedure Enable_Parsing;

  procedure Stop_Parsing;

  function Is_Parsing_Stopped return Boolean with
    Export => True, External_Name => "is_parsing_stopped";

  procedure Flush_Queue;

  procedure Flush_Queue (Q : in out Queue);

private
  
  procedure Parse_Cif_From_File_With_Error_Code (Filename : char_array;
                                                 CO : Cif_Option_T;
                                                 EX : Error_Code_T_Access) 
        with Import => True,
        Convention => C,
        External_Name => "parse_cif_from_file_with_error_code";

  procedure Cif1_Init_Parser
    with Import => True,
    Convention => C,
    External_Name => "cif1_init_parser";
  
  procedure Cif1_Display_Static_Parser_Variables
    with Import => True,
    Convention => C,
    External_Name => "cif1_display_static_parser_variables";
  
  procedure Cif2_Init_Parser
    with Import => True,
    Convention => C,
    External_Name => "cif2_init_parser";
  
  procedure Cif2_Display_Static_Parser_Variables
    with Import => True,
    Convention => C,
    External_Name => "cif2_display_static_parser_variables";
  
  Cif_Queue : Queue;

end Cif_Streaming_Parser;
