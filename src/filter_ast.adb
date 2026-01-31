with Ada.Text_IO; use Ada.Text_IO;
with Ada.Unchecked_Deallocation;

package body Filter_AST is
   
   procedure Free is new Ada.Unchecked_Deallocation
     (AST_Node_Type, AST_Node_Access);
   
   function "+" (S : String) return Unbounded_String is
      (To_Unbounded_String (S));
      
   pragma Inline ("+");
   
   function Kind (A : AST_Type) return AST_Kind is
   begin
      return A.AST.Kind;
   end;
   
   function Null_AST return AST_Type is
   begin
     return (Ada.Finalization.Controlled with AST => null);
   end;
   
   function Is_Null (A : AST_Type) return Boolean is
   begin
      return A.AST = null;
   end;
   
   function Left (A : AST_Type) return AST_Type is
   begin
      return A.AST.Left;
   end;
   
   function Right (A : AST_Type) return AST_Type is
   begin
      return A.AST.Right;
   end;
   
   function Operator (A : AST_Type) return Operator_Type is
   begin
      return A.AST.Op;
   end;
   
   function New_AST_Identifier (Name : String) return AST_Type is
   begin
      return New_AST_Identifier (+Name);
   end;
   
   function New_AST_Identifier (Name : Unbounded_String) return AST_Type is
   begin
      return 
        (
         Ada.Finalization.Controlled with
           AST => new AST_Node_Type'
           (
            Kind => VARIABLE,
            Identifier => Name,
            others => <>
           )
        );
   end;
   
   function New_AST (Value : String) return AST_Type is
   begin
      return New_AST (+Value);
   end;
      
   function New_AST (Value : Unbounded_String) return AST_Type is
   begin
      return 
        (
         Ada.Finalization.Controlled with
           AST => new AST_Node_Type'
           (
            Kind => TEXT,
            Text_Value => Value,
            others => <>
           )
        );
   end;
  
   function New_AST (X : Float) return AST_Type is
   begin
      return (Ada.Finalization.Controlled with 
                AST => new AST_Node_Type'
                (
                 Kind => NUMBER,
                 Value => X,
                 others => <>
                )
             );
   end;
   
   function New_AST (B : Boolean) return AST_Type is
   begin
      return
        (Ada.Finalization.Controlled with
         AST => new AST_Node_Type'
           (
            Kind => TRUE_OR_FALSE,
            Bool_Value => B,
            others => <>
           )
        );
   end;

   function New_AST (Op : Operator_Type; Arg : AST_Type) return AST_Type is
   begin
      return
        (Ada.Finalization.Controlled with
         AST => new AST_Node_Type'
           (
            Kind => OPERATOR,
            Op => Op,
            Left => Arg,
            others => <>
           )
        );
   end;
   
   function New_AST (Op : Operator_Type; Arg1, Arg2 : AST_Type) return AST_Type is
   begin
      return
        (Ada.Finalization.Controlled with
         AST => new AST_Node_Type'
           (
            Kind => OPERATOR,
            Op => Op,
            Left => Arg1,
            Right => Arg2,
            others => <>
           )
        );
   end;
   
   function Image (T : AST_Type; Indent : Integer) return String is
      Shift  : constant Integer := 4;
      Spaces : String (1 .. Indent) := (others => ' ');
   begin
      if T.AST = null then
         return "NULL";
      end if;
      declare
         Node_Value : constant String :=
           (
            case T.AST.Kind is
               when NUMBER   => T.AST.Value'Image,
               when VARIABLE => To_String (T.AST.Identifier),
               when TEXT     => """" & To_String (T.AST.Text_Value) & """",
               when TRUE_OR_FALSE =>
                                T.AST.Bool_Value'Image,
               when OPERATOR => T.AST.Op'Image & ": " & ASCII.LF &
                                Image (T.AST.Left, Indent + Shift) & ASCII.LF & 
                                Image (T.AST.Right, Indent + Shift)
           );
      begin
         case T.AST.Kind is
            when OPERATOR => 
               return
                 Spaces & "(" & T.AST.Kind'Image & " " & Node_Value & 
                 ASCII.LF & Spaces & ")";
            when others =>
               return Spaces & T.AST.Kind'Image & ": " & Node_Value;
         end case;
      end;
   end;
            
   function Image (T : AST_Type) return String is
   begin
      return Image (T, 0);
   end;

   procedure Adjust (T : in out AST_Type) is
   begin
      pragma Debug (Put_Line ("Adjust called"));
      if T.AST /= null then
         T.AST.Count := T.AST.Count + 1;
      end if;
   end;
   
   procedure Finalize (T : in out AST_Type) is
   begin
      pragma Debug (Put_Line ("Finalize called"));
      if T.AST /= null then
         T.AST.Count := T.AST.Count - 1;
         if T.AST.Count = 0 then
            Free (T.AST);
         end if;
      end if;      
   end;

end;
