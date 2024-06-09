with Ada.Containers; use Ada.Containers;
with Ada.Exceptions; use Ada.Exceptions;
with Ada.Text_IO; use Ada.Text_IO;

package body Cif_Datablock_Tag is

  use Datablock_Tag_Values_Vector_Sorting;

  procedure Sort_Tag_Values (T : in out Datablock_Tag) is
  begin
    Sort (T.Values);
  end Sort_Tag_Values;

  function Get_Tag_Median_Value (T : in Datablock_Tag)
    return Unbounded_String is
  begin
    if Length (T.Values) = 0 then
      return Null_Unbounded_String;
    end if;

    if Length (T.Values) = 1 then
      return First_Element (T.Values);
    else
      if Length (T.Values) mod 2 = 0 then
        return T.Values.Element (Integer(Length (T.Values)) / 2);
      else
        return T.Values.Element (Integer(Length (T.Values) - 1) / 2 + 1);
      end if;
    end if;
  end Get_Tag_Median_Value;

end Cif_Datablock_Tag;
