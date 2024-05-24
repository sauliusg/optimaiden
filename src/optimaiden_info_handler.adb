with AWS.MIME; use AWS.MIME;
with Util.Beans.Objects; use Util.Beans.Objects;

with Util.Serialize.Mappers.Record_Mapper;

package body Optimaiden_Info_Handler is

   overriding
   function Dispatch
     (
      Handler : Optimaiden_Info_Handler_Type;
      Request : AWS.Status.Data
     ) return AWS.Response.Data is
   begin
      return AWS.Response.Build (AWS.MIME.Text_Plain, "info will go here");
   end Dispatch;

   overriding function Clone (Element : Optimaiden_Info_Handler_Type)
                             return Optimaiden_Info_Handler_Type is
   begin
      return Element;
   end Clone;

   --  Serialisation bindings. Modelled after:
   --  https://ada-util.readthedocs.io/en/latest/Serialization/
   --  [accessed 2024-05-24T09:52+03:00].

   procedure Set_Member
     (
      Info  : in out Info_Type;
      Field : Info_Fields;
      Value : Util.Beans.Objects.Object
     ) is
   begin
      case Field is

         when API_VERSION =>
            Info.API_Version := To_String (Value);

         when ID =>
            Info.Id := To_String (Value);

         when ENDPOINT_TYPE =>
            Info.Endpoint_Type := To_String (Value);

      end case;
   end Set_Member;

   function Get_Member
     (
      Info  : Info_Type;
      Field : Info_Fields
     ) return Util.Beans.Objects.Object is
   begin
      case Field is

         when API_VERSION =>
            return Util.Beans.Objects.To_Object (Info.API_Version);

         when ID =>
            return Util.Beans.Objects.To_Object (Info.Id);

         when ENDPOINT_TYPE =>
            return Util.Beans.Objects.To_Object (Info.Endpoint_Type);

      end case;
   end Get_Member;

   type Info_Access is access all Info_Type;

   package Info_Mapper is new Util.Serialize.Mappers.Record_Mapper
     (
      Element_Type        => Info_Type,
      Element_Type_Access => Info_Access,
      Fields              => Info_Fields,
      Set_Member          => Set_Member
     );

   Info_Mapping : Info_Mapper.Mapper;

begin --  Optimaiden_Info_Handler
   Info_Mapping.Add_Mapping ("api_version", API_VERSION);
   Info_Mapping.Add_Mapping ("id", ID);
   Info_Mapping.Add_Mapping ("type", ENDPOINT_TYPE);
end Optimaiden_Info_Handler;
