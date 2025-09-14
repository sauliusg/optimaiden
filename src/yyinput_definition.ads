with filter_lexer_DFA; use filter_lexer_DFA;

package YYInput_Definition is
   
   -- Interface to the AFlex generated lexer:
   
   procedure YY_INPUT
     (
      buf      : out Unbounded_Character_Array;
      result   : out Integer;
      max_size : in Integer
     );
   
   -- Set string S to be the input of the lexer and parser; YY_INPUT
   --  will read from that string:
   
   procedure Start_Parsing (S : String);
   
   -- Return thw whole string buffer that was set prviously (or the
   --  default):
   
   function Buffer return String;
   
private
   
   type Access_String is access all String;
   
   Buffer_Data : aliased String := "+0.123";
   
   Buffer_Ptr : Access_String := Buffer_Data'Access;
   
   Pos : Integer := Buffer_Ptr.all'First;

end;
