
package body filter_lexer is


   function YYLex return Token is
      subtype Short is Integer range -32768 .. 32767;

      --  returned upon end-of-file
      YY_END_TOK : constant Integer := 0;
      subtype yy_state_type is Integer;
      YY_END_OF_BUFFER : constant := 15;
      INITIAL : constant := 0;
      yy_accept : constant array (0 .. 28) of Short :=
          (0,
        0,    0,   15,   14,   13,   12,    5,    6,    9,    7,
       11,   14,    8,    3,   10,    1,    2,    4,    3,    3,
        3,    0,    1,    2,    3,    0,    3,    0
       );

      yy_ec : constant array (ASCII.NUL .. Character'Last) of Short := (0,
        1,    1,    1,    1,    1,    1,    1,    1,    1,    2,
        1,    1,    1,    1,    1,    1,    1,    1,    1,    1,
        1,    1,    1,    1,    1,    1,    1,    1,    1,    1,
        1,    3,    1,    1,    1,    1,    1,    1,    1,    4,
        5,    6,    7,    1,    8,    9,   10,   11,   11,   11,
       11,   11,   11,   11,   11,   11,   11,    1,    1,    1,
       12,    1,    1,    1,   13,   13,   13,   13,   14,   13,
       13,   13,   13,   13,   13,   13,   13,   13,   13,   13,
       13,   13,   13,   13,   13,   13,   13,   13,   13,   13,
        1,    1,    1,    1,    1,    1,   15,   15,   15,   15,

       16,   15,   15,   15,   15,   15,   15,   15,   15,   15,
       15,   15,   15,   15,   15,   15,   15,   15,   15,   15,
       15,   15,    1,    1,    1,    1,    1,    1,    1,    1,
        1,    1,    1,    1,    1,    1,    1,    1,    1,    1,
        1,    1,    1,    1,    1,    1,    1,    1,    1,    1,
        1,    1,    1,    1,    1,    1,    1,    1,    1,    1,
        1,    1,    1,    1,    1,    1,    1,    1,    1,    1,
        1,    1,    1,    1,    1,    1,    1,    1,    1,    1,
        1,    1,    1,    1,    1,    1,    1,    1,    1,    1,
        1,    1,    1,    1,    1,    1,    1,    1,    1,    1,

        1,    1,    1,    1,    1,    1,    1,    1,    1,    1,
        1,    1,    1,    1,    1,    1,    1,    1,    1,    1,
        1,    1,    1,    1,    1,    1,    1,    1,    1,    1,
        1,    1,    1,    1,    1,    1,    1,    1,    1,    1,
        1,    1,    1,    1,    1,    1,    1,    1,    1,    1,
        1,    1,    1,    1,    1, others => 1

       );

      yy_meta : constant array (0 .. 16) of Short :=
          (0,
        1,    1,    1,    1,    1,    1,    2,    2,    1,    1,
        3,    1,    1,    4,    1,    4
       );

      yy_base : constant array (0 .. 30) of Short :=
          (0,
        0,    0,   40,   41,   41,   41,   41,   41,   33,   41,
       41,   27,   41,    8,   41,    7,   10,   41,   26,   25,
        0,   24,   14,   14,    0,   12,    7,   41,   28,   31
       );

      yy_def : constant array (0 .. 30) of Short :=
          (0,
       28,    1,   28,   28,   28,   28,   28,   28,   28,   28,
       28,   28,   28,   28,   28,   28,   28,   28,   29,   29,
       14,   30,   28,   28,   20,   28,   28,    0,   28,   28
       );

      yy_nxt : constant array (0 .. 57) of Short :=
          (0,
        4,    5,    6,    7,    8,    9,   10,   11,   12,   13,
       14,   15,   16,   16,   17,   17,   20,   27,   21,   23,
       23,   22,   27,   22,   24,   24,   23,   23,   24,   24,
       22,   22,   26,   26,   27,   25,   19,   19,   18,   28,
        3,   28,   28,   28,   28,   28,   28,   28,   28,   28,
       28,   28,   28,   28,   28,   28,   28
       );

      yy_chk : constant array (0 .. 57) of Short :=
          (0,
        1,    1,    1,    1,    1,    1,    1,    1,    1,    1,
        1,    1,    1,    1,    1,    1,   14,   27,   14,   16,
       16,   14,   26,   14,   17,   17,   23,   23,   24,   24,
       29,   29,   30,   30,   22,   20,   19,   12,    9,    3,
       28,   28,   28,   28,   28,   28,   28,   28,   28,   28,
       28,   28,   28,   28,   28,   28,   28
       );

      yy_act : Integer;
      yy_c   : Short;
      yy_current_state : yy_state_type;

      --  copy whatever the last rule matched to the standard output
      procedure ECHO is
      begin
         if Ada.Text_IO.Is_Open (user_output_file) then
            Ada.Text_IO.Put (user_output_file, YYText);
         else
            Ada.Text_IO.Put (YYText);
         end if;
      end ECHO;

      --  enter a start condition.
      --  Using procedure requires a () after the ENTER, but makes everything
      --  much neater.

      procedure ENTER (state : Integer) is
      begin
         yy_start := 1 + 2 * state;
      end ENTER;

      --  action number for EOF rule of a given start state
      function YY_STATE_EOF (state : Integer) return Integer is
      begin
         return YY_END_OF_BUFFER + state + 1;
      end YY_STATE_EOF;

      --  return all but the first 'n' matched characters back to the input stream
      procedure yyless (n : Integer) is
      begin
         yy_ch_buf (yy_cp) := yy_hold_char; --  undo effects of setting up yytext
         yy_cp := yy_bp + n;
         yy_c_buf_p := yy_cp;
         YY_DO_BEFORE_ACTION; -- set up yytext again
      end yyless;

      --  yy_get_previous_state - get the state just before the EOB char was reached

      function yy_get_previous_state return yy_state_type is
         yy_current_state : yy_state_type;
         yy_c : Short;
      begin
         yy_current_state := yy_start;

         for yy_cp in yytext_ptr .. yy_c_buf_p - 1 loop
            yy_c := yy_ec (yy_ch_buf (yy_cp));
            if yy_accept (yy_current_state) /= 0 then
               yy_last_accepting_state := yy_current_state;
               yy_last_accepting_cpos := yy_cp;
            end if;
            while yy_chk (yy_base (yy_current_state) + yy_c) /= yy_current_state loop
               yy_current_state := yy_def (yy_current_state);
               if yy_current_state >= 29 then
                  yy_c := yy_meta (yy_c);
               end if;
            end loop;
            yy_current_state := yy_nxt (yy_base (yy_current_state) + yy_c);
         end loop;

         return yy_current_state;
      end yy_get_previous_state;

      procedure yyrestart (input_file : File_Type) is
      begin
         Open_Input (Ada.Text_IO.Name (input_file));
      end yyrestart;

   begin -- of YYLex
      <<new_file>>
      --  this is where we enter upon encountering an end-of-file and
      --  yyWrap () indicating that we should continue processing

      if yy_init then
         if yy_start = 0 then
            yy_start := 1;      -- first start state
         end if;

         --  we put in the '\n' and start reading from [1] so that an
         --  initial match-at-newline will be true.

         yy_ch_buf (0) := ASCII.LF;
         yy_n_chars := 1;

         --  we always need two end-of-buffer characters. The first causes
         --  a transition to the end-of-buffer state. The second causes
         --  a jam in that state.

         yy_ch_buf (yy_n_chars) := YY_END_OF_BUFFER_CHAR;
         yy_ch_buf (yy_n_chars + 1) := YY_END_OF_BUFFER_CHAR;

         yy_eof_has_been_seen := False;

         yytext_ptr := 1;
         yy_c_buf_p := yytext_ptr;
         yy_hold_char := yy_ch_buf (yy_c_buf_p);
         yy_init := False;
      end if; -- yy_init

      loop                -- loops until end-of-file is reached

         yy_cp := yy_c_buf_p;

         --  support of yytext
         yy_ch_buf (yy_cp) := yy_hold_char;

         --  yy_bp points to the position in yy_ch_buf of the start of the
         --  current run.
         yy_bp := yy_cp;
         yy_current_state := yy_start;
         loop
               yy_c := yy_ec (yy_ch_buf (yy_cp));
               if yy_accept (yy_current_state) /= 0 then
                  yy_last_accepting_state := yy_current_state;
                  yy_last_accepting_cpos := yy_cp;
               end if;
               while yy_chk (yy_base (yy_current_state) + yy_c) /= yy_current_state loop
                  yy_current_state := yy_def (yy_current_state);
                  if yy_current_state >= 29 then
                     yy_c := yy_meta (yy_c);
                  end if;
               end loop;
               yy_current_state := yy_nxt (yy_base (yy_current_state) + yy_c);
            yy_cp := yy_cp + 1;
            if yy_current_state = 28 then
                exit;
            end if;
         end loop;
         yy_cp := yy_last_accepting_cpos;
         yy_current_state := yy_last_accepting_state;

   <<next_action>>
         yy_act := yy_accept (yy_current_state);
         YY_DO_BEFORE_ACTION;

         if aflex_debug then  -- output acceptance info. for (-d) debug mode
            Ada.Text_IO.Put (Standard_Error, "  -- Aflex.YYLex accept rule #");
            Ada.Text_IO.Put (Standard_Error, Integer'Image (yy_act));
            Ada.Text_IO.Put_Line (Standard_Error, "(""" & YYText & """)");
         end if;

   <<do_action>>   -- this label is used only to access EOF actions
         case yy_act is

            when 0 => -- must backtrack
            -- undo the effects of YY_DO_BEFORE_ACTION
            yy_ch_buf (yy_cp) := yy_hold_char;
            yy_cp := yy_last_accepting_cpos;
            yy_current_state := yy_last_accepting_state;
            goto next_action;



         when 1 =>
--# line 9 "filter_lexer.l"
            
              yylval.S := To_Unbounded_String (filter_lexer_dfa.yytext);
              return KEYWORD_TOKEN;
            

         when 2 =>
--# line 13 "filter_lexer.l"
            
              yylval.S := To_Unbounded_String (filter_lexer_dfa.yytext);
              return IDENTIFIER_TOKEN;
            

         when 3 =>
--# line 17 "filter_lexer.l"
            
              yylval.N := Float'Value (filter_lexer_dfa.yytext);
              return NUMBER_TOKEN;
            

         when 4 =>
--# line 21 "filter_lexer.l"
             return EXP; 

         when 5 =>
--# line 22 "filter_lexer.l"
             return '('; 

         when 6 =>
--# line 23 "filter_lexer.l"
             return ')'; 

         when 7 =>
--# line 24 "filter_lexer.l"
             return '+'; 

         when 8 =>
--# line 25 "filter_lexer.l"
             return '/'; 

         when 9 =>
--# line 26 "filter_lexer.l"
             return '*'; 

         when 10 =>
--# line 27 "filter_lexer.l"
             return '='; 

         when 11 =>
--# line 28 "filter_lexer.l"
             return '-'; 

         when 12 =>
--# line 29 "filter_lexer.l"
             return ' '; 

         when 13 =>
--# line 30 "filter_lexer.l"
             return LF_TOKEN; 

         when 14 =>
--# line 31 "filter_lexer.l"
            ECHO;
         when YY_END_OF_BUFFER + INITIAL + 1 =>
            return End_Of_Input;

         when YY_END_OF_BUFFER =>
            --  undo the effects of YY_DO_BEFORE_ACTION
            yy_ch_buf (yy_cp) := yy_hold_char;

            yytext_ptr := yy_bp;

            case yy_get_next_buffer is
               when EOB_ACT_END_OF_FILE =>
                  if yyWrap then
                     --  note: because we've taken care in
                     --  yy_get_next_buffer() to have set up yytext,
                     --  we can now set up yy_c_buf_p so that if some
                     --  total hoser (like aflex itself) wants
                     --  to call the scanner after we return the
                     --  End_Of_Input, it'll still work - another
                     --  End_Of_Input will get returned.

                     yy_c_buf_p := yytext_ptr;

                     yy_act := YY_STATE_EOF ((yy_start - 1) / 2);

                     goto do_action;
                  else
                     --  start processing a new file
                     yy_init := True;
                     goto new_file;
                  end if;

               when EOB_ACT_RESTART_SCAN =>
                  yy_c_buf_p := yytext_ptr;
                  yy_hold_char := yy_ch_buf (yy_c_buf_p);

               when EOB_ACT_LAST_MATCH =>
                  yy_c_buf_p := yy_n_chars;
                  yy_current_state := yy_get_previous_state;
                  yy_cp := yy_c_buf_p;
                  yy_bp := yytext_ptr;
                  goto next_action;
            end case; --  case yy_get_next_buffer()

         when others =>
            Ada.Text_IO.Put ("action # ");
            Ada.Text_IO.Put (Integer'Image (yy_act));
            Ada.Text_IO.New_Line;
            raise AFLEX_INTERNAL_ERROR;
         end case; --  case (yy_act)
      end loop; --  end of loop waiting for end of file
   end YYLex;

--# line 31 "filter_lexer.l"

end filter_lexer;

