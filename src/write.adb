with Ada.Text_IO; use Ada.Text_IO;
with Util.Streams.Texts;
with Util.Serialize.IO.JSON;

procedure Write is
   Output : aliased Util.Streams.Texts.Print_Stream;
   Stream : Util.Serialize.IO.JSON.Output_Stream;
begin
   Output.Initialize (Size => 10000);
   Stream.Initialize (Output => Output'Unchecked_Access);

   Stream.Start_Document;
   Stream.Start_Entity ("data");
   Stream.Start_Entity ("attributes");
   Stream.Write_Entity ("api_version", "1.0.0");

   Stream.Start_Array ("available_api_versions");
   Stream.Start_Entity ("");
   Stream.Write_Attribute ("url", "localhost:8080");
   Stream.Write_Attribute ("version", "1.0.0");
   Stream.End_Entity ("");
   Stream.End_Array ("available_api_versions");

   Stream.Write_Entity ("id", "/");
   Stream.Write_Entity ("type", "info");
   Stream.End_Entity ("attributes");
   Stream.End_Entity ("data");
   Stream.End_Document;

   Put_Line (Util.Streams.Texts.To_String (Output));
end Write;
