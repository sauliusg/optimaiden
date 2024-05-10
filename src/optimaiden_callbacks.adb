package body Optimaiden_Callbacks is

   HTML_Body_Head : constant String :=
     "<!DOCTYPE html PUBLIC ""-//W3C//DTD XHTML 1.0 Strict//EN""" &
     " ""http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd"">" &
     "<html xmlns=""http://www.w3.org/1999/xhtml""" &
     " xml:lang=""en"" lang=""en"">" &
     "<body>";

   HTML_Body_Tail : constant String :=
     "</body>" &
     "</html>"
     ;

   function HW_CB (Request : AWS.Status.Data) return AWS.Response.Data is
      pragma Unreferenced (Request);
   begin
      return AWS.Response.Build
        (
         "text/html",
         HTML_Body_Head &
           "<p>Hello world !</p>" &
           HTML_Body_Tail
        );
   end HW_CB;

end Optimaiden_Callbacks;
