pragma Ada_2012; 

pragma Style_Checks (Off);
pragma Warnings (Off, "-gnatwu");

with Ada.Finalization;
with Interfaces.C;         use Interfaces.C;
with Interfaces.C.Strings; use Interfaces.C.Strings;
with System;

package Cif_Datablock is

  type Datablock is null record;

  type Datablock_Access is access all Datablock;

  type Counted_Datablock is record
    Ptr_Count : Integer;
    Ptr       : Datablock_Access;
  end record;

  type Controlled_Datablock_Access is
  new Ada.Finalization.Controlled with record
    Access_Datablock : access Counted_Datablock;
  end record;

  overriding procedure Initialize (Item : in out Controlled_Datablock_Access);

  overriding procedure Adjust (Item : in out Controlled_Datablock_Access);

  overriding procedure Finalize (Item : in out Controlled_Datablock_Access);

  function Create_Controlled_Datablock
   (DA : in Datablock_Access) return Controlled_Datablock_Access;

  procedure Delete_Datablock (DA : Datablock_Access) with
   Import => True, Convention => C, External_Name => "delete_datablock";

  function Datablock_Next (DA : Datablock_Access) return Datablock_Access with
    Import => True, Convention => C, External_Name => "datablock_next";

  function Get_Datablock_Length (CDA : in Controlled_Datablock_Access)
    return Integer;

  function Get_Datablock_Name (CDA : Controlled_Datablock_Access) return String;

  function Get_Datablock_Name (CDA : Datablock_Access) return String;

  procedure Print_Datablock (CDA : Controlled_Datablock_Access);

  function Get_If_Last_Datablock_In_Stream (CDA : Controlled_Datablock_Access)
    return Boolean;

  function Get_Tag_Index (CDA : Controlled_Datablock_Access; T : String) 
    return Integer;

  function Get_Tag_Name (CDA : in Controlled_Datablock_Access; TI : Integer)
    return String;

  function Get_Tag_Value
    (CDA : Controlled_Datablock_Access; 
     TI  : Integer;
     VI  : Integer)
    return String;

  function Get_Tag_Value_Length (CDA : Controlled_Datablock_Access; TI : Integer)
    return Integer;


private

  function Datablock_Length (DA : in Datablock_Access) return Integer with
    Import => True, Convention => C, External_Name => "datablock_length";

  function Datablock_Name (DA : Datablock_Access) return chars_ptr with
   Import => True, Convention => C, External_Name => "datablock_name";

  procedure Datablock_Print (DA : Datablock_Access) with
   Import => True, Convention => C, External_Name => "datablock_print";

  function Datablock_Tag_Index (DA : Datablock_Access; T : chars_ptr) return Integer with
    Import => True, Convention => C, External_Name => "datablock_tag_index";

  function Datablock_Get_Tag_Name (DA : in Datablock_Access; TI : Integer)
    return chars_ptr with
    Import => True, Convention => C, External_Name => "datablock_get_tag_name";

  function Datablock_Get_If_Last_In_Stream (DA : Datablock_Access) return Integer with
    Import => True, Convention => C, External_Name => "datablock_get_if_last_in_stream";
    
  function Datablock_Get_Tag_Value (DA : Datablock_Access; I : size_t) return chars_ptr with
    Import => True, Convention => C, External_Name => "datablock_get_tag_value";

  function Datablock_Get_Tag_Value_Length (DA : Datablock_Access; I : Integer) return Integer with
    Import => True, Convention => C, External_Name => "datablock_get_tag_value_length";

  function Datablock_Cif_Value_Get_String
    (DA : Datablock_Access;
     TN : Integer;
     VN : Integer)
     return chars_ptr with
     Import => True, Convention => C, External_Name => "datablock_cifvalue_get_string";

end Cif_Datablock;

pragma Style_Checks (On);
pragma Warnings (On, "-gnatwu");
