
DECIMAL_DIGIT  [0-9]
INTEGER	       {DECIMAL_DIGIT}+
FIXED	       ({DECIMAL_DIGIT}+"."{DECIMAL_DIGIT}*)|("."{DECIMAL_DIGIT}+)
REAL           ({FIXED}|{INTEGER})([eE]([-+]?)[0-9]+)?
IDENTIFIER     [_a-z][_a-z0-9]*

-- Double-quoted string:

STRING         \"(([^\"\n]|\\\")*)*\"

%% 

"AND"        { yylval := (Kind => YY_CHR, C => '&'); return AND_TOKEN; }
"NOT"        { yylval := (Kind => YY_CHR, C => '!'); return NOT_TOKEN; }
"OR"         { yylval := (Kind => YY_CHR, C => '|'); return OR_TOKEN; }
"IS"         { yylval := (Kind => YY_CHR, C => 'I'); return IS_TOKEN; }
"KNOWN"      { yylval := (Kind => YY_CHR, C => 'U'); return KNOWN_TOKEN; }
"UNKNOWN"    { yylval := (Kind => YY_CHR, C => '?'); return UNKNOWN_TOKEN; }
"CONTAINS"   { yylval := (Kind => YY_CHR, C => 'C'); return CONTAINS_TOKEN; }
"STARTS"     { yylval := (Kind => YY_CHR, C => 'S'); return STARTS_TOKEN; }
"ENDS"       { yylval := (Kind => YY_CHR, C => 'E'); return ENDS_TOKEN; }
"WITH"       { yylval := (Kind => YY_CHR, C => 'W'); return WITH_TOKEN; }
"LENGTH"     { yylval := (Kind => YY_CHR, C => 'L'); return LENGTH_TOKEN; }
"HAS"        { yylval := (Kind => YY_CHR, C => 'H'); return HAS_TOKEN; }
"ALL"        { yylval := (Kind => YY_CHR, C => 'A'); return ALL_TOKEN; }
"ONLY"       { yylval := (Kind => YY_CHR, C => 'O'); return ONLY_TOKEN; }
"ANY"        { yylval := (Kind => YY_CHR, C => 'N'); return ANY_TOKEN; }

"TRUE"       { yylval := (Kind => YY_CHR, C => 'T'); return TRUE_TOKEN; }
"FALSE"      { yylval := (Kind => YY_CHR, C => 'F'); return FALSE_TOKEN; }
            
[A-Z]+       {
               yylval :=
                   (
                    Kind => YY_STR,
                    S => To_Unbounded_String (filter_lexer_dfa.yytext)
                   );
               return KEYWORD_TOKEN;
             }
{IDENTIFIER} {
               yylval :=
                   (
                    Kind => YY_STR,
                    S => To_Unbounded_String (filter_lexer_dfa.yytext)
                   );
                return IDENTIFIER_TOKEN;
             }
[-+]?{REAL}  {
               yylval :=
                   (
                    Kind => YY_NUM,
                    N => Float'Value (filter_lexer_dfa.yytext)
                   );
               return NUMBER_TOKEN;
             }
{STRING}     {
               yylval :=
                   (
                    Kind => YY_STR,
                     S => To_Unbounded_String (yytext (yytext'First + 1 ..
                                                       yytext'Last  - 1))
                   );
               return STRING_TOKEN;
             }

\n           { return LF_TOKEN; }
\r           { return CR_TOKEN; }
\t           { return HT_TOKEN; }
\v           { return VT_TOKEN; }
\f           { return FF_TOKEN; }

-- The remaining single character tokens are processed in Ada so that
-- we get compiler error if some character is not covered:

.            {
              declare
                  BS : constant Character := '\';
                  C  : Character := filter_lexer_dfa.yytext(1);
              begin
                 yylval := (Kind => YY_CHR, C => C);
                 case C is
                     when ' ' => return Token'(' ');
                     when '(' => return Token'('(');
                     when ')' => return Token'(')');
                     when '.' => return Token'('.');
                     when ',' => return Token'(',');
                     when ':' => return Token'(':');
                     when '=' => return Token'('=');
                     when '<' => return Token'('<');
                     when '>' => return Token'('>');
                     when '!' => return Token'('!');
             
                     -- We list all remaining characters explicitly
                     -- so that if a new token is introduced into the grammar,
                     -- or removed from it, we get an Ada compiler
                     -- error:
             
                     when ASCII.NUL .. ASCII.US |
                          '#' .. ''' |
                          '*' .. '+' |
                          '-'        |
                          '/'        |
                          ';'        |
                          '?' .. '@' |
                          '['        |
                          ']' .. '^' |
                          '`'        |
                          '{' .. '~' |
                          character'val(127) .. character'val(255) |
                          'A' .. 'Z' | 'a' .. 'z' | '0' .. '9' |
                          BS | '_' | '"'
                         => return ERROR;
                 end case;
              end;
}

%%

with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;
with filter_tokens; use filter_tokens;
with yystype_definition; use yystype_definition;

package filter_lexer is
  function YYLex return Token;
end;

package body filter_lexer is

##

end filter_lexer;
