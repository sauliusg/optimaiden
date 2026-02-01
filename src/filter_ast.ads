with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;

with Ada.Finalization;

-- Abstract Syntax Tree (AST) for the OPTIMADE Filter language.
--
-- Loosely based on the example in:
--
-- https://www.cs.fsu.edu/~baker/ada/examples/ast2.ads

package Filter_AST is
   
   type Operator_Type is new Character;
   
   type AST_Kind is (NUMBER, TEXT, TRUE_OR_FALSE, VARIABLE, OPERATOR,
                     UNARY_OPERATOR);
   
   type AST_Type is private;
   
   -- Return the AST kind:
   function Kind (A : AST_Type) return AST_Kind;
   
   -- Return empty AST, to be used as a placeholder:
   function Null_AST return AST_Type;
   
   -- Check whether the AST has not node (and thus pepresents an empty
   --  dummy node):
   function Is_Null (A : AST_Type) return Boolean;
   
   -- Return left and right subtree of an expression:
   function Left (A : AST_Type) return AST_Type;
   
   function Right (A : AST_Type) return AST_Type;
   
   -- Return the operand of an unary expression:
   function Operand (A : AST_Type) return AST_Type;
   
   -- Return the operator of a bionary operator AST node:
   function Operator (A : AST_Type) return Operator_Type;
   
   --  Construct AST leaf representing a variable (i.e. an OPTIMADE
   --  property):
   function New_AST_Identifier (Name : String) return AST_Type;
  
   function New_AST_Identifier (Name : Unbounded_String) return AST_Type;
  
   --  Construct AST leaf representing a string value:
   function New_AST (Value : String) return AST_Type;
  
   function New_AST (Value : Unbounded_String) return AST_Type;
  
   --  Construct AST leaf representing a numeric constant:
   function New_AST (X : Float) return AST_Type;

   --  Construct AST leaf True and False values:
   function New_AST (B : Boolean) return AST_Type;

   --  Construct AST node for operator with no operands, to serve as a
   --  placeholder for the operator type:
   function New_AST (Op : Operator_Type) return AST_Type;
   
   --  Construct AST node for operator with one operand:
   function New_AST (Op : Operator_Type; Arg : AST_Type) return AST_Type;
   
   --  Construct AST node for operator with two operands:
   function New_AST (Op : Operator_Type; Arg1, Arg2 : AST_Type) return AST_Type;
   
   --  Represent AST as a Lisp-style parenthesized expression:
   function Image (T : AST_Type) return String;
   
private
   
   type AST_Node_Type (Kind : AST_Kind) is record
      Count : Integer := 1;
      case Kind is
         when NUMBER =>
            Value : Float;
         when TEXT =>
            Text_Value : Unbounded_String;
         when TRUE_OR_FALSE =>
            Bool_Value : Boolean;
         when VARIABLE =>
            Identifier : Unbounded_String;
         when OPERATOR =>
            Op : Operator_Type;
            Left, Right : AST_Type;
         when UNARY_OPERATOR =>
            UnOp    : Operator_Type;
            Operand : AST_Type;
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
