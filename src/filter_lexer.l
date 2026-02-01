
DECIMAL_DIGIT  [0-9]
INTEGER	       {DECIMAL_DIGIT}+
FIXED	       ({DECIMAL_DIGIT}+"."{DECIMAL_DIGIT}*)|("."{DECIMAL_DIGIT}+)
REAL           ({FIXED}|{INTEGER})([eE]([-+]?)[0-9]+)?
IDENTIFIER     [_a-z][_a-z0-9]*

-- Double-quoted string:

STRING         \"(([^\"\n]|\\\")*)*\"

%% 

"AND"        { yylval := Null_AST; return AND_TOKEN; }
"NOT"        { yylval := Null_AST; return NOT_TOKEN; }
"OR"         { yylval := Null_AST; return OR_TOKEN; }
"IS"         { yylval := Null_AST; return IS_TOKEN; }
"KNOWN"      { yylval := Null_AST; return KNOWN_TOKEN; }
"UNKNOWN"    { yylval := Null_AST; return UNKNOWN_TOKEN; }
"CONTAINS"   { yylval := Null_AST; return CONTAINS_TOKEN; }
"STARTS"     { yylval := Null_AST; return STARTS_TOKEN; }
"ENDS"       { yylval := Null_AST; return ENDS_TOKEN; }
"WITH"       { yylval := Null_AST; return WITH_TOKEN; }
"LENGTH"     { yylval := Null_AST; return LENGTH_TOKEN; }
"HAS"        { yylval := Null_AST; return HAS_TOKEN; }
"ALL"        { yylval := Null_AST; return ALL_TOKEN; }
"ONLY"       { yylval := Null_AST; return ONLY_TOKEN; }
"ANY"        { yylval := Null_AST; return ANY_TOKEN; }

"TRUE"       { yylval := Null_AST; return TRUE_TOKEN; }
"FALSE"      { yylval := Null_AST; return FALSE_TOKEN; }
            
[A-Z]+       {
               yylval := New_AST (filter_lexer_dfa.yytext);
               return KEYWORD_TOKEN;
             }
{IDENTIFIER} {
               yylval := New_AST_Identifier (filter_lexer_dfa.yytext);
               return IDENTIFIER_TOKEN;
             }
[-+]?{REAL}  {
               yylval := New_AST (Float'Value (filter_lexer_dfa.yytext));
               return NUMBER_TOKEN;
             }
{STRING}     {
               yylval := New_AST (yytext (yytext'First + 1 ..
                                          yytext'Last  - 1));
               return STRING_TOKEN;
             }

\n           { yylval := Null_AST; return LF_TOKEN; }
\r           { yylval := Null_AST; return CR_TOKEN; }
\t           { yylval := Null_AST; return HT_TOKEN; }
\v           { yylval := Null_AST; return VT_TOKEN; }
\f           { yylval := Null_AST; return FF_TOKEN; }

-- The remaining single character tokens are processed in Ada so that
-- we get compiler error if some character is not covered:

.            {
              declare
                  BS : constant Character := '\';
                  S  : String := filter_lexer_dfa.yytext(1 .. 1);
              begin
                 yylval := New_AST (S);
                 case S (1) is
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
with Filter_Tokens; use Filter_Tokens;
with YYSType_Definition; use YYSType_Definition;
with Filter_AST; use Filter_AST;

package Filter_Lexer is
  function YYLex return Token;
end;

package body Filter_Lexer is

##

end Filter_Lexer;
