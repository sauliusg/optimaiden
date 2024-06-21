with Ada.Characters.Latin_1; use Ada.Characters.Latin_1;
with Ada.Command_Line; use Ada.Command_Line;
with Ada.Containers; use Ada.Containers;
with Ada.Containers.Hashed_Maps;
with Ada.Containers.Indefinite_Vectors;
with Ada.Containers.Vectors;
with Ada.Directories; use Ada.Directories;
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;
with Ada.Text_IO; use Ada.Text_IO;
with Cif_Datablock; use Cif_Datablock;
with Cif_Datablock_Tag; use Cif_Datablock_Tag;
with Cif_Error_Messages;
with Cif_IO; use Cif_IO;
with Cif_Streaming_Parser; use Cif_Streaming_Parser;

procedure Cif_Tag_Stats is
  Cif_Datablock             : Controlled_Datablock;
  No_Cif_Source_Error       : exception;
  File_Does_Not_Exist_Error : exception;

  use Datablock_Tags_Map;

  Datablock_Tags      : Datablock_Tags_Map.Map;
  Cif_Sources_Args    : Arguments_Vector.Vector;

begin
  Cif_Sources_Args := Get_Cif_Sources (Min_Arg_Count => 1);

  for F of Cif_Sources_Args loop
    if F /= "-" and not Exists (To_String (F)) then
      raise File_Does_Not_Exist_Error with Cif_Error_Messages.File_Not_Exists & To_String (F);
    end if;
    
    Enable_Parsing;

    Parse_Cif_From_File (F);

    loop
      exit when Is_Parsing_Stopped;

      Dequeue_Datablock (Cif_Datablock);

      declare
        Conc_Value_String        : Unbounded_String := Null_Unbounded_String;
        Datablock_Tag_Name_Local : Unbounded_String := Null_Unbounded_String;
        Datablock_Tag_Local      : Datablock_Tag;
      begin
      for TI in 0 .. Get_Datablock_Length (Cif_Datablock) - 1 loop
        for VI in 0 .. Get_Tag_Value_Length (Cif_Datablock, TI) - 1 loop
          Append (Conc_Value_String, To_Unbounded_String (Get_Tag_Value (Cif_Datablock, TI, VI)));

          if Get_Tag_Value_Length (Cif_Datablock, TI) > 1 then
            Append (Conc_Value_String, To_Unbounded_String (";"));
          end if;

        end loop;

        Datablock_Tag_Name_Local := To_Unbounded_String (Get_Tag_Name (Cif_Datablock, TI));

        if Contains (Container => Datablock_Tags, Key => To_String (Datablock_Tag_Name_Local)) then
          if not Datablock_Tags (To_String (Datablock_Tag_Name_Local)).Values.Contains(Conc_Value_String) then
            --Append ((Datablock_Tags (To_String (Datablock_Tag_Name_Local)).Values), Conc_Value_String);
            Datablock_Tags (To_String (Datablock_Tag_Name_Local)).Values.Append(Conc_Value_String);
          end if;
        else
          Datablock_Tag_Local := 
            (Name => Datablock_Tag_Name_Local,
             Values => Datablock_Tag_Values_Vector.Empty_Vector);
          Datablock_Tag_Local.Values.Append (Conc_Value_String);
          Include (Container => Datablock_Tags,
                  Key => To_String (Datablock_Tag_Local.Name),
                  New_Item => Datablock_Tag_Local);
        end if;
        Conc_Value_String := Null_Unbounded_String;
      end loop;
      end;

      if Is_Queue_Empty and 
        Get_If_Last_Datablock_In_Stream (Cif_Datablock) then
        Stop_Parsing;
      end if;
    end loop;
  end loop;

  declare
    Max_Stdout_Length : constant Positive := Get_Max_Stdout_Length;
    Tag_Name          : Unbounded_String := Null_Unbounded_String;
    Min_Value         : Unbounded_String := Null_Unbounded_String;
    Max_Value         : Unbounded_String := Null_Unbounded_String;
    Median_Value      : Unbounded_String := Null_Unbounded_String;

    use Datablock_Tag_Values_Vector;
  begin
  for C in Datablock_Tags.Iterate loop

    Sort_Tag_Values (Datablock_Tags (C));

    if Length (Datablock_Tags (C).Name) > Max_Stdout_Length then
      Tag_Name := To_Unbounded_String (Slice (Datablock_Tags (C).Name, 1, Max_Stdout_Length));
      Append (Tag_Name, "...");
    else
      Tag_Name := Datablock_Tags (C).Name;
      for I in 1 .. (Max_Stdout_Length - Length (Tag_Name)) loop
        Append (Tag_Name, ' ');
      end loop;
    end if;

    if Length (First_Element (Datablock_Tags (C).Values)) > Max_Stdout_Length then
      Min_Value := To_Unbounded_String (Slice (First_Element (Datablock_Tags (C).Values), 1, Max_Stdout_Length));
      Append (Min_Value, "...");
    else
      Min_Value := First_Element (Datablock_Tags (C).Values);
      for I in 1 .. (Max_Stdout_Length - Length (Min_Value)) loop
        Append (Min_Value, ' ');
      end loop;
    end if;

    if Length (Last_Element (Datablock_Tags (C).Values)) > Max_Stdout_Length then
      Max_Value := To_Unbounded_String (Slice (Last_Element (Datablock_Tags (C).Values), 1, Max_Stdout_Length));
      Append (Max_Value, "...");
    else
      Max_Value := Last_Element (Datablock_Tags (C).Values);
      for I in 1 .. (Max_Stdout_Length - Length (Max_Value)) loop
        Append (Max_Value, ' ');
      end loop;
    end if;

    if Length (Get_Tag_Median_Value (Datablock_Tags (C))) > Max_Stdout_Length then
      Median_Value := To_Unbounded_String (Slice (Get_Tag_Median_Value (Datablock_Tags (C)), 1, Max_Stdout_Length));
      Append (Median_Value, "...");
    else
      Median_Value := Get_Tag_Median_Value (Datablock_Tags (C));
      for I in 1 .. (Max_Stdout_Length - Length (Median_Value)) loop
        Append (Median_Value, ' ');
      end loop;
    end if;
    
    Put_Line ("Tag name: " & To_String (Tag_Name)
            & HT
            & "Min value: " & To_String (Min_Value)
            & HT
            & "Max value: " & To_String (Max_Value)
            & HT
            & "Median value: " & To_String (Median_Value));

    Tag_Name     := Null_Unbounded_String;
    Min_Value    := Null_Unbounded_String;
    Max_Value    := Null_Unbounded_String;
    Median_Value := Null_Unbounded_String;
  end loop;
  end;

end Cif_Tag_Stats;
