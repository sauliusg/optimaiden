with Ada.Unchecked_Deallocation;

package body YYInput_Definition is
   
   procedure YY_INPUT
     (
      buf      : out Unbounded_Character_Array;
      result   : out Integer;
      max_size : in  Integer
     ) is
   begin
      null;
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
   end;
   
end;
