with Ada.Command_Line;
with Ada.Directories; use Ada.Directories;
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;
with Ada.Text_IO; use Ada.Text_IO;
with Cif_Datablock; use Cif_Datablock;
with Cif_Error_Messages;
with Cif_IO; use Cif_IO;
with Cif_Streaming_Parser; use Cif_Streaming_Parser;
with Interfaces.C.Strings; use Interfaces.C.Strings;

procedure Cif_Print_Datablock_Names is

  use Arguments_Vector;

  Cif_Datablock :  Controlled_Datablock_Access;
  Cif_Sources_Args   :  Arguments_Vector.Vector;
  Filename_Missing_Error : exception;
  File_Does_Not_Exist_Error : exception;
begin

  Cif_Sources_Args := Get_Cif_Sources (Min_Arg_Count => 1);

  for F of Cif_Sources_Args loop

    if F /= "-" and not Exists (To_String (F)) then
      raise File_Does_Not_Exist_Error with Cif_Error_Messages.File_Not_Exists & To_String (F);
    end if;
    
    Put_Line ("Enabling Parsing...");

    Enable_Parsing;
    
    Put_Line ("Parsing the file """ & To_String (F) & """...");
    
    Parse_Cif_From_File (F);

    Put_Line ("Starting the Dequeue loop...");
    
    loop  
      exit when Is_Parsing_Stopped;

      Put_Line ("About to Dequeue a data block...");
      Dequeue_Datablock (Cif_Datablock);

      Put_Line ("Data block dequeued...");
      Put_Line (Get_Datablock_Name (Cif_Datablock));

      if Is_Queue_Empty and 
        Get_If_Last_Datablock_In_Stream (Cif_Datablock) then
        Stop_Parsing;
      end if;
    end loop;
  end loop;
  
end Cif_Print_Datablock_Names;
