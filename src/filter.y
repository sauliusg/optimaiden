{
   subtype YYSType is YYSType_Definition.YYSType;
}
%token <<[^\x00-\x7F]>>
%token <<\f>>
%token <<\n>>
%token <<\r>>
%token <<\t>>
%token <<\v>>
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
OpeningBrace : '(' optional__Spaces_1
;
ClosingBrace : ')' optional__Spaces_2
;
Dot : '.' optional__Spaces_3
;
Comma : ',' optional__Spaces_4
;
Colon : ':' optional__Spaces_5
;
AND : 'AND' optional__Spaces_6
;
NOT : 'NOT' optional__Spaces_7
;
OR : 'OR' optional__Spaces_8
;
IS : 'IS' optional__Spaces_9
;
KNOWN : 'KNOWN' optional__Spaces_10
;
UNKNOWN : 'UNKNOWN' optional__Spaces_11
;
CONTAINS : 'CONTAINS' optional__Spaces_12
;
STARTS : 'STARTS' optional__Spaces_13
;
ENDS : 'ENDS' optional__Spaces_14
;
WITH : 'WITH' optional__Spaces_15
;
LENGTH : 'LENGTH' optional__Spaces_16
;
HAS : 'HAS' optional__Spaces_17
;
ALL : 'ALL' optional__Spaces_18
;
ONLY : 'ONLY' optional__Spaces_19
;
ANY : 'ANY' optional__Spaces_20
;
Operator : grouped__EqualityOperators
;
EqualityOperator : optional__terminal '=' optional__Spaces_21
;
RelativeComparisonOperator : grouped__terminals optional__terminal_1 optional__Spaces_22
;
TRUE : 'TRUE' optional__Spaces_23
;
FALSE : 'FALSE' optional__Spaces_24
;
Identifier : LowercaseLetter zero_or_more__LowercaseLetters optional__Spaces_25
;
Letter : UppercaseLetter | LowercaseLetter
;
UppercaseLetter : 'A' | 'B' | 'C' | 'D' | 'E' | 'F' | 'G' | 'H' | 'I' | 'J' | 'K' | 'L' | 'M' | 'N' | 'O' | 'P' | 'Q' | 'R' | 'S' | 'T' | 'U' | 'V' | 'W' | 'X' | 'Y' | 'Z'
;
LowercaseLetter : 'a' | 'b' | 'c' | 'd' | 'e' | 'f' | 'g' | 'h' | 'i' | 'j' | 'k' | 'l' | 'm' | 'n' | 'o' | 'p' | 'q' | 'r' | 's' | 't' | 'u' | 'v' | 'w' | 'x' | 'y' | 'z' | '_'
;
String : '"' zero_or_more__EscapedChars '"' optional__Spaces_26
;
EscapedChar : UnescapedChar | '\' '"' | '\' '\'
;
UnescapedChar : Letter | Digit | Space | Punctuator | UnicodeHighChar
;
Punctuator : '!' | '#' | '$' | '%' | '&' | ''' | '(' | ')' | '*' | '+' | ',' | '-' | '.' | '/' | ':' | ';' | '<' | '=' | '>' | '?' | '@' | '[' | ']' | '^' | '`' | '{' | '|' | '}' | '~'
;
Number : optional__Sign grouped__Digits optional__Exponent optional__Spaces_27
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
optional__Spaces_1 : Spaces | 
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
optional__Spaces_19 : Spaces | 
;
optional__Spaces_17 : Spaces | 
;
optional__AND : AND ExpressionClause | 
;
optional__Spaces_18 : Spaces | 
;
grouped__KNOWNs : KNOWN | UNKNOWN
;
zero_or_more__Commas_1 : Comma ValueZip | zero_or_more__Commas_1 Comma ValueZip | 
;
grouped__UnorderedConstants : UnorderedConstant | OrderedValue
;
optional__NOT : NOT | 
;
optional__Spaces_11 : Spaces | 
;
grouped__OrderedConstants : OrderedConstant | Property
;
optional__Spaces_12 : Spaces | 
;
zero_or_more__Dots : Dot Identifier | zero_or_more__Dots Dot Identifier | 
;
optional__Spaces_10 : Spaces | 
;
optional__Spaces_15 : Spaces | 
;
optional__Spaces_16 : Spaces | 
;
optional__Spaces_13 : Spaces | 
;
zero_or_more__Spaces : Space | zero_or_more__Spaces Space | 
;
optional__Spaces_14 : Spaces | 
;
grouped__Comparisons : Comparison | OpeningBrace Expression ClosingBrace
;
grouped__ValueEqRhs : ValueEqRhs | ValueRelCompRhs
;
optional__Sign : Sign | 
;
grouped__EqualityOperators : EqualityOperator | RelativeComparisonOperator
;
optional__Spaces_8 : Spaces | 
;
optional__Spaces_9 : Spaces | 
;
optional__Spaces_6 : Spaces | 
;
optional__Spaces_7 : Spaces | 
;
optional__Spaces_4 : Spaces | 
;
optional__Spaces_5 : Spaces | 
;
optional__terminal_1 : '=' | 
;
optional__Spaces_2 : Spaces | 
;
optional__Spaces_3 : Spaces | 
;
optional__Spaces_22 : Spaces | 
;
optional__Spaces_23 : Spaces | 
;
grouped__terminals_1 : 'e' | 'E'
;
optional__WITH : WITH | 
;
optional__Spaces_20 : Spaces | 
;
optional__Spaces_21 : Spaces | 
;
optional__Spaces_26 : Spaces | 
;
optional__Spaces_27 : Spaces | 
;
optional__Spaces_24 : Spaces | 
;
optional__Spaces : Spaces | 
;
optional__Spaces_25 : Spaces | 
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
