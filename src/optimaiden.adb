with Ada.Text_IO; use Ada.Text_IO;
with Ada.Command_Line;

with AWS.Server;
with AWS.Config; use AWS.Config;
with AWS.Config.Set;
with AWS.Net;

with Optimaiden_Callbacks; use Optimaiden_Callbacks;

procedure Optimaiden is

   Web_Server : AWS.Server.HTTP;

   task Waiter is
      entry Start;
      entry Wait;
   end Waiter;

   task body Waiter is
   begin
      select
         accept Start;
      end select;
      select
         accept Wait;
      end select;
   end Waiter;

   Web_Config : AWS.Config.Object := Get_Current;

begin

   declare
      use AWS.Config.Set;
   begin
      Max_Connection (Web_Config, 1);
      Free_Slots_Keep_Alive_Limit (Web_Config, 1);
      Keep_Alive_Force_Limit (Web_Config, 1);
   end;

   AWS.Config.Set.Server_Name (Web_Config, "Optimaiden: Hello World");

   --  Put_Line (AWS.Config.Free_Slots_Keep_Alive_Limit (Web_Config)'Image);
   --  Put_Line (AWS.Config.Max_Connection (Web_Config)'Image);

   AWS.Server.Start
     (
      Web_Server,
      Callback => HW_CB'Access,
      Config => Web_Config
     );

   Waiter.Wait;

   AWS.Server.Shutdown (Web_Server);

exception
   when AWS.Net.Socket_Error =>
      Put_Line (Standard_Error, "Socket already in use");
      Ada.Command_Line.Set_Exit_Status (1);
      Waiter.Start;
      Waiter.Wait;

   when others =>
      Waiter.Start;
      Waiter.Wait;
      raise;

end Optimaiden;
