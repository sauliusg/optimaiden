with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;
with Util.Serialize.IO.JSON;

package Structure_To_JSON is
   
   procedure Write
     (
      Stream : out Util.Serialize.IO.JSON.Output_Stream;
      CIF_File_Name : Unbounded_String
     );   
   
end;
