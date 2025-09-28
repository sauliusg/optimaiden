with YYSType_Definition; use YYSType_Definition;
package Filter_Tokens is

   subtype YYSType is YYSType_Definition.YYSType;

   YYLVal, YYVal : YYSType;
   type Token is
        (END_OF_INPUT, ERROR, UNICODE_CHARACTER, FF_TOKEN,
         LF_TOKEN, CR_TOKEN, HT_TOKEN,
         VT_TOKEN, AND_TOKEN, NOT_TOKEN,
         OR_TOKEN, IS_TOKEN, KNOWN_TOKEN,
         UNKNOWN_TOKEN, CONTAINS_TOKEN, STARTS_TOKEN,
         ENDS_TOKEN, WITH_TOKEN, LENGTH_TOKEN,
         HAS_TOKEN, ALL_TOKEN, ONLY_TOKEN,
         ANY_TOKEN, TRUE_TOKEN, FALSE_TOKEN,
         IDENTIFIER_TOKEN, NUMBER_TOKEN, STRING_TOKEN,
         KEYWORD_TOKEN, '(', ')',
         '.', ',', ':',
         '=', ' ', '<',
         '>', '!');

   Syntax_Error : exception;

end Filter_Tokens;
