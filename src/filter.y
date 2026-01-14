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
{
 $$.AST := New_AST ('|', $1.AST, Right ($2.AST));
}
;
ExpressionClause : ExpressionPhrase optional__AND
{
 $$.AST := New_AST ('&', $1.AST, Right ($2.AST));
}
;
ExpressionPhrase : optional__NOT grouped__Comparisons
{
 if Is_Null ($1.AST) then
     $$.AST := $2.AST;
 else
     $$.AST := new_AST (Operator ($1.AST), $2.AST);
 end if;
}
;
Comparison : ConstantFirstComparison | PropertyFirstComparison
;
ConstantFirstComparison : OrderedConstant ValueOpRhs
{
 $$.AST := New_AST ('O', $1.AST, $2.AST);
}
| UnorderedConstant ValueEqRhs
{
 $$.AST := New_AST ('U', $1.AST, $2.AST);
}
;
PropertyFirstComparison : Property optional__ValueOpRhs
{
 $$.AST := New_AST (Operator ($2.AST), $1.AST, Right ($2.AST));
}
;
ValueOpRhs : grouped__ValueEqRhs
;
ValueEqRhs : EqualityOperator Value
{
 $$.AST := new_AST (Operator ($1.AST), Null_AST, $2.AST);
}
;
ValueRelCompRhs : RelativeComparisonOperator OrderedValue
{
 $$.AST := new_AST (Operator ($1.AST), Left ($1.AST), $2.AST);
}
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
Property : Identifier
{
 $$ := $1;
}
| Property Dot Identifier
{
 $$.AST := new_AST ('.', $1.AST, $3.AST);
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
;
EqualityOperator : optional__exclamation_mark '=' optional__Spaces
{
    if $1.C = ' ' then
        $$.AST := New_Ast ('=', Null_AST);
    else
        $$.AST := New_Ast ('!', Null_AST);
    end if;
}
;
RelativeComparisonOperator : less_or_more optional__equals optional__Spaces
{
 if $2.C = ' ' then
     $$.AST := New_AST (Operator_Type ($1.C), Null_AST);
 else
     if $1.C = '<' then
         $$.AST := New_AST ('L', Null_AST);
     else
         $$.AST := New_AST ('G', Null_AST);
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
 $$.AST := New_AST_Identifier ($1.S);
}
;
String : STRING_TOKEN optional__Spaces
{
 $$.AST := New_AST ($1.S);
}
;
Number : NUMBER_TOKEN optional__Spaces
{
 $$.AST := New_AST ($1.N);
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
optional__OR : OR Expression | 
;
grouped__ValueZips : ValueZip | ONLY ValueZipList | ALL ValueZipList | ANY ValueZipList
;
zero_or_more__Colons_1 : Colon Property | zero_or_more__Colons_1 Colon Property | 
;
less_or_more : '<'
{
 $$.C := '<';
}
| '>'
{
 $$.C := '>';
}
;
optional__Operator : Operator | 
;
optional__exclamation_mark : '!'
{
 $$.C := '!';
}
|
{
 $$.C := ' ';
}
;
grouped__Values : Value | ValueEqRhs | ValueRelCompRhs | FuzzyStringOpRhs
;
zero_or_more__Commas : Comma ValueListEntry | zero_or_more__Commas Comma ValueListEntry | 
;
optional__ValueOpRhs : ValueOpRhs | KnownOpRhs | FuzzyStringOpRhs | SetOpRhs | SetZipOpRhs | LengthOpRhs | 
;
grouped__TRUEs : TRUE | FALSE
;
grouped__nones : grouped__Values_1 | ALL ValueList | ANY ValueList | ONLY ValueList
;
zero_or_more__Colons : Colon ValueListEntry | zero_or_more__Colons Colon ValueListEntry | 
;
optional__AND : | AND ExpressionClause
{
 $$.AST := New_AST ('&', Null_AST, $2.AST);
}
;
grouped__KNOWNs : KNOWN | UNKNOWN
;
zero_or_more__Commas_1 : Comma ValueZip | zero_or_more__Commas_1 Comma ValueZip | 
;
grouped__UnorderedConstants : UnorderedConstant | OrderedValue
;
optional__NOT :
{
 $$.AST := Null_AST;
}
| NOT
{
 $$.AST := New_AST ('N', Null_AST);
}
;
grouped__OrderedConstants : OrderedConstant | Property
;
grouped__Comparisons : Comparison | OpeningBrace Expression ClosingBrace
{
 $$ := $2;
}
;
grouped__ValueEqRhs : ValueEqRhs | ValueRelCompRhs
;
grouped__EqualityOperators : EqualityOperator | RelativeComparisonOperator
;
optional__equals : '='
{
 $$.C := '=';
}
|
{
 $$.C := ' ';
}
;
optional__WITH : WITH | 
;
optional__Spaces : Spaces | 
;
-----------------------------


-----------------------------
grouped__Values_1 : Value
| EqualityOperator Value
{
 $$.AST := New_Ast ('@', $2.AST);
}
| RelativeComparisonOperator OrderedValue
{
 $$.AST := New_Ast ('?', $2.AST);
}
| FuzzyStringOpRhs
;
-----------------------------

%%
package Filter is
procedure yyparse;
end Filter;

with Filter_Goto, Filter_Tokens, Filter_Shift_Reduce, Filter_AST;
use Filter_Goto, Filter_Tokens, Filter_Shift_Reduce, Filter_AST;
package body Filter is

    Parsed_Expression : Filter_AST.AST_Type;

##
end Filter;
