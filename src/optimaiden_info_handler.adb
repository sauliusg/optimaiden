with AWS.MIME; use AWS.MIME;
with Util.Streams.Texts;
with Util.Serialize.IO.JSON;

package body Optimaiden_Info_Handler is

   overriding
   function Dispatch
     (
      Handler : Optimaiden_Info_Handler_Type;
      Request : AWS.Status.Data
     ) return AWS.Response.Data is
   begin
      return AWS.Response.Build
        (
         AWS.MIME.Application_JSON,
         As_JSON (Info_Endpoint_Data)
        );
   end Dispatch;

   overriding function Clone (Element : Optimaiden_Info_Handler_Type)
                             return Optimaiden_Info_Handler_Type is
   begin
      return Element;
   end Clone;

   --  Serialise Info endpoint as JSON:

   procedure Write_OPTIMADE_Data
     (
      Stream : out Util.Serialize.IO.JSON.Output_Stream;
      Info : Info_Type
     ) is
   begin
      Stream.Start_Entity ("data");
      Stream.Start_Entity ("attributes");
      Stream.Write_Entity ("api_version", Info.API_Version);

      Stream.Start_Array ("available_api_versions");
      Stream.Start_Entity ("");
      Stream.Write_Attribute ("url", "localhost:8080");
      Stream.Write_Attribute ("version", "1.0.0");
      Stream.End_Entity ("");
      Stream.End_Array ("available_api_versions");

      Stream.Start_Array ("available_endpoints");
      Stream.Write_Attribute ("", "references");
      Stream.Write_Attribute ("", "structures");
      Stream.End_Array ("available_api_versions");

      Stream.Start_Entity ("entry_types_by_format");
      Stream.Start_Array ("json");
      Stream.Write_Attribute ("", "references");
      Stream.Write_Attribute ("", "structures");
      Stream.End_Array ("json");
      Stream.End_Entity ("entry_types_by_format");

      Stream.Start_Array ("formats");
      Stream.Write_Attribute ("", "json");
      Stream.Write_Attribute ("", "xml");
      Stream.End_Array ("formats");

      Stream.Write_Entity ("id", Info.Id);
      Stream.Write_Entity ("type", Info.Endpoint_Type);
      Stream.End_Entity ("attributes");
      Stream.End_Entity ("data");
   end Write_OPTIMADE_Data;

   procedure Write
     (
      Stream : out Util.Serialize.IO.JSON.Output_Stream;
      Info : Info_Type
     ) is
   begin
      Stream.Start_Document;
      Write_OPTIMADE_Data (Stream, Info);
      Stream.End_Document;
   end Write;

   --  The abov code is based upon the example in:
   --  https://github.com/stcarrez/ada-util/blob/master/samples/serialize.adb
   --  [accessed 2024-05-24T11:19+03:00].

   function As_JSON (Info : Info_Type) return String is
      Output : aliased Util.Streams.Texts.Print_Stream;
      Stream : Util.Serialize.IO.JSON.Output_Stream;
   begin
      Output.Initialize (Size => 10000);
      Stream.Initialize (Output => Output'Unchecked_Access);
      Write (Stream, Info);
      return (Util.Streams.Texts.To_String (Output));
   end As_JSON;

   --  The above code is following, mutatis mutandis, the example in:
   --  https://blog.vacs.fr/vacs/blogs/post.html?post=2022/03/05/IO-stream-composition-and-serialization-with-Ada-Utility-Library
   --  [accessed 2024-05-24T10:24+03:00].

end Optimaiden_Info_Handler;
