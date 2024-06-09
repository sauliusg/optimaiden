package Cif_Error_Messages is

    File_Not_Exists            : constant String := "File does not exist: ";
    No_Source_And_Datablock_Id : constant String 
      := "Must provide at least one datablock id and one CIF source (filename or standard input).";
    No_Source                  : constant String 
      := "Must provide at least one CIF source (filename or standard input).";

end Cif_Error_Messages;
