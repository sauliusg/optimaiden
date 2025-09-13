{
   subtype YYSType is YYSType_Definition.YYSType;
}
%token <<[^\x00-\x7F]>>
%token FF -- <<\f>>
%token NL -- <<\n>>
%token CR -- <<\r>>
%token HT -- <<\t>>
%token VT -- <<\v>>

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
FuzzyStringOpRhs : CONTAINS Value | STARTS optional__WITH Value | ENDS optional__WITH_1 Value
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
AND : 'AND' optional__Spaces
;
NOT : 'NOT' optional__Spaces
;
OR : 'OR' optional__Spaces
;
IS : 'IS' optional__Spaces
;
KNOWN : 'KNOWN' optional__Spaces
;
UNKNOWN : 'UNKNOWN' optional__Spaces
;
CONTAINS : 'CONTAINS' optional__Spaces
;
STARTS : 'STARTS' optional__Spaces
;
ENDS : 'ENDS' optional__Spaces
;
WITH : 'WITH' optional__Spaces
;
LENGTH : 'LENGTH' optional__Spaces
;
HAS : 'HAS' optional__Spaces
;
ALL : 'ALL' optional__Spaces
;
ONLY : 'ONLY' optional__Spaces
;
ANY : 'ANY' optional__Spaces
;
Operator : grouped__EqualityOperators
;
EqualityOperator : optional__terminal '=' optional__Spaces
;
RelativeComparisonOperator : grouped__terminals optional__terminal_1 optional__Spaces
;
TRUE : 'TRUE' optional__Spaces
;
FALSE : 'FALSE' optional__Spaces
;
Identifier : LowercaseLetter zero_or_more__LowercaseLetters optional__Spaces
;
Letter : UppercaseLetter | LowercaseLetter
;
UppercaseLetter : 'A' | 'B' | 'C' | 'D' | 'E' | 'F' | 'G' | 'H' | 'I' | 'J' | 'K' | 'L' | 'M' | 'N' | 'O' | 'P' | 'Q' | 'R' | 'S' | 'T' | 'U' | 'V' | 'W' | 'X' | 'Y' | 'Z'
;
LowercaseLetter : 'a' | 'b' | 'c' | 'd' | 'e' | 'f' | 'g' | 'h' | 'i' | 'j' | 'k' | 'l' | 'm' | 'n' | 'o' | 'p' | 'q' | 'r' | 's' | 't' | 'u' | 'v' | 'w' | 'x' | 'y' | 'z' | '_'
;
String : '"' zero_or_more__EscapedChars '"' optional__Spaces
;
EscapedChar : UnescapedChar | '\' '"' | '\' '\'
;
UnescapedChar : Letter | Digit | Space | Punctuator | UnicodeHighChar
;
Punctuator : '!' | '#' | '$' | '%' | '&' | ''' | '(' | ')' | '*' | '+' | ',' | '-' | '.' | '/' | ':' | ';' | '<' | '=' | '>' | '?' | '@' | '[' | ']' | '^' | '`' | '{' | '|' | '}' | '~'
;
Number : optional__Sign grouped__Digits optional__Exponent optional__Spaces
;
Exponent : grouped__terminals_1 optional__Sign_1 Digits
;
Sign : '+' | '-'
;
Digits : Digit zero_or_more__Digits
;
Digit : '0' | '1' | '2' | '3' | '4' | '5' | '6' | '7' | '8' | '9'
;
tab : SPECIAL_0
;
nl : SPECIAL_1
;
cr : SPECIAL_2
;
vt : SPECIAL_3
;
ff : SPECIAL_4
;
Space : ' ' | tab | nl | cr | vt | ff
;
Spaces : Space zero_or_more__Spaces
;
UnicodeHighChar : SPECIAL_5
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
grouped__Digits : Digits optional__terminal_2 | '.' Digits
;
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
optional__WITH_1 : WITH | 
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
zero_or_more__Spaces : Space | zero_or_more__Spaces Space | 
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
optional__terminal_2 : '.' optional__Digits | 
;
grouped__Values_1 : Value | EqualityOperator Value | RelativeComparisonOperator OrderedValue | FuzzyStringOpRhs
;
-----------------------------


-----------------------------
optional__Digits : Digits | 
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
