with Ada.Command_Line;
with Ada.Containers; use Ada.Containers;
with Ada.Containers.Indefinite_Vectors;
with Ada.Containers.Vectors;
with Ada.Directories; use Ada.Directories;
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;
with Ada.Text_IO; use Ada.Text_IO;
with Cif_Datablock; use Cif_Datablock;
with Cif_Error_Messages;
with Cif_IO; use Cif_IO;
with Cif_Streaming_Parser; use Cif_Streaming_Parser;
with Interfaces.C.Strings; use Interfaces.C.Strings;

procedure Cif_Print_Datablock is
  Cif_Datablock                    : Controlled_Datablock_Access;
  No_Source_And_Datablock_Id_Error : exception;
  File_Does_Not_Exist_Error        : exception;

  use Arguments_Vector;

  Cif_Datablock_Name_Args       : Arguments_Vector.Vector;
  Cif_Datablock_Name_Args_Local : Arguments_Vector.Vector;
  Cif_Sources_Args              : Arguments_Vector.Vector;

begin

  if Ada.Command_Line.Argument_Count = 0 then
    raise No_Source_And_Datablock_Id_Error with Cif_Error_Messages.No_Source_And_Datablock_Id;
  end if;

  Cif_Datablock_Name_Args := Get_Separated_Argument_Values;
  Cif_Sources_Args        := Get_Cif_Sources (Min_Arg_Count => 2);

  for F of Cif_Sources_Args loop

    if F /= "-" and not Exists (To_String (F)) then
      raise File_Does_Not_Exist_Error with Cif_Error_Messages.File_Not_Exists & To_String (F);
    end if;

    Enable_Parsing;

    Cif_Datablock_Name_Args_Local := Copy (Cif_Datablock_Name_Args);

    Parse_Cif_From_File (F);

    while not Is_Parsing_Stopped loop
      Dequeue_Datablock (Cif_Datablock);

      if Contains (Cif_Datablock_Name_Args_Local, To_Unbounded_String (Get_Datablock_Name (Cif_Datablock))) then
        Print_Datablock (Cif_Datablock);
        Cif_Datablock_Name_Args_Local.Delete
          (Cif_Datablock_Name_Args_Local.Find_Index (To_Unbounded_String (Get_Datablock_Name (Cif_Datablock))));
      end if;
      
      if Length (Cif_Datablock_Name_Args_Local) = 0 or 
        (Is_Queue_Empty and Get_If_Last_Datablock_In_Stream (Cif_Datablock)) then
        Stop_Parsing;
      end if;
    end loop;
  end loop;
  
end Cif_Print_Datablock;

