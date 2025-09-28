with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;

with Filter_AST; use Filter_AST;

package YYStype_Definition is
   
   type YYSType is record
      C : Character;
      S : Unbounded_String;
      N : Float;
      AST : AST_Type;
   end record;
   
end;
