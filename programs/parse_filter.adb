with Ada.Command_Line; use Ada.Command_Line;
with Ada.Text_IO; use Ada.Text_IO;

with Filter_Lexer;
with Filter_Lexer_DFA;
with Filter; use Filter;
with YYInput_Definition; use YYInput_Definition;

procedure Parse_Filter is

begin
   
   Filter_Lexer_DFA.AFlex_Debug := False;
   
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
