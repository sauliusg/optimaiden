with Ada.Characters.Handling; use Ada.Characters.Handling;
with Ada.Command_Line; use Ada.Command_Line;
with Ada.Environment_Variables; use Ada.Environment_Variables;
with Ada.Text_IO; use Ada.Text_IO;

with Filter_Lexer;
with Filter_Lexer_DFA;
with Filter; use Filter;
with YYInput_Definition; use YYInput_Definition;

procedure Parse_Filter is
   
   AFlex_Debug_Env_Variable : constant String := "PARSE_FILTER_AFLEX_DEBUG";
   
begin
   
   if 
     Exists (AFlex_Debug_Env_Variable) and then
     (Value (AFlex_Debug_Env_Variable) = "1" or else
        To_Lower (Value (AFlex_Debug_Env_Variable)) = "true" or else
        To_Lower (Value (AFlex_Debug_Env_Variable)) = "t")
   then
        Filter_Lexer_DFA.AFlex_Debug := True;
   end if;
   
   if Argument_Count = 0 then
      Put_Line ("Parsing default string: """ & Buffer & """");
      YYParse;
   else
      for I in 1 .. Argument_Count loop
         YYInput_Definition.Start_Parsing (Argument (I));
         Put_Line ("Parsing string: """ & Buffer & """");
         YYParse;
      end loop;
   end if;
  
end Parse_Filter;
