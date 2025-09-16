
DECIMAL_DIGIT  [0-9]
INTEGER	       {DECIMAL_DIGIT}+
FIXED	       ({DECIMAL_DIGIT}+"."{DECIMAL_DIGIT}*)|("."{DECIMAL_DIGIT}+)
REAL           ({FIXED}|{INTEGER})([eE]([-+]?)[0-9]+)?

-- Double-quoted string:

STRING         \"(([^\"\n]|\\\")*)*\"

%% 

"AND"       { yylval.C := '&'; return AND_TOKEN; }
"NOT"       { yylval.C := '!'; return NOT_TOKEN; }
"OR"        { yylval.C := '|'; return OR_TOKEN; }
"IS"        { yylval.C := 'I'; return IS_TOKEN; }
"KNOWN"     { yylval.C := 'U'; return KNOWN_TOKEN; }
"UNKNOWN"   { yylval.C := '?'; return UNKNOWN_TOKEN; }
"CONTAINS"  { yylval.C := 'C'; return CONTAINS_TOKEN; }
"STARTS"    { yylval.C := 'S'; return STARTS_TOKEN; }
"ENDS"      { yylval.C := 'E'; return ENDS_TOKEN; }
"WITH"      { yylval.C := 'W'; return WITH_TOKEN; }
"LENGTH"    { yylval.C := 'L'; return LENGTH_TOKEN; }
"HAS"       { yylval.C := 'H'; return HAS_TOKEN; }
"ALL"       { yylval.C := 'A'; return ALL_TOKEN; }
"ONLY"      { yylval.C := 'O'; return ONLY_TOKEN; }
"ANY"       { yylval.C := 'N'; return ANY_TOKEN; }

"TRUE"      { yylval.C := 'T'; return TRUE_TOKEN; }
"FALSE"     { yylval.C := 'F'; return FALSE_TOKEN; }
            
[A-Z]+      {
              yylval.S := To_Unbounded_String (filter_lexer_dfa.yytext);
              Put_Line (">>> Token: KEYWORD_TOKEN, """ & To_String (yylval.S) & """");
              return KEYWORD_TOKEN;
            }
[a-z_]+     {
              yylval.S := To_Unbounded_String (filter_lexer_dfa.yytext);
              Put_Line (">>> Token: IDENTIFIER_TOKEN, """ & To_String (yylval.S) & """");
              return IDENTIFIER_TOKEN;
            }
[-+]?{REAL} {
              yylval.N := Float'Value (filter_lexer_dfa.yytext);
              Put_Line (">>> Token: NUMBER_TOKEN, """ &
              filter_lexer_dfa.yytext & """" & " (" & yylval.N'Image & ")");
              return NUMBER_TOKEN;
            }
{STRING}    {
              yylval.S := To_Unbounded_String (yytext (yytext'First+1 .. yytext'Last-1));
              return STRING_TOKEN;
            }
"("         { yylval.C := filter_lexer_dfa.yytext(1); return '('; }
")"         { yylval.C := filter_lexer_dfa.yytext(1); return ')'; }
"+"         { yylval.C := filter_lexer_dfa.yytext(1); return '+'; }
"="         { yylval.C := filter_lexer_dfa.yytext(1); return '='; }
">"         { yylval.C := filter_lexer_dfa.yytext(1); return '>'; }
"<"         { yylval.C := filter_lexer_dfa.yytext(1); return '<'; }
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
