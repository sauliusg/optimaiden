with Filter_Tokens; use Filter_Tokens;

package body YYErrors is
   
   procedure yyerror (S : String) is
   begin
      raise Syntax_Error with S;
   end;
   
end;
