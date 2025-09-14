with Ada.Unchecked_Deallocation;

package body YYInput_Definition is
   
   procedure YY_INPUT
     (
      Buf      : out Unbounded_Character_Array;
      Result   : out Integer;
      Max_Size : in  Integer
     ) is
      Remaining_Input_Length : constant Integer := 
        Buffer_Ptr.all'Last - YYInput_Definition.Pos + 1;
   begin
      if Max_Size >= Remaining_Input_Length then
         -- All remaining characters fit into the output buffer:
         Buf (Buf'First .. Buf'First + Remaining_Input_Length - 1) :=
           Unbounded_Character_Array (Buffer_Ptr (Pos .. Buffer_Ptr.all'Last));
         Result := Remaining_Input_Length;
         Pos := Pos + Remaining_Input_Length;
      else
         -- Max_Size < remaining characters – will copy Max_Size and
         --  advance the Pos for the next chunk:
         Buf := Unbounded_Character_Array (Buffer_Ptr (Pos .. Pos + Max_Size - 1));
         Pos := Pos + Max_Size;
      end if;
   end;
   
   procedure Free is new Ada.Unchecked_Deallocation
     (String, Access_String);
   
   function Buffer return String is
   begin
      return Buffer_Ptr.all;
   end;

   procedure Start_Parsing (S : String) is
   begin
      if Buffer_Ptr /= YYInput_Definition.Buffer_Data'Access then
         Free (Buffer_Ptr);
      end if;
      Buffer_Ptr := new String'(S);
      Pos := Buffer_Ptr.all'First;
   end;
   
end;
