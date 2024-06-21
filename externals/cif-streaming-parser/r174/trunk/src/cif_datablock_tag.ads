with Ada.Containers.Indefinite_Vectors;
with Ada.Containers.Indefinite_Hashed_Maps;
with Ada.Containers.Vectors;
with Ada.Strings.Hash;
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;

package Cif_Datablock_Tag is

  subtype Datablock_Tag_Name_Arg is String;

  package Datablock_Tag_Values_Vector
    is new Ada.Containers.Indefinite_Vectors
      (Index_Type => Natural,
       Element_Type => Unbounded_String);

  use Datablock_Tag_Values_Vector;

  type Datablock_Tag is record
    Name      : Unbounded_String;
    Values    : Datablock_Tag_Values_Vector.Vector;
  end record;
  
  package Datablock_Tags_Map is new Ada.Containers.Indefinite_Hashed_Maps
    (Key_Type => String,
     Element_Type => Datablock_Tag,
     Hash => Ada.Strings.Hash,
     Equivalent_Keys => "=");

  package Datablock_Tag_Values_Vector_Sorting is
    new Datablock_Tag_Values_Vector.Generic_Sorting;
  
  procedure Sort_Tag_Values (T : in out Datablock_Tag);

  function Get_Tag_Median_Value (T : in Datablock_Tag)
    return Unbounded_String;

end Cif_Datablock_Tag;
