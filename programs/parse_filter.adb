with Ada.Characters.Handling; use Ada.Characters.Handling;
with Ada.Command_Line; use Ada.Command_Line;
with Ada.Environment_Variables; use Ada.Environment_Variables;
with Ada.Text_IO; use Ada.Text_IO;

with Filter_Lexer;
with Filter_Lexer_DFA;
with Filter; use Filter;
with YYInput_Definition; use YYInput_Definition;

procedure Parse_Filter is

begin
   
   if 
     Exists ("PARSE_FILTER_AFLEX_DEBUG") and then
     (Value ("PARSE_FILTER_AFLEX_DEBUG") = "1" or else
        To_Lower (Value ("PARSE_FILTER_AFLEX_DEBUG")) = "true" or else
        To_Lower (Value ("PARSE_FILTER_AFLEX_DEBUG")) = "t")
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
