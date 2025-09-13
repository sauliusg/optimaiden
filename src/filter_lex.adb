with Ada.Text_IO; use Ada.Text_IO;
with Filter_Tokens; use Filter_Tokens;

with Ada.Unchecked_Deallocation;

package body Filter_Lex is
   
   procedure Free is new Ada.Unchecked_Deallocation
     (String, Access_String);
   
   function Buffer return String is
   begin
      return Buffer_Ptr.all;
   end;

   function YYLex return Token is
   begin
      Pos := Pos + 1;
      if Pos > Buffer'Last then
         Put_Line (Standard_Error, ">>> End-of-Input");
         return End_Of_Input;
      end if;
      YYVal.C := Buffer (Pos);
      Put_Line (Standard_Error, ">>> Processing character: " & Buffer (Pos)'Image);
      case Buffer (Pos) is
         when '+' => return Token'('+');
         when '-' => return Token'('-');
         when '0' => return Token'('0');
         when '1' => return Token'('1');
         when '2' => return Token'('2');
         when '3' => return Token'('3');
         when '4' => return Token'('4');
         when '5' => return Token'('5');
         when '6' => return Token'('6');
         when '7' => return Token'('7');
         when '8' => return Token'('8');
         when '9' => return Token'('9');
         when 'e' => return Token'('e');
         when 'E' => return Token'('E');
         when '.' => return Token'('.');
         when others =>
            raise Syntax_Error with "Unsupported Token Character " &
              Buffer (Pos)'Image;
      end case;
   end;
   
   procedure Start_Parsing (S : String) is
   begin
      if Buffer_Ptr /= Lex.Buffer_Data'Access then
         Free (Buffer_Ptr);
      end if;
      Buffer_Ptr := new String'(S);
   end;
   
end;
