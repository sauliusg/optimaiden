with filter_lexer_DFA; use filter_lexer_DFA;

package YYInput_Definition is
   
   procedure YY_INPUT
     (
      buf      : out Unbounded_Character_Array;
      result   : out Integer;
      max_size : in Integer
     );
   
end;
