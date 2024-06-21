with Ada.Text_IO; use Ada.Text_IO;
with Cif_Datablock; use Cif_Datablock;
with Interfaces.C.Strings; use Interfaces.C.Strings;
with Logging;   use Logging;

with Ada.Unchecked_Deallocation;

package body Cif_Datablock is
   
   procedure Free is new Ada.Unchecked_Deallocation
     (Counted_Datablock,Counted_Datablock_Access);
   
  procedure Initialize (Item : in out Controlled_Datablock) is
  begin
    Log (Initialize, "Beginning");
  end Initialize;

  procedure Adjust (Item : in out Controlled_Datablock) is
  begin
    Log (Adjust, "Beginning");
    if Item.Access_Datablock /= null then
      Item.Access_Datablock.Ptr_Count := Item.Access_Datablock.Ptr_Count + 1;
    
    Log (Adjust,
      "Finished. Block: " & Value (Datablock_Name (Item.Access_Datablock.Ptr)) & " Pointer count: " &
      Integer'Image (Item.Access_Datablock.Ptr_Count));
    end if;
  end Adjust;

  procedure Finalize (Item : in out Controlled_Datablock) is
  begin
    if Item.Access_Datablock /= null then

      Log (Finalize,
        "Beginning decreasing pointer count. Block: " &
        Value (Datablock_Name (Item.Access_Datablock.Ptr)) &
        " Pointer count: " & Integer'Image (Item.Access_Datablock.Ptr_Count));

      Item.Access_Datablock.Ptr_Count := Item.Access_Datablock.Ptr_Count - 1;

      Log (Finalize,
        "Finished decreasing pointer count. Block: " & Value (Datablock_Name (Item.Access_Datablock.Ptr)) &
        ". Pointers: " & Integer'Image (Item.Access_Datablock.Ptr_Count));
      
      pragma Assert ( Item.Access_Datablock.Ptr_Count >= 0);

      if Item.Access_Datablock.Ptr_Count = 0 then

        Log (Finalize,
          "Deleting. Block: " &
          Value (Datablock_Name (Item.Access_Datablock.Ptr)));
        
        Delete_Datablock (Item.Access_Datablock.Ptr);
        Item.Access_Datablock.Ptr := null;
        Free (Item.Access_Datablock);
        
      end if;

    end if;
    
    -- No longer in our posession:
    Item.Access_Datablock := null;

    Log (Finalize, "Finished");
  end Finalize;

  function Create_Controlled_Datablock (DA : in Datablock_Access)
    return Controlled_Datablock is
    CDA : Controlled_Datablock;
  begin
    if DA /= null then
      CDA.Access_Datablock := new Counted_Datablock;
      CDA.Access_Datablock.Ptr_Count := 1;
      CDA.Access_Datablock.Ptr := DA;
    end if;
    return CDA;
  end Create_Controlled_Datablock;

  function Get_Datablock_Name (CDA : Controlled_Datablock) return String is
  begin
    return Value (Datablock_Name (CDA.Access_Datablock.Ptr));
  end Get_Datablock_Name;

  function Get_Datablock_Name (CDA : Datablock_Access) return String is
  begin
    return Value (Datablock_Name (CDA));
  end Get_Datablock_Name;

  function Get_Datablock_Length (CDA : in Controlled_Datablock)
    return Integer is
  begin
    return Datablock_Length (CDA.Access_Datablock.Ptr);
  end Get_Datablock_Length;

  procedure Print_Datablock (CDA : Controlled_Datablock) is
  begin
    Datablock_Print (CDA.Access_Datablock.Ptr);
  end Print_Datablock;

  function Get_If_Last_Datablock_In_Stream (CDA : Controlled_Datablock)
    return Boolean is
  begin
    if Datablock_Get_If_Last_In_Stream (CDA.Access_Datablock.Ptr) = 0 then
      return True;
    else
      return False;
    end if;
  end Get_If_Last_Datablock_In_Stream;

  function Get_Tag_Index (CDA : Controlled_Datablock; T : String)
                         return Integer is
     Tag_Index : Integer;
     T_Char_Ptr : Chars_Ptr := Null_Ptr;
  begin
     T_Char_Ptr := New_String (T);
     Tag_Index := Datablock_Tag_Index (CDA.Access_Datablock.Ptr, T_Char_Ptr);
     Free (T_Char_Ptr);
     return Tag_Index;
  exception
     when others =>
        if T_Char_Ptr /= Null_Ptr then
           Free (T_Char_Ptr);
        end if;
        raise;
  end Get_Tag_Index;

  function Get_Tag_Name (CDA : in Controlled_Datablock; TI : Integer) return String is
  begin
    return Value (Datablock_Get_Tag_Name (CDA.Access_Datablock.Ptr, TI));
  end Get_Tag_Name;
    
  function Get_Tag_Value 
    (CDA : Controlled_Datablock; TI : Integer; VI : Integer)
    return String is
  begin

    return Value (Datablock_Cif_Value_Get_String
      (CDA.Access_Datablock.Ptr, TI, VI));

  end Get_Tag_Value;

  function Get_Tag_Value_Length (CDA : Controlled_Datablock; TI : Integer)
    return Integer is
  begin
    return Datablock_Get_Tag_Value_Length (CDA.Access_Datablock.Ptr, TI);
  end Get_Tag_Value_Length;

end Cif_Datablock;
