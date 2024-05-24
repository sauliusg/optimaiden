with Ada.Text_IO; use Ada.Text_IO;
with Ada.Command_Line;

with AWS.Server;
with AWS.Config; use AWS.Config;
with AWS.Config.Set;
with AWS.Net;
with AWS.Services.Dispatchers.URI;

with Optimaiden_Info_Handler; use Optimaiden_Info_Handler;
with Optimaiden_Structure_Handler; use Optimaiden_Structure_Handler;

procedure Optimaiden is

   task Waiter is
      entry Proceed;
      entry Wait;
   end Waiter;

   task body Waiter is
   begin
      select
         accept Proceed;
      end select;
      select
         accept Wait;
      end select;
   end Waiter;

   Web_Server : AWS.Server.HTTP;

   Web_Config : AWS.Config.Object := Get_Current;

   Root : AWS.Services.Dispatchers.URI.Handler;

   Info_Handler : Optimaiden_Info_Handler_Type;
   Structure_Handler : Optimaiden_Structure_Handler_Type;

begin

   declare
      use AWS.Config.Set;
   begin
      Max_Connection (Web_Config, 1);
      Free_Slots_Keep_Alive_Limit (Web_Config, 1);
      Keep_Alive_Force_Limit (Web_Config, 1);
   end;

   AWS.Config.Set.Server_Name (Web_Config, "Optimaiden: Hello World");
   --  AWS.Config.Set.Protocol_Family (Web_Config, "Family_Inet");

   AWS.Services.Dispatchers.URI.Register (Root, "/info", Info_Handler);
   AWS.Services.Dispatchers.URI.Register (Root, "/structures", Structure_Handler);

   pragma Debug
     (
      Put_Line (AWS.Config.Free_Slots_Keep_Alive_Limit (Web_Config)'Image)
     );
   pragma Debug (Put_Line (AWS.Config.Max_Connection (Web_Config)'Image));

   AWS.Server.Start
     (
      Web_Server,
      Dispatcher => Root,
      Config => Web_Config
     );

   Waiter.Wait;

   AWS.Server.Shutdown (Web_Server);

exception
   when AWS.Net.Socket_Error =>
      Put_Line (Standard_Error, "Socket already in use");
      Ada.Command_Line.Set_Exit_Status (1);
      Waiter.Proceed;
      Waiter.Wait;

   when others =>
      Waiter.Proceed;
      Waiter.Wait;
      raise;

end Optimaiden;
