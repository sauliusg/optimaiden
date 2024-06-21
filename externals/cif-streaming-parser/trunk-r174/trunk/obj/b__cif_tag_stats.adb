pragma Warnings (Off);
pragma Ada_95;
pragma Source_File_Name (ada_main, Spec_File_Name => "b__cif_tag_stats.ads");
pragma Source_File_Name (ada_main, Body_File_Name => "b__cif_tag_stats.adb");
pragma Suppress (Overflow_Check);

with System.Restrictions;
with Ada.Exceptions;

package body ada_main is

   E081 : Short_Integer; pragma Import (Ada, E081, "system__os_lib_E");
   E013 : Short_Integer; pragma Import (Ada, E013, "ada__exceptions_E");
   E017 : Short_Integer; pragma Import (Ada, E017, "system__soft_links_E");
   E027 : Short_Integer; pragma Import (Ada, E027, "system__exception_table_E");
   E050 : Short_Integer; pragma Import (Ada, E050, "ada__containers_E");
   E076 : Short_Integer; pragma Import (Ada, E076, "ada__io_exceptions_E");
   E034 : Short_Integer; pragma Import (Ada, E034, "ada__numerics_E");
   E063 : Short_Integer; pragma Import (Ada, E063, "ada__strings_E");
   E065 : Short_Integer; pragma Import (Ada, E065, "ada__strings__maps_E");
   E068 : Short_Integer; pragma Import (Ada, E068, "ada__strings__maps__constants_E");
   E055 : Short_Integer; pragma Import (Ada, E055, "interfaces__c_E");
   E028 : Short_Integer; pragma Import (Ada, E028, "system__exceptions_E");
   E090 : Short_Integer; pragma Import (Ada, E090, "system__object_reader_E");
   E060 : Short_Integer; pragma Import (Ada, E060, "system__dwarf_lines_E");
   E019 : Short_Integer; pragma Import (Ada, E019, "system__soft_links__initialize_E");
   E049 : Short_Integer; pragma Import (Ada, E049, "system__traceback__symbolic_E");
   E033 : Short_Integer; pragma Import (Ada, E033, "system__img_int_E");
   E071 : Short_Integer; pragma Import (Ada, E071, "system__img_uns_E");
   E117 : Short_Integer; pragma Import (Ada, E117, "ada__strings__utf_encoding_E");
   E125 : Short_Integer; pragma Import (Ada, E125, "ada__tags_E");
   E115 : Short_Integer; pragma Import (Ada, E115, "ada__strings__text_buffers_E");
   E178 : Short_Integer; pragma Import (Ada, E178, "interfaces__c__strings_E");
   E113 : Short_Integer; pragma Import (Ada, E113, "ada__streams_E");
   E166 : Short_Integer; pragma Import (Ada, E166, "system__file_control_block_E");
   E135 : Short_Integer; pragma Import (Ada, E135, "system__finalization_root_E");
   E111 : Short_Integer; pragma Import (Ada, E111, "ada__finalization_E");
   E163 : Short_Integer; pragma Import (Ada, E163, "system__file_io_E");
   E170 : Short_Integer; pragma Import (Ada, E170, "system__storage_pools_E");
   E168 : Short_Integer; pragma Import (Ada, E168, "system__finalization_masters_E");
   E199 : Short_Integer; pragma Import (Ada, E199, "system__storage_pools__subpools_E");
   E147 : Short_Integer; pragma Import (Ada, E147, "ada__strings__unbounded_E");
   E224 : Short_Integer; pragma Import (Ada, E224, "system__task_info_E");
   E106 : Short_Integer; pragma Import (Ada, E106, "ada__calendar_E");
   E174 : Short_Integer; pragma Import (Ada, E174, "ada__text_io_E");
   E195 : Short_Integer; pragma Import (Ada, E195, "system__pool_global_E");
   E172 : Short_Integer; pragma Import (Ada, E172, "system__regexp_E");
   E104 : Short_Integer; pragma Import (Ada, E104, "ada__directories_E");
   E229 : Short_Integer; pragma Import (Ada, E229, "system__img_lli_E");
   E218 : Short_Integer; pragma Import (Ada, E218, "system__task_primitives__operations_E");
   E210 : Short_Integer; pragma Import (Ada, E210, "ada__real_time_E");
   E248 : Short_Integer; pragma Import (Ada, E248, "system__tasking__initialization_E");
   E236 : Short_Integer; pragma Import (Ada, E236, "system__tasking__protected_objects_E");
   E252 : Short_Integer; pragma Import (Ada, E252, "system__tasking__protected_objects__entries_E");
   E254 : Short_Integer; pragma Import (Ada, E254, "system__tasking__queuing_E");
   E260 : Short_Integer; pragma Import (Ada, E260, "system__tasking__stages_E");
   E188 : Short_Integer; pragma Import (Ada, E188, "cif_datablock_tag_E");
   E206 : Short_Integer; pragma Import (Ada, E206, "cif_io_E");
   E180 : Short_Integer; pragma Import (Ada, E180, "logging_E");
   E176 : Short_Integer; pragma Import (Ada, E176, "cif_datablock_E");
   E263 : Short_Integer; pragma Import (Ada, E263, "datablock_queue_E");
   E208 : Short_Integer; pragma Import (Ada, E208, "cif_streaming_parser_E");

   Sec_Default_Sized_Stacks : array (1 .. 1) of aliased System.Secondary_Stack.SS_Stack (System.Parameters.Runtime_Default_Sec_Stack_Size);

   Local_Priority_Specific_Dispatching : constant String := "";
   Local_Interrupt_States : constant String := "";

   Is_Elaborated : Boolean := False;

   procedure finalize_library is
   begin
      E208 := E208 - 1;
      declare
         procedure F1;
         pragma Import (Ada, F1, "cif_streaming_parser__finalize_spec");
      begin
         F1;
      end;
      declare
         procedure F2;
         pragma Import (Ada, F2, "datablock_queue__finalize_spec");
      begin
         E263 := E263 - 1;
         F2;
      end;
      E176 := E176 - 1;
      declare
         procedure F3;
         pragma Import (Ada, F3, "cif_datablock__finalize_spec");
      begin
         F3;
      end;
      E206 := E206 - 1;
      declare
         procedure F4;
         pragma Import (Ada, F4, "cif_io__finalize_spec");
      begin
         F4;
      end;
      E188 := E188 - 1;
      declare
         procedure F5;
         pragma Import (Ada, F5, "cif_datablock_tag__finalize_spec");
      begin
         F5;
      end;
      E252 := E252 - 1;
      declare
         procedure F6;
         pragma Import (Ada, F6, "system__tasking__protected_objects__entries__finalize_spec");
      begin
         F6;
      end;
      declare
         procedure F7;
         pragma Import (Ada, F7, "ada__directories__finalize_body");
      begin
         E104 := E104 - 1;
         F7;
      end;
      declare
         procedure F8;
         pragma Import (Ada, F8, "ada__directories__finalize_spec");
      begin
         F8;
      end;
      E172 := E172 - 1;
      declare
         procedure F9;
         pragma Import (Ada, F9, "system__regexp__finalize_spec");
      begin
         F9;
      end;
      E195 := E195 - 1;
      declare
         procedure F10;
         pragma Import (Ada, F10, "system__pool_global__finalize_spec");
      begin
         F10;
      end;
      E174 := E174 - 1;
      declare
         procedure F11;
         pragma Import (Ada, F11, "ada__text_io__finalize_spec");
      begin
         F11;
      end;
      E147 := E147 - 1;
      declare
         procedure F12;
         pragma Import (Ada, F12, "ada__strings__unbounded__finalize_spec");
      begin
         F12;
      end;
      E199 := E199 - 1;
      declare
         procedure F13;
         pragma Import (Ada, F13, "system__storage_pools__subpools__finalize_spec");
      begin
         F13;
      end;
      E168 := E168 - 1;
      declare
         procedure F14;
         pragma Import (Ada, F14, "system__finalization_masters__finalize_spec");
      begin
         F14;
      end;
      declare
         procedure F15;
         pragma Import (Ada, F15, "system__file_io__finalize_body");
      begin
         E163 := E163 - 1;
         F15;
      end;
      declare
         procedure Reraise_Library_Exception_If_Any;
            pragma Import (Ada, Reraise_Library_Exception_If_Any, "__gnat_reraise_library_exception_if_any");
      begin
         Reraise_Library_Exception_If_Any;
      end;
   end finalize_library;

   procedure adafinal is
      procedure s_stalib_adafinal;
      pragma Import (Ada, s_stalib_adafinal, "system__standard_library__adafinal");

      procedure Runtime_Finalize;
      pragma Import (C, Runtime_Finalize, "__gnat_runtime_finalize");

   begin
      if not Is_Elaborated then
         return;
      end if;
      Is_Elaborated := False;
      Runtime_Finalize;
      s_stalib_adafinal;
   end adafinal;

   type No_Param_Proc is access procedure;
   pragma Favor_Top_Level (No_Param_Proc);

   procedure adainit is
      Main_Priority : Integer;
      pragma Import (C, Main_Priority, "__gl_main_priority");
      Time_Slice_Value : Integer;
      pragma Import (C, Time_Slice_Value, "__gl_time_slice_val");
      WC_Encoding : Character;
      pragma Import (C, WC_Encoding, "__gl_wc_encoding");
      Locking_Policy : Character;
      pragma Import (C, Locking_Policy, "__gl_locking_policy");
      Queuing_Policy : Character;
      pragma Import (C, Queuing_Policy, "__gl_queuing_policy");
      Task_Dispatching_Policy : Character;
      pragma Import (C, Task_Dispatching_Policy, "__gl_task_dispatching_policy");
      Priority_Specific_Dispatching : System.Address;
      pragma Import (C, Priority_Specific_Dispatching, "__gl_priority_specific_dispatching");
      Num_Specific_Dispatching : Integer;
      pragma Import (C, Num_Specific_Dispatching, "__gl_num_specific_dispatching");
      Main_CPU : Integer;
      pragma Import (C, Main_CPU, "__gl_main_cpu");
      Interrupt_States : System.Address;
      pragma Import (C, Interrupt_States, "__gl_interrupt_states");
      Num_Interrupt_States : Integer;
      pragma Import (C, Num_Interrupt_States, "__gl_num_interrupt_states");
      Unreserve_All_Interrupts : Integer;
      pragma Import (C, Unreserve_All_Interrupts, "__gl_unreserve_all_interrupts");
      Detect_Blocking : Integer;
      pragma Import (C, Detect_Blocking, "__gl_detect_blocking");
      Default_Stack_Size : Integer;
      pragma Import (C, Default_Stack_Size, "__gl_default_stack_size");
      Default_Secondary_Stack_Size : System.Parameters.Size_Type;
      pragma Import (C, Default_Secondary_Stack_Size, "__gnat_default_ss_size");
      Bind_Env_Addr : System.Address;
      pragma Import (C, Bind_Env_Addr, "__gl_bind_env_addr");

      procedure Runtime_Initialize (Install_Handler : Integer);
      pragma Import (C, Runtime_Initialize, "__gnat_runtime_initialize");

      Finalize_Library_Objects : No_Param_Proc;
      pragma Import (C, Finalize_Library_Objects, "__gnat_finalize_library_objects");
      Binder_Sec_Stacks_Count : Natural;
      pragma Import (Ada, Binder_Sec_Stacks_Count, "__gnat_binder_ss_count");
      Default_Sized_SS_Pool : System.Address;
      pragma Import (Ada, Default_Sized_SS_Pool, "__gnat_default_ss_pool");

   begin
      if Is_Elaborated then
         return;
      end if;
      Is_Elaborated := True;
      Main_Priority := -1;
      Time_Slice_Value := -1;
      WC_Encoding := 'b';
      Locking_Policy := ' ';
      Queuing_Policy := ' ';
      Task_Dispatching_Policy := ' ';
      System.Restrictions.Run_Time_Restrictions :=
        (Set =>
          (False, False, False, False, False, False, False, False, 
           False, False, False, False, False, False, False, False, 
           False, False, False, False, False, False, False, False, 
           False, False, False, False, False, False, False, False, 
           False, False, False, False, False, False, False, False, 
           False, False, False, False, False, False, False, False, 
           False, False, False, False, False, False, False, False, 
           False, False, False, False, False, False, False, False, 
           False, False, False, False, False, False, False, False, 
           False, False, False, False, False, False, False, False, 
           False, False, False, True, False, False, False, False, 
           False, False, False, False, False, False, False, False, 
           False, False, False, False),
         Value => (0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
         Violated =>
          (True, True, False, False, True, True, False, False, 
           True, False, False, True, True, True, True, False, 
           False, False, False, True, False, False, True, True, 
           False, True, True, False, True, True, True, True, 
           False, False, False, False, False, False, True, False, 
           False, True, False, True, False, True, True, False, 
           False, False, True, True, False, False, True, False, 
           True, False, False, False, False, False, False, False, 
           False, True, True, True, True, True, True, False, 
           True, False, True, True, True, False, True, True, 
           False, True, True, True, True, False, False, False, 
           False, False, False, False, False, True, True, True, 
           True, False, True, False),
         Count => (0, 0, 0, 2, 2, 1, 1, 0, 2, 0),
         Unknown => (False, False, False, False, False, False, False, False, True, False));
      Priority_Specific_Dispatching :=
        Local_Priority_Specific_Dispatching'Address;
      Num_Specific_Dispatching := 0;
      Main_CPU := -1;
      Interrupt_States := Local_Interrupt_States'Address;
      Num_Interrupt_States := 0;
      Unreserve_All_Interrupts := 0;
      Detect_Blocking := 0;
      Default_Stack_Size := -1;

      ada_main'Elab_Body;
      Default_Secondary_Stack_Size := System.Parameters.Runtime_Default_Sec_Stack_Size;
      Binder_Sec_Stacks_Count := 1;
      Default_Sized_SS_Pool := Sec_Default_Sized_Stacks'Address;

      Runtime_Initialize (1);

      Finalize_Library_Objects := finalize_library'access;

      Ada.Exceptions'Elab_Spec;
      System.Soft_Links'Elab_Spec;
      System.Exception_Table'Elab_Body;
      E027 := E027 + 1;
      Ada.Containers'Elab_Spec;
      E050 := E050 + 1;
      Ada.Io_Exceptions'Elab_Spec;
      E076 := E076 + 1;
      Ada.Numerics'Elab_Spec;
      E034 := E034 + 1;
      Ada.Strings'Elab_Spec;
      E063 := E063 + 1;
      Ada.Strings.Maps'Elab_Spec;
      E065 := E065 + 1;
      Ada.Strings.Maps.Constants'Elab_Spec;
      E068 := E068 + 1;
      Interfaces.C'Elab_Spec;
      E055 := E055 + 1;
      System.Exceptions'Elab_Spec;
      E028 := E028 + 1;
      System.Object_Reader'Elab_Spec;
      E090 := E090 + 1;
      System.Dwarf_Lines'Elab_Spec;
      System.Os_Lib'Elab_Body;
      E081 := E081 + 1;
      System.Soft_Links.Initialize'Elab_Body;
      E019 := E019 + 1;
      E017 := E017 + 1;
      System.Traceback.Symbolic'Elab_Body;
      E049 := E049 + 1;
      System.Img_Int'Elab_Spec;
      E033 := E033 + 1;
      E013 := E013 + 1;
      System.Img_Uns'Elab_Spec;
      E071 := E071 + 1;
      E060 := E060 + 1;
      Ada.Strings.Utf_Encoding'Elab_Spec;
      E117 := E117 + 1;
      Ada.Tags'Elab_Spec;
      Ada.Tags'Elab_Body;
      E125 := E125 + 1;
      Ada.Strings.Text_Buffers'Elab_Spec;
      E115 := E115 + 1;
      Interfaces.C.Strings'Elab_Spec;
      E178 := E178 + 1;
      Ada.Streams'Elab_Spec;
      E113 := E113 + 1;
      System.File_Control_Block'Elab_Spec;
      E166 := E166 + 1;
      System.Finalization_Root'Elab_Spec;
      E135 := E135 + 1;
      Ada.Finalization'Elab_Spec;
      E111 := E111 + 1;
      System.File_Io'Elab_Body;
      E163 := E163 + 1;
      System.Storage_Pools'Elab_Spec;
      E170 := E170 + 1;
      System.Finalization_Masters'Elab_Spec;
      System.Finalization_Masters'Elab_Body;
      E168 := E168 + 1;
      System.Storage_Pools.Subpools'Elab_Spec;
      E199 := E199 + 1;
      Ada.Strings.Unbounded'Elab_Spec;
      E147 := E147 + 1;
      System.Task_Info'Elab_Spec;
      E224 := E224 + 1;
      Ada.Calendar'Elab_Spec;
      Ada.Calendar'Elab_Body;
      E106 := E106 + 1;
      Ada.Text_Io'Elab_Spec;
      Ada.Text_Io'Elab_Body;
      E174 := E174 + 1;
      System.Pool_Global'Elab_Spec;
      E195 := E195 + 1;
      System.Regexp'Elab_Spec;
      E172 := E172 + 1;
      Ada.Directories'Elab_Spec;
      Ada.Directories'Elab_Body;
      E104 := E104 + 1;
      System.Img_Lli'Elab_Spec;
      E229 := E229 + 1;
      System.Task_Primitives.Operations'Elab_Body;
      E218 := E218 + 1;
      Ada.Real_Time'Elab_Spec;
      Ada.Real_Time'Elab_Body;
      E210 := E210 + 1;
      System.Tasking.Initialization'Elab_Body;
      E248 := E248 + 1;
      System.Tasking.Protected_Objects'Elab_Body;
      E236 := E236 + 1;
      System.Tasking.Protected_Objects.Entries'Elab_Spec;
      E252 := E252 + 1;
      System.Tasking.Queuing'Elab_Body;
      E254 := E254 + 1;
      System.Tasking.Stages'Elab_Body;
      E260 := E260 + 1;
      Cif_Datablock_Tag'Elab_Spec;
      E188 := E188 + 1;
      Cif_Io'Elab_Spec;
      E206 := E206 + 1;
      E180 := E180 + 1;
      Cif_Datablock'Elab_Spec;
      Cif_Datablock'Elab_Body;
      E176 := E176 + 1;
      Datablock_Queue'Elab_Spec;
      E263 := E263 + 1;
      Cif_Streaming_Parser'Elab_Spec;
      Cif_Streaming_Parser'Elab_Body;
      E208 := E208 + 1;
   end adainit;

   procedure Ada_Main_Program;
   pragma Import (Ada, Ada_Main_Program, "_ada_cif_tag_stats");

   function main
     (argc : Integer;
      argv : System.Address;
      envp : System.Address)
      return Integer
   is
      procedure Initialize (Addr : System.Address);
      pragma Import (C, Initialize, "__gnat_initialize");

      procedure Finalize;
      pragma Import (C, Finalize, "__gnat_finalize");
      SEH : aliased array (1 .. 2) of Integer;

      Ensure_Reference : aliased System.Address := Ada_Main_Program_Name'Address;
      pragma Volatile (Ensure_Reference);

   begin
      if gnat_argc = 0 then
         gnat_argc := argc;
         gnat_argv := argv;
      end if;
      gnat_envp := envp;

      Initialize (SEH'Address);
      adainit;
      Ada_Main_Program;
      adafinal;
      Finalize;
      return (gnat_exit_status);
   end;

--  BEGIN Object file/option list
   --   /home/saulius/src/cif-streaming-parser/trunk/obj/cexceptions_ada.o
   --   /home/saulius/src/cif-streaming-parser/trunk/obj/cif_datablock_tag.o
   --   /home/saulius/src/cif-streaming-parser/trunk/obj/cif_error_messages.o
   --   /home/saulius/src/cif-streaming-parser/trunk/obj/cif_io.o
   --   /home/saulius/src/cif-streaming-parser/trunk/obj/cif_options_ada.o
   --   /home/saulius/src/cif-streaming-parser/trunk/obj/logging.o
   --   /home/saulius/src/cif-streaming-parser/trunk/obj/cif_datablock.o
   --   /home/saulius/src/cif-streaming-parser/trunk/obj/datablock_queue.o
   --   /home/saulius/src/cif-streaming-parser/trunk/obj/cif_streaming_parser.o
   --   /home/saulius/src/cif-streaming-parser/trunk/obj/cif_tag_stats.o
   --   -L/home/saulius/src/cif-streaming-parser/trunk/obj/
   --   -L/home/saulius/src/cif-streaming-parser/trunk/obj/
   --   -L/home/saulius/install/gnat-alire/gnat-alire-13.2.1/lib/gcc/x86_64-pc-linux-gnu/13.2.0/adalib/
   --   -static
   --   -lgnarl
   --   -lgnat
   --   -lrt
   --   -lpthread
   --   -ldl
--  END Object file/option list   

end ada_main;
