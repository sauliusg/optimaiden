with Ada.Containers.Indefinite_Vectors;
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;

package Cif_IO is

  Max_Stdout_Length_Env_Variable_Name : constant String   := "CIF_STREAMING_PARSER_MAX_STDOUT_LENGTH";
  Default_Max_Stdout_Length           : constant Positive := 15;

  package Arguments_Vector is new Ada.Containers.Indefinite_Vectors
    (Index_Type   => Positive,
     Element_Type => Unbounded_String);

  use Arguments_Vector;

  package Arguments_Vector_Sorting is new Arguments_Vector.Generic_Sorting;

  function Get_Separated_Argument_Values
    (Argument_No : Positive := 1;
     Separator   : Character := ' ') return Vector;

  function Get_Cif_Sources (Min_Arg_Count : Positive) return Vector;

  function Get_Max_Stdout_Length return Positive;

end Cif_IO;
