with Ada.Command_Line; use Ada.Command_Line;
with Ada.Containers.Indefinite_Vectors;
with Ada.Environment_Variables; use Ada.Environment_Variables;
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;
with Ada.Text_IO; use Ada.Text_IO;

with Ada.Containers; use Ada.Containers;

package body Cif_IO is

  function Get_Separated_Argument_Values
    (Argument_No : Positive := 1;
     Separator : Character := ' ')
  return Vector is

    Name_Args     : Arguments_Vector.Vector;
    Org_Arg       : Unbounded_String := Null_Unbounded_String;
    Name_Slice    : Unbounded_String := Null_Unbounded_String;
    Start_Pos     : Integer := 1;
  begin

    Org_Arg := To_Unbounded_String (Ada.Command_Line.Argument (Argument_No));

    for I in 1 .. Length (Org_Arg) loop
      if Element (Org_Arg, I) = Separator then
        for Y in Start_Pos .. I - 1 loop
          Append (Name_Slice, Element (Org_Arg, Y));
        end loop;
        
        if not Contains (Name_Args, Name_Slice) then
          Name_Args.Append (Name_Slice);
        end if;

        Name_Slice := Null_Unbounded_String;
        Start_Pos  := I + 1;
      end if;
    end loop;

    for X in Start_Pos .. Length (Org_Arg) loop
      Append (Name_Slice, Element (Org_Arg, X));
    end loop;

    if not Contains (Name_Args, Name_Slice) then
      Name_Args.Append (Name_Slice);
    end if;

    return Name_Args;

  end Get_Separated_Argument_Values;

  function Get_Cif_Sources (Min_Arg_Count : Positive) return Vector is
    Source_Args : Arguments_Vector.Vector;
  begin
    if Ada.Command_Line.Argument_Count < Min_Arg_Count then
      Source_Args.Append (To_Unbounded_String ("-"));
    else
      for I in Min_Arg_Count .. Ada.Command_Line.Argument_Count loop
        Append (Source_Args, To_Unbounded_String (Ada.Command_Line.Argument (I)));
      end loop;
    end if;

    return Source_Args;
  end Get_Cif_Sources;

  function Get_Max_Stdout_Length return Positive is
  begin
    if Exists (Max_Stdout_Length_Env_Variable_Name) then
      return Positive'Value (Value (Max_Stdout_Length_Env_Variable_Name));
    else
      return Default_Max_Stdout_Length;
    end if;
  end Get_Max_Stdout_Length;

end Cif_IO;
