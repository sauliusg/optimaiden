with Ada.Environment_Variables; use Ada.Environment_Variables;
with Ada.Text_IO; use Ada.Text_IO;

package body Logging is

  Ada_Identifier : constant String := "[Ada]";
  Log_Env_Variable : constant String := "CSP_LOGS";

  procedure Log (Method : Method_Enum; Message : String) is
  begin
    if Exists (Log_Env_Variable) then
      if Value (Log_Env_Variable) = "ON" then
        Put_Line (Ada_Identifier & "[" & Method_Enum'Image (Method) & "] " & Message);
      end if;
    end if;
  end Log;

end Logging;
