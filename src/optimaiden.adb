with AWS.Server;

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

begin

   AWS.Server.Start
     (
      Web_Server, "Hello World",
      Max_Connection => 1,
      Callback       => HW_CB'Access
     );

   Waiter.Wait;

   AWS.Server.Shutdown (Web_Server);

end Optimaiden;
