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
         '(', ')', '.',
         ',', ':', '=',
         'A', 'B', 'C',
         'D', 'E', 'F',
         'G', 'H', 'I',
         'J', 'K', 'L',
         'M', 'N', 'O',
         'P', 'Q', 'R',
         'S', 'T', 'U',
         'V', 'W', 'X',
         'Y', 'Z', 'a',
         'b', 'c', 'd',
         'e', 'f', 'g',
         'h', 'i', 'j',
         'k', 'l', 'm',
         'n', 'o', 'p',
         'q', 'r', 's',
         't', 'u', 'v',
         'w', 'x', 'y',
         'z', '_', '"',
         '\', '!', '#',
         '$', '%', '&',
         ''', '*', '+',
         '-', '/', ';',
         '<', '>', '?',
         '@', '[', ']',
         '^', '`', '{',
         '|', '}', '~',
         '0', '1', '2',
         '3', '4', '5',
         '6', '7', '8',
         '9', ' ');

   Syntax_Error : exception;

end Filter_Tokens;
