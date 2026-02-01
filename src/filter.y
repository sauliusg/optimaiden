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
{
    Put_Line (Image ($2));
}
;
OrderedConstant
: String
{
 $$ := $1;
}
| Number
{
 $$ := $1;
}
;
UnorderedConstant : grouped__TRUEs
{
 $$ := $1;
}
;
Value : grouped__UnorderedConstants
{
 $$ := $1;
}
;
OrderedValue : grouped__OrderedConstants
{
 $$ := $1;
}
;
ValueListEntry : grouped__Values
{
 $$ := $1;
}
;
ValueList : ValueListEntry zero_or_more__Commas
{
 $$ := New_AST (',', $1, $2);
}
;
ValueZip : ValueListEntry Colon ValueListEntry zero_or_more__Colons
{
 $$ := New_AST (':', $1, New_AST (':', $3, $4));
}
;
ValueZipList : ValueZip zero_or_more__Commas_1
{
 $$ := New_AST (',', $1, $2);
}
;
Expression : ExpressionClause optional__OR
{
 if Is_Null ($2) then
     $$ := $1;
 else
     $$ := New_AST ('|', $1, Left ($2));
 end if;
}
;
ExpressionClause : ExpressionPhrase optional__AND
{
 if Is_Null ($2) then
    $$ := $1;
 else
    $$ := New_AST ('&', $1, Left ($2));
 end if;
}
;
ExpressionPhrase : optional__NOT grouped__Comparisons
{
 if Is_Null ($1) then
     $$ := $2;
 else
     $$ := new_AST (Operator ($1), $2);
 end if;
}
;
Comparison
: ConstantFirstComparison
{
 $$ := $1;
}
| PropertyFirstComparison
{
 $$ := $1;
}
;
ConstantFirstComparison
: OrderedConstant ValueOpRhs
{
 $$ := New_AST (Operator ($2), $1, Left ($2));
}
| UnorderedConstant ValueEqRhs
{
 $$ := New_AST (Operator ($2), $1, Left ($2));
}
;
PropertyFirstComparison : Property optional__ValueOpRhs
{
 if Is_Null ($2) then
     $$ := $1;
 else
     if Kind ($2) = OPERATOR and then Is_Null (Right ($2)) then
         $$ := New_AST (Operator ($2), $1, Left ($2));
     else
         $$ := New_AST (Operator ($2), $1, $2);
     end if;
 end if;
}
;
ValueOpRhs : grouped__ValueEqRhs
{
 $$ := $1;
}
;
ValueEqRhs : EqualityOperator Value
{
 $$ := new_AST (Operator ($1), $2);
}
;
ValueRelCompRhs : RelativeComparisonOperator OrderedValue
{
 $$ := new_AST (Operator ($1), $2);
}
;
KnownOpRhs : IS grouped__KNOWNs
{
 $$ := $2;
}
;
FuzzyStringOpRhs
: CONTAINS Value | STARTS optional__WITH Value | ENDS optional__WITH Value
;
SetOpRhs : HAS grouped__nones
{
 $$ := New_AST (OP_HAS_ALL, $2);
}
;
SetZipOpRhs : PropertyZipAddon HAS grouped__ValueZips
{
 $$ := New_AST (OP_HAS_ALL, $1, $3);
}
;
PropertyZipAddon : Colon Property zero_or_more__Colons_1
{
 $$ := New_AST (':', $2, $3); -- <<< HERE
}
;
LengthOpRhs : LENGTH optional__Operator Value
{
 $$ := New_AST ('l', $3);
}
;
Property : Identifier
{
 $$ := $1;
}
| Property Dot Identifier
{
 $$ := new_AST ('.', $1, $3);
}
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
{
 $$ := $1;
}
;
EqualityOperator : optional__exclamation_mark '=' optional__Spaces
{
    if Is_NULL ($1) then
        $$ := New_Ast ('=', Null_AST);
    else
        $$ := New_Ast ('!', Null_AST);
    end if;
}
;
RelativeComparisonOperator : less_or_more optional__equals optional__Spaces
{
 if Is_NULL ($2) then
     $$ := New_AST (Operator ($1), Null_AST);
 else
     if Operator ($1) = '<' then
         $$ := New_AST ('L', Null_AST);
     else
         $$ := New_AST ('G', Null_AST);
     end if;
 end if;
}
;
TRUE : TRUE_TOKEN optional__Spaces
;
FALSE : FALSE_TOKEN optional__Spaces
;
Identifier : IDENTIFIER_TOKEN optional__Spaces
{
 $$ := $1;
}
;
String : STRING_TOKEN optional__Spaces
{
 $$ := $1;
}
;
Number : NUMBER_TOKEN optional__Spaces
{
 $$ := $1;
}
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
optional__OR :
OR Expression
{
 $$ := New_AST ('|', $2);
}
| -- empty
{
 $$ := Null_AST;
}
;
grouped__ValueZips
: ValueZip
{
 $$ := $1;
}
| ONLY ValueZipList
{
 $$ := New_AST ('o', $2);
}
| ALL ValueZipList
{
 $$ := New_AST ('a', $2);
}
| ANY ValueZipList
{
 $$ := New_AST ('n', $2);
}
;
less_or_more
: '<'
{
 $$ := New_AST ('<');
}
| '>'
{
 $$ := New_AST ('>');
}
;
optional__Operator :
Operator
{
 $$ := $1;
}
| -- empty
{
 $$ := Null_AST;
}
;
optional__exclamation_mark : '!'
{
 $$ := New_AST ('!');
}
| -- empty
{
 $$ := Null_AST;
}
;
grouped__Values :
Value
{
 $$ := $1;
}
| ValueEqRhs
{
 $$ := $1;
}
| ValueRelCompRhs
{
 $$ := $1;
}
| FuzzyStringOpRhs
{
 $$ := $1;
}
;
zero_or_more__Commas : Comma ValueListEntry
{
 $$ := New_AST (',', $2);
}
| zero_or_more__Commas Comma ValueListEntry
{
 $$ := New_AST (',', $1, $3);
}
| -- empty
{
 $$ := Null_AST;
}
;
optional__ValueOpRhs
: ValueOpRhs
{
 $$ := $1;
}
| KnownOpRhs
{
 $$ := $1;
}
| FuzzyStringOpRhs
{
 $$ := $1;
}
| SetOpRhs
{
 $$ := $1;
}
| SetZipOpRhs
{
 $$ := $1;
}
| LengthOpRhs
{
 $$ := $1;
}
| -- empty:
{
 $$ := Null_AST;
}
;
grouped__TRUEs
: TRUE
{
 $$ := New_AST (True);
}
| FALSE
{
 $$ := New_AST (False);
}
;
grouped__nones :
grouped__Values_1
{
 $$ := $1;
}
| ALL ValueList
{
 $$ := New_AST ('A', $2);
}
| ANY ValueList
{
 $$ := New_AST ('Y', $2);
}
| ONLY ValueList
{
 $$ := New_AST ('O', $2);
}
;
zero_or_more__Colons_1
: Colon Property
{
 $$ := New_AST (':', $2);    
}
| zero_or_more__Colons_1 Colon Property
{
 $$ := New_AST (':', $1, $2);
}
| -- empty
{
 $$ := Null_AST;
}
;
zero_or_more__Colons
: Colon ValueListEntry
{
 $$ := New_AST (':', $2);
}
| zero_or_more__Colons Colon ValueListEntry
{
 $$ := New_AST (':', $1, $2);
}
| -- empty
{
 $$ := Null_AST;
}
;
optional__AND :
AND ExpressionClause
{
 $$ := New_AST ('&', $2);
}
|
{
 $$ := Null_AST;
}
;
grouped__KNOWNs :
KNOWN
{
 $$ := New_AST ('K', Null_AST);
}
| UNKNOWN
{
 $$ := New_Ast ('!', New_AST ('K', Null_AST));
}
;
zero_or_more__Commas_1 :
Comma ValueZip
{
 $$ := New_AST (',', $2);
}
| zero_or_more__Commas_1 Comma ValueZip
{
 $$ := New_AST (',', $1, $3);
}
|
{
 $$ := Null_AST;
}
;
grouped__UnorderedConstants :
UnorderedConstant
{
 $$ := $1;
}
| OrderedValue
{
 $$ := $1;
}
;
optional__NOT :
{
 $$ := Null_AST;
}
| NOT
{
 $$ := New_AST ('N', Null_AST);
}
;
grouped__OrderedConstants :
OrderedConstant
{
 $$ := $1;
}
| Property
{
 $$ := $1;
}
;
grouped__Comparisons :
Comparison
{
 $$ := $1;
}
|
OpeningBrace Expression ClosingBrace
{
 $$ := $2;
}
;
grouped__ValueEqRhs :
ValueEqRhs
{
 $$ := $1;
}
| ValueRelCompRhs
{
 $$ := $1;
}
;
grouped__EqualityOperators :
EqualityOperator
{
 $$ := $1;
}
| RelativeComparisonOperator
{
 $$ := $1;
}
;
optional__equals
: '='
{
 $$ := New_AST ('=');
}
|
{
 $$ := Null_AST;
}
;
optional__WITH : WITH | 
;
optional__Spaces : Spaces | 
;

-----------------------------
grouped__Values_1 : Value
| EqualityOperator Value
{
 $$ := New_Ast ('@', $2);
}
| RelativeComparisonOperator OrderedValue
{
 $$ := New_Ast ('?', $2);
}
| FuzzyStringOpRhs
{
 $$ := $1;
}
;
-----------------------------

%%
package Filter is
procedure yyparse;
end Filter;

with Filter_Goto, Filter_Tokens, Filter_Shift_Reduce, Filter_AST;
with Ada.Strings.Unbounded;
with YYStype_Definition;

use Filter_Goto, Filter_Tokens, Filter_Shift_Reduce, Filter_AST;
use Ada.Strings.Unbounded;
use YYStype_Definition;

package body Filter is

    Parsed_Expression : Filter_AST.AST_Type;

##

end Filter;
