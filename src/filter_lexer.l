%% 
[A-Z]+      { return IDENTIFIER; }
[a-z]+      { return IDENTIFIER; }
[0-9]+      {
              yylval.value := Integer'Value (lexer_dfa.yytext);
              return NUMBER;
            }
"**"        { return EXP; }
"("         { return '('; }
")"         { return ')'; }
"+"         { return '+'; }
"/"         { return '/'; }
"*"         { return '*'; }
"="         { return '='; }
"-"         { return '-'; }
\n          { return NEW_LINE; }
[\t ]+      { null;} 
%%

with filter_tokens; 
use  filter_tokens;

package filter_lexer is
  function YYLex return Token;
end;

package body filter_lexer is

##

end filter_lexer;
