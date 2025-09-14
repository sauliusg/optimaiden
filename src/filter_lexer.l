
DECIMAL_DIGIT  [0-9]
INTEGER	       {DECIMAL_DIGIT}+
FIXED	       ({DECIMAL_DIGIT}+"."{DECIMAL_DIGIT}*)|("."{DECIMAL_DIGIT}+)
REAL           ({FIXED}|{INTEGER})([eE]([-+]?)[0-9]+)?

%% 

[A-Z]+      {
              yylval.S := To_Unbounded_String (filter_lexer_dfa.yytext);
              return KEYWORD_TOKEN;
            }
[a-z]+      {
              yylval.S := To_Unbounded_String (filter_lexer_dfa.yytext);
              return IDENTIFIER_TOKEN;
            }
{REAL}      {
              yylval.N := Float'Value (filter_lexer_dfa.yytext);
              return NUMBER_TOKEN;
            }
"**"        { return EXP; }
"("         { return '('; }
")"         { return ')'; }
"+"         { return '+'; }
"/"         { return '/'; }
"*"         { return '*'; }
"="         { return '='; }
"-"         { return '-'; }
" "         { return ' '; }
\n          { return LF_TOKEN; }
%%

with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;
with filter_tokens; use filter_tokens;

package filter_lexer is
  function YYLex return Token;
end;

package body filter_lexer is

##

end filter_lexer;
