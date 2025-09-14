with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;

package YYStype_Definition is
   
   type YYSType is record
      C : Character;
      S : Unbounded_String;
      N : Float;
   end record;
   
end;
