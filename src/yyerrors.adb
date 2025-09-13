with Numbers_Tokens; use Numbers_Tokens;

package body YYErrors is
   
   procedure yyerror (S : String) is
   begin
      raise Syntax_Error with S;
   end;
   
end;
