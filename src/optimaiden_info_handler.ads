with AWS.Dispatchers;
with AWS.Status;
with AWS.Response;

with Util.Serialize;
with Util.Beans.Objects;

package Optimaiden_Info_Handler is

   --  Example take from
   --  https://ada-util.readthedocs.io/en/latest/Serialization/
   --  [accessed 2024-05-24T09:52+03:00].

   type Info_Type is record
      API_Version   : String (1 .. 5) := "1.1.0";
      Id            : String (1 .. 1) := "/";
      Endpoint_Type : String (1 .. 4) := "info";
   end record;

   type Info_Fields is (API_VERSION, ID, ENDPOINT_TYPE);

   procedure Set_Member
     (
      Info  : in out Info_Type;
      Field : Info_Fields;
      Value : Util.Beans.Objects.Object
     );

   function Get_Member
     (
      Info  : Info_Type;
      Field : Info_Fields
     ) return Util.Beans.Objects.Object;

   --  The handler for the Info endpoint:

   type Optimaiden_Info_Handler_Type is new AWS.Dispatchers.Handler
     with null record;

   overriding
   function Dispatch
     (
      Handler : Optimaiden_Info_Handler_Type;
      Request : AWS.Status.Data
     ) return AWS.Response.Data;

private

   overriding function Clone (Element : Optimaiden_Info_Handler_Type)
                             return Optimaiden_Info_Handler_Type;

end Optimaiden_Info_Handler;
