with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;

with Ada.Finalization;

-- Abstract Syntax Tree (AST) for the OPTIMADE Filter language.
--
-- Loosely based on the example in:
--
-- https://www.cs.fsu.edu/~baker/ada/examples/ast2.ads

package Filter_AST is
   
   type Operator_Type is new Character;
   
   type AST_Type is private;
   
   -- Return left and right subtree of an expression:
   function Left (A : AST_Type) return AST_Type;
   
   function Right (A : AST_Type) return AST_Type;
   
   --  Construct AST leaf representing a variable (i.e. an OPTIMADE
   --  property):
   function New_AST_Identifier (Name : String) return AST_Type;
  
   function New_AST_Identifier (Name : Unbounded_String) return AST_Type;
  
   --  Construct AST leaf representing a string value:
   function New_AST (Value : String) return AST_Type;
  
   function New_AST (Value : Unbounded_String) return AST_Type;
  
   --  Construct AST leaf representing a numeric constant:
   function New_AST (X : Float) return AST_Type;

   --  Construct AST node for operator with one operand:
   function New_AST (Op : Operator_Type; Arg : AST_Type) return AST_Type;
   
   --  Construct AST node for operator with two operands:
   function New_AST (Op : Operator_Type; Arg1, Arg2 : AST_Type) return AST_Type;
   
   --  Represent AST as a Lisp-style parenthesized expression:
   function Image (T : AST_Type) return String;
   
private
   
   type AST_Kind is (NUMBER, TEXT, VARIABLE, OPERATOR);
   
   type AST_Node_Type (Kind : AST_Kind) is record
      Count : Integer := 1;
      case Kind is
         when NUMBER =>
            Value : Float;
         when TEXT =>
            Text_Value : Unbounded_String;
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
