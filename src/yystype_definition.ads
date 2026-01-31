with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;

with Filter_AST; use Filter_AST;

package YYStype_Definition is
   
   type Discriminant_Type is (YY_NONE, YY_CHR, YY_STR, YY_NUM, YY_AST);
   
   type YYSType (Kind : Discriminant_Type := YY_NONE) is record
      case Kind is
         when YY_NONE =>
            null;
         when YY_CHR =>
            C : Character := ' ';
         when YY_STR =>
            S : Unbounded_String := Null_Unbounded_String;
         when YY_NUM =>
            N : Float := 0.0;
         when YY_AST =>
            AST : AST_Type;
      end case;
   end record;
   
end;
