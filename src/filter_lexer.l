
DECIMAL_DIGIT  [0-9]
INTEGER	       {DECIMAL_DIGIT}+
FIXED	       ({DECIMAL_DIGIT}+"."{DECIMAL_DIGIT}*)|("."{DECIMAL_DIGIT}+)
REAL           ({FIXED}|{INTEGER})([eE]([-+]?)[0-9]+)?

%% 

[A-Z]+      {
              yylval.S := To_Unbounded_String (filter_lexer_dfa.yytext);
              Put_Line (">>> Token: KEYWORD_TOKEN, """ & To_String (yylval.S) & """");
              return KEYWORD_TOKEN;
            }
[a-z]+      {
              yylval.S := To_Unbounded_String (filter_lexer_dfa.yytext);
              Put_Line (">>> Token: IDENTIFIER_TOKEN, """ & To_String (yylval.S) & """");
              return IDENTIFIER_TOKEN;
            }
{REAL}      {
              yylval.N := Float'Value (filter_lexer_dfa.yytext);
              Put_Line (">>> Token: NUMBER_TOKEN, """ & yylval.N'Image & """");
              return NUMBER_TOKEN;
            }
"("         { yylval.C := filter_lexer_dfa.yytext(1); return '('; }
")"         { yylval.C := filter_lexer_dfa.yytext(1); return ')'; }
"+"         { yylval.C := filter_lexer_dfa.yytext(1); return '+'; }
"="         { yylval.C := filter_lexer_dfa.yytext(1); return '='; }
"-"         { yylval.C := filter_lexer_dfa.yytext(1); return '-'; }
" "         { yylval.C := filter_lexer_dfa.yytext(1); return ' '; }
\n          { return LF_TOKEN; }
\r          { return CR_TOKEN; }
\t          { return HT_TOKEN; }
\v          { return VT_TOKEN; }
\f          { return FF_TOKEN; }
%%

with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;
with filter_tokens; use filter_tokens;

package filter_lexer is
  function YYLex return Token;
end;

package body filter_lexer is

##

end filter_lexer;
