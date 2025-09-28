with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;

with Ada.Finalization;

-- Abstract Syntax Tree (AST) for the OPTIMADE Filter language.
--
-- Loosely based on th eexample in:
--
-- https://www.cs.fsu.edu/~baker/ada/examples/ast2.ads

package Filter_AST is
   
   type Operator_Type is new Character;
   
   type AST_Type is private;
   
   --  Construct AST leaf representing a variable (i.e. an OPTIMADE
   --  property):
   function New_AST (Name : String) return AST_Type;
  
   --  Construct AST node for operator with one operand:
   function New_AST (Op : Operator_Type; Arg : AST_Type) return AST_Type;
   
   --  Construct AST node for operator with two operands:
   function New_AST (Op : Operator_Type; Arg1, Arg2 : AST_Type) return AST_Type;
   
   --  Represent AST as a Lisp-style parenthesized expression:
   function Image (T : AST_Type) return String;
   
private
   
   type AST_Kind is (NUMBER, VARIABLE, OPERATOR);
   
   type AST_Node_Type (Kind : AST_Kind) is record
      Count : Integer := 1;
      case Kind is
         when NUMBER =>
            Value : Float;
         when VARIABLE =>
            Identifier : Unbounded_String;
         when OPERATOR =>
            Op : Operator_Type;
            Left, Right : AST_Type;
      end case;
   end record;
   
   type AST_Node_Access is access AST_Node_Type;
   
   type AST_Type is new Ada.Finalization.Controlled with record
      AST : AST_Node_Access := null;
   end record;
   
   --  don't need to override Initialize, since null value
   --  is OK for AST_Type.AST
   procedure Adjust (T : in out AST_TYpe);   
   procedure Finalize (T : in out AST_Type);
   
end;
