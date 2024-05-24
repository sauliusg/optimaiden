with AWS.Dispatchers;
with AWS.Status;
with AWS.Response;

--  The above code is following the example in:
--  https://blog.vacs.fr/vacs/blogs/post.html?post=2022/03/05/IO-stream-composition-and-serialization-with-Ada-Utility-Library
--  [accessed 2024-05-24T10:24+03:00].

package Optimaiden_Info_Handler is

   --  Example take from
   --  https://ada-util.readthedocs.io/en/latest/Serialization/
   --  [accessed 2024-05-24T09:52+03:00].

   type Info_Type is record
      API_Version   : String (1 .. 5) := "1.1.0";
      Id            : String (1 .. 1) := "/";
      Endpoint_Type : String (1 .. 4) := "info";
   end record;

   type Optimaiden_Info_Handler_Type is new AWS.Dispatchers.Handler
     with null record;

   overriding
   function Dispatch
     (
      Handler : Optimaiden_Info_Handler_Type;
      Request : AWS.Status.Data
     ) return AWS.Response.Data;

   --  Serialise the "info" endpoint as JSON:

   function As_JSON (Info : Info_Type) return String;

--  The above code is following, mutatis mutandis, the example in:
--  https://blog.vacs.fr/vacs/blogs/post.html?post=2022/03/05/IO-stream-composition-and-serialization-with-Ada-Utility-Library
--  [accessed 2024-05-24T10:24+03:00].

private

   Info_Endpoint_Data : Info_Type;

   overriding function Clone (Element : Optimaiden_Info_Handler_Type)
                             return Optimaiden_Info_Handler_Type;

end Optimaiden_Info_Handler;
