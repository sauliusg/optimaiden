{
   subtype YYSType is YYSType_Definition.YYSType;
}
%token UNICODE_CHARACTER -- <<[^\x00-\x7F]>>
%token FF_TOKEN -- <<\f>>
%token LF_TOKEN -- <<\n>>
%token CR_TOKEN -- <<\r>>
%token HT_TOKEN -- <<\t>>
%token VT_TOKEN -- <<\v>>

%token AND_TOKEN
%token NOT_TOKEN
%token OR_TOKEN
%token IS_TOKEN
%token KNOWN_TOKEN
%token UNKNOWN_TOKEN
%token CONTAINS_TOKEN
%token STARTS_TOKEN
%token ENDS_TOKEN
%token WITH_TOKEN
%token LENGTH_TOKEN
%token HAS_TOKEN
%token ALL_TOKEN
%token ONLY_TOKEN
%token ANY_TOKEN

%token TRUE_TOKEN
%token FALSE_TOKEN

%token IDENTIFIER_TOKEN
%token NUMBER_TOKEN
%token STRING_TOKEN
%token KEYWORD_TOKEN

%start Filter

%%

Filter : optional__Spaces Expression
;
OrderedConstant : String | Number
;
UnorderedConstant : grouped__TRUEs
;
Value : grouped__UnorderedConstants
;
OrderedValue : grouped__OrderedConstants
;
ValueListEntry : grouped__Values
;
ValueList : ValueListEntry zero_or_more__Commas
;
ValueZip : ValueListEntry Colon ValueListEntry zero_or_more__Colons
;
ValueZipList : ValueZip zero_or_more__Commas_1
;
Expression : ExpressionClause optional__OR
;
ExpressionClause : ExpressionPhrase optional__AND
;
ExpressionPhrase : optional__NOT grouped__Comparisons
;
Comparison : ConstantFirstComparison | PropertyFirstComparison
;
ConstantFirstComparison : grouped__OrderedConstants_1
;
PropertyFirstComparison : Property optional__ValueOpRhs
;
ValueOpRhs : grouped__ValueEqRhs
;
ValueEqRhs : EqualityOperator Value
;
ValueRelCompRhs : RelativeComparisonOperator OrderedValue
;
KnownOpRhs : IS grouped__KNOWNs
;
FuzzyStringOpRhs : CONTAINS Value | STARTS optional__WITH Value | ENDS optional__WITH Value
;
SetOpRhs : HAS grouped__nones
;
SetZipOpRhs : PropertyZipAddon HAS grouped__ValueZips
;
PropertyZipAddon : Colon Property zero_or_more__Colons_1
;
LengthOpRhs : LENGTH optional__Operator Value
;
Property : Identifier zero_or_more__Dots
;
OpeningBrace : '(' optional__Spaces
;
ClosingBrace : ')' optional__Spaces
;
Dot : '.' optional__Spaces
;
Comma : ',' optional__Spaces
;
Colon : ':' optional__Spaces
;
AND : AND_TOKEN optional__Spaces
;
NOT : NOT_TOKEN optional__Spaces
;
OR : OR_TOKEN optional__Spaces
;
IS : IS_TOKEN optional__Spaces
;
KNOWN : KNOWN_TOKEN optional__Spaces
;
UNKNOWN : UNKNOWN_TOKEN optional__Spaces
;
CONTAINS : CONTAINS_TOKEN optional__Spaces
;
STARTS : STARTS_TOKEN optional__Spaces
;
ENDS : ENDS_TOKEN optional__Spaces
;
WITH : WITH_TOKEN optional__Spaces
;
LENGTH : LENGTH_TOKEN optional__Spaces
;
HAS : HAS_TOKEN optional__Spaces
;
ALL : ALL_TOKEN optional__Spaces
;
ONLY : ONLY_TOKEN optional__Spaces
;
ANY : ANY_TOKEN optional__Spaces
;
Operator : grouped__EqualityOperators
;
EqualityOperator : optional__terminal '=' optional__Spaces
{
    null;
}
;
RelativeComparisonOperator : grouped__terminals optional__terminal_1 optional__Spaces
;
TRUE : TRUE_TOKEN optional__Spaces
;
FALSE : FALSE_TOKEN optional__Spaces
;
-- Identifier : LowercaseLetter zero_or_more__LowercaseLetters optional__Spaces
Identifier : IDENTIFIER_TOKEN optional__Spaces
;
Letter : UppercaseLetter | LowercaseLetter
;
UppercaseLetter : 'A' | 'B' | 'C' | 'D' | 'E' | 'F' | 'G' | 'H' | 'I' | 'J' | 'K' | 'L' | 'M' | 'N' | 'O' | 'P' | 'Q' | 'R' | 'S' | 'T' | 'U' | 'V' | 'W' | 'X' | 'Y' | 'Z'
;
LowercaseLetter : 'a' | 'b' | 'c' | 'd' | 'e' | 'f' | 'g' | 'h' | 'i' | 'j' | 'k' | 'l' | 'm' | 'n' | 'o' | 'p' | 'q' | 'r' | 's' | 't' | 'u' | 'v' | 'w' | 'x' | 'y' | 'z' | '_'
;
-- String : '"' zero_or_more__EscapedChars '"' optional__Spaces
String : STRING_TOKEN optional__Spaces
;
EscapedChar : UnescapedChar | '\' '"' | '\' '\'
;
UnescapedChar : Letter | Digit | Space | Punctuator | UnicodeHighChar
;
Punctuator : '!' | '#' | '$' | '%' | '&' | ''' | '(' | ')' | '*' | '+' | ',' | '-' | '.' | '/' | ':' | ';' | '<' | '=' | '>' | '?' | '@' | '[' | ']' | '^' | '`' | '{' | '|' | '}' | '~'
;
-- Number : optional__Sign grouped__Digits optional__Exponent optional__Spaces
Number : NUMBER_TOKEN optional__Spaces
{
    null;
}
;
Exponent : grouped__terminals_1 optional__Sign_1 Digits
;
Sign : '+' | '-'
;
Digits : Digit zero_or_more__Digits
;
Digit : '0' | '1' | '2' | '3' | '4' | '5' | '6' | '7' | '8' | '9'
;
tab : HT_TOKEN
;
nl : LF_TOKEN
;
cr : CR_TOKEN
;
vt : VT_TOKEN
;
ff : FF_TOKEN
;
Space : ' ' | tab | nl | cr | vt | ff
;
Spaces : Space | Spaces Space
;
UnicodeHighChar : UNICODE_CHARACTER
;

-----------------------------
optional__OR : OR Expression | 
;
grouped__ValueZips : ValueZip | ONLY ValueZipList | ALL ValueZipList | ANY ValueZipList
;
zero_or_more__Colons_1 : Colon Property | zero_or_more__Colons_1 Colon Property | 
;
grouped__OrderedConstants_1 : OrderedConstant ValueOpRhs | UnorderedConstant ValueEqRhs
;
grouped__terminals : '<' | '>'
;
optional__Operator : Operator | 
;
optional__Exponent : Exponent | 
;
-- grouped__Digits : Digits optional__terminal_2 | '.' Digits
-- ;
optional__terminal : '!' | 
;
grouped__Values : Value | ValueEqRhs | ValueRelCompRhs | FuzzyStringOpRhs
;
zero_or_more__Commas : Comma ValueListEntry | zero_or_more__Commas Comma ValueListEntry | 
;
optional__ValueOpRhs : ValueOpRhs | KnownOpRhs | FuzzyStringOpRhs | SetOpRhs | SetZipOpRhs | LengthOpRhs | 
;
optional__Sign_1 : Sign | 
;
zero_or_more__Digits : Digit | zero_or_more__Digits Digit | 
;
grouped__TRUEs : TRUE | FALSE
;
zero_or_more__EscapedChars : EscapedChar | zero_or_more__EscapedChars EscapedChar | 
;
grouped__nones : grouped__Values_1 | ALL ValueList | ANY ValueList | ONLY ValueList
;
zero_or_more__LowercaseLetters : LowercaseLetter | Digit | zero_or_more__LowercaseLetters LowercaseLetter | Digit | 
;
zero_or_more__Colons : Colon ValueListEntry | zero_or_more__Colons Colon ValueListEntry | 
;
optional__AND : AND ExpressionClause | 
;
grouped__KNOWNs : KNOWN | UNKNOWN
;
zero_or_more__Commas_1 : Comma ValueZip | zero_or_more__Commas_1 Comma ValueZip | 
;
grouped__UnorderedConstants : UnorderedConstant | OrderedValue
;
optional__NOT : NOT | 
;
grouped__OrderedConstants : OrderedConstant | Property
;
zero_or_more__Dots : Dot Identifier | zero_or_more__Dots Dot Identifier | 
;
grouped__Comparisons : Comparison | OpeningBrace Expression ClosingBrace
;
grouped__ValueEqRhs : ValueEqRhs | ValueRelCompRhs
;
optional__Sign : Sign | 
;
grouped__EqualityOperators : EqualityOperator | RelativeComparisonOperator
;
optional__terminal_1 : '=' | 
;
grouped__terminals_1 : 'e' | 'E'
;
optional__WITH : WITH | 
;
optional__Spaces : Spaces | 
;
-----------------------------


-----------------------------
grouped__Values_1 : Value | EqualityOperator Value | RelativeComparisonOperator OrderedValue | FuzzyStringOpRhs
;
-----------------------------

%%
package Filter is
procedure yyparse;
end Filter;

with Filter_Goto, Filter_Tokens, Filter_Shift_Reduce;
use Filter_Goto, Filter_Tokens, Filter_Shift_Reduce;
package body Filter is
##
end Filter;
