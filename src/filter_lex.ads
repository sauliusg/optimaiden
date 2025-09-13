with Filter_Tokens; use Filter_Tokens;

package Filter_Lex is
   
   function YYLex return Token;
   
   function Buffer return String;
   
   procedure Start_Parsing (S : String);
   
private
   
   type Access_String is access all String;
   
   Buffer_Data : aliased String := "+0.123";
   
   Buffer_Ptr : Access_String := Buffer_Data'Access;
   
   Pos : Integer := 0;
   
end;
