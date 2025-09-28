
package body filter_lexer is


   function YYLex return Token is
      subtype Short is Integer range -32768 .. 32767;

      --  returned upon end-of-file
      YY_END_TOK : constant Integer := 0;
      subtype yy_state_type is Integer;
      YY_END_OF_BUFFER : constant := 40;
      INITIAL : constant := 0;
      yy_accept : constant array (0 .. 107) of Short :=
          (0,
        0,    0,   40,   38,   35,   33,   36,   37,   34,   29,
       38,   22,   23,   24,   31,   28,   30,   20,   32,   27,
       25,   26,   18,   18,   18,   18,   18,   18,   18,   18,
       18,   18,   18,   18,   18,   18,   18,   19,    0,   21,
        0,    0,   20,   20,   20,    0,   18,   18,   18,   18,
       18,   18,   18,    4,   18,   18,   18,   18,    3,   18,
       18,   18,   18,   19,   21,   20,    0,   20,   13,    1,
       15,   18,   18,   18,   12,   18,   18,    2,   18,   18,
       18,   18,   18,   18,    9,   18,   18,   18,   14,   18,
       16,   18,   10,   18,   17,    5,   18,   18,   18,   18,

       11,    8,   18,   18,    6,    7,    0
       );

      yy_ec : constant array (ASCII.NUL .. Character'Last) of Short := (0,
        1,    1,    1,    1,    1,    1,    1,    1,    2,    3,
        4,    5,    6,    1,    1,    1,    1,    1,    1,    1,
        1,    1,    1,    1,    1,    1,    1,    1,    1,    1,
        1,    7,    1,    8,    1,    1,    1,    1,    1,    9,
       10,    1,   11,   12,   13,   14,    1,   15,   15,   15,
       15,   15,   15,   15,   15,   15,   15,   16,    1,   17,
       18,   19,    1,    1,   20,   21,   22,   23,   24,   25,
       26,   27,   28,   21,   29,   30,   21,   31,   32,   21,
       21,   33,   34,   35,   36,   21,   37,   21,   38,   21,
        1,   39,    1,    1,   40,    1,   40,   40,   40,   40,

       41,   40,   40,   40,   40,   40,   40,   40,   40,   40,
       40,   40,   40,   40,   40,   40,   40,   40,   40,   40,
       40,   40,    1,    1,    1,    1,    1,    1,    1,    1,
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

      yy_meta : constant array (0 .. 41) of Short :=
          (0,
        1,    1,    2,    1,    1,    1,    1,    1,    1,    1,
        1,    1,    1,    1,    1,    1,    1,    1,    1,    3,
        3,    3,    3,    3,    3,    3,    3,    3,    3,    3,
        3,    3,    3,    3,    3,    3,    3,    3,    1,    1,
        1
       );

      yy_base : constant array (0 .. 109) of Short :=
          (0,
        0,    0,  139,  140,  140,  140,  140,  140,  140,  140,
       34,  140,  140,   29,  140,   31,  123,   33,  140,  140,
      140,  140,   19,    0,  105,  105,  115,  114,   99,  101,
      107,   98,   20,   94,   95,   96,   98,   14,   44,  140,
       48,  110,   44,   45,   47,   50,    0,   94,   41,   92,
       99,   91,   86,    0,   87,   87,   82,   86,    0,   95,
       78,   84,   77,   26,   62,   57,   96,   95,    0,    0,
        0,   74,   74,   73,    0,   69,   79,    0,   65,   67,
       75,   66,   69,   75,    0,   70,   62,   57,    0,   56,
        0,   58,    0,   61,    0,    0,   57,   48,   43,   47,

        0,    0,   46,   42,    0,    0,  140,  101,   72
       );

      yy_def : constant array (0 .. 109) of Short :=
          (0,
      107,    1,  107,  107,  107,  107,  107,  107,  107,  107,
      108,  107,  107,  107,  107,  107,  107,  107,  107,  107,
      107,  107,  109,  109,  109,  109,  109,  109,  109,  109,
      109,  109,  109,  109,  109,  109,  109,  107,  108,  107,
      108,  107,  107,  107,  107,  107,  109,  109,  109,  109,
      109,  109,  109,  109,  109,  109,  109,  109,  109,  109,
      109,  109,  109,  107,  108,  107,  107,  107,  109,  109,
      109,  109,  109,  109,  109,  109,  109,  109,  109,  109,
      109,  109,  109,  109,  109,  109,  109,  109,  109,  109,
      109,  109,  109,  109,  109,  109,  109,  109,  109,  109,

      109,  109,  109,  109,  109,  109,    0,  107,  107
       );

      yy_nxt : constant array (0 .. 181) of Short :=
          (0,
        4,    5,    6,    7,    8,    9,   10,   11,   12,   13,
       14,   15,   16,   17,   18,   19,   20,   21,   22,   23,
       24,   25,   24,   26,   27,   24,   28,   29,   30,   31,
       32,   33,   24,   34,   35,   36,   37,   24,    4,   38,
       38,   40,   42,   43,   42,   43,   45,   43,   48,   49,
       58,   40,   59,   64,   64,   65,   46,   45,   43,   44,
       67,   66,   67,   70,   68,   64,   64,   46,   46,   40,
       46,   66,   41,   46,   47,  106,  105,  104,   71,  103,
       46,  102,   41,  101,   46,   46,   41,   46,  100,   99,
       98,   97,   96,   95,   94,   93,   92,   46,   91,   90,

       41,   39,   89,   39,   88,   87,   86,   85,   84,   68,
       68,   83,   82,   81,   80,   79,   78,   77,   76,   75,
       74,   73,   72,   69,   44,   63,   62,   61,   60,   57,
       56,   55,   54,   53,   52,   51,   50,   44,  107,    3,
      107,  107,  107,  107,  107,  107,  107,  107,  107,  107,
      107,  107,  107,  107,  107,  107,  107,  107,  107,  107,
      107,  107,  107,  107,  107,  107,  107,  107,  107,  107,
      107,  107,  107,  107,  107,  107,  107,  107,  107,  107,
      107
       );

      yy_chk : constant array (0 .. 181) of Short :=
          (0,
        1,    1,    1,    1,    1,    1,    1,    1,    1,    1,
        1,    1,    1,    1,    1,    1,    1,    1,    1,    1,
        1,    1,    1,    1,    1,    1,    1,    1,    1,    1,
        1,    1,    1,    1,    1,    1,    1,    1,    1,    1,
        1,   11,   14,   14,   16,   16,   18,   18,   23,   23,
       33,   39,   33,   38,   38,   41,   18,   43,   43,   44,
       46,   45,   46,   49,   46,   64,   64,   43,   44,   65,
       45,   66,   11,   18,  109,  104,  103,  100,   49,   99,
       66,   98,   39,   97,   43,   44,   41,   45,   94,   92,
       90,   88,   87,   86,   84,   83,   82,   66,   81,   80,

       65,  108,   79,  108,   77,   76,   74,   73,   72,   68,
       67,   63,   62,   61,   60,   58,   57,   56,   55,   53,
       52,   51,   50,   48,   42,   37,   36,   35,   34,   32,
       31,   30,   29,   28,   27,   26,   25,   17,    3,  107,
      107,  107,  107,  107,  107,  107,  107,  107,  107,  107,
      107,  107,  107,  107,  107,  107,  107,  107,  107,  107,
      107,  107,  107,  107,  107,  107,  107,  107,  107,  107,
      107,  107,  107,  107,  107,  107,  107,  107,  107,  107,
      107
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
               if yy_current_state >= 108 then
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
                  if yy_current_state >= 108 then
                     yy_c := yy_meta (yy_c);
                  end if;
               end loop;
               yy_current_state := yy_nxt (yy_base (yy_current_state) + yy_c);
            yy_cp := yy_cp + 1;
            if yy_current_state = 107 then
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
--# line 13 "filter_lexer.l"
             yylval.C := '&'; return AND_TOKEN; 

         when 2 =>
--# line 14 "filter_lexer.l"
             yylval.C := '!'; return NOT_TOKEN; 

         when 3 =>
--# line 15 "filter_lexer.l"
             yylval.C := '|'; return OR_TOKEN; 

         when 4 =>
--# line 16 "filter_lexer.l"
             yylval.C := 'I'; return IS_TOKEN; 

         when 5 =>
--# line 17 "filter_lexer.l"
             yylval.C := 'U'; return KNOWN_TOKEN; 

         when 6 =>
--# line 18 "filter_lexer.l"
             yylval.C := '?'; return UNKNOWN_TOKEN; 

         when 7 =>
--# line 19 "filter_lexer.l"
             yylval.C := 'C'; return CONTAINS_TOKEN; 

         when 8 =>
--# line 20 "filter_lexer.l"
             yylval.C := 'S'; return STARTS_TOKEN; 

         when 9 =>
--# line 21 "filter_lexer.l"
             yylval.C := 'E'; return ENDS_TOKEN; 

         when 10 =>
--# line 22 "filter_lexer.l"
             yylval.C := 'W'; return WITH_TOKEN; 

         when 11 =>
--# line 23 "filter_lexer.l"
             yylval.C := 'L'; return LENGTH_TOKEN; 

         when 12 =>
--# line 24 "filter_lexer.l"
             yylval.C := 'H'; return HAS_TOKEN; 

         when 13 =>
--# line 25 "filter_lexer.l"
             yylval.C := 'A'; return ALL_TOKEN; 

         when 14 =>
--# line 26 "filter_lexer.l"
             yylval.C := 'O'; return ONLY_TOKEN; 

         when 15 =>
--# line 27 "filter_lexer.l"
             yylval.C := 'N'; return ANY_TOKEN; 

         when 16 =>
--# line 29 "filter_lexer.l"
             yylval.C := 'T'; return TRUE_TOKEN; 

         when 17 =>
--# line 30 "filter_lexer.l"
             yylval.C := 'F'; return FALSE_TOKEN; 

         when 18 =>
--# line 32 "filter_lexer.l"
            
              yylval.S := To_Unbounded_String (filter_lexer_dfa.yytext);
              return KEYWORD_TOKEN;
            

         when 19 =>
--# line 36 "filter_lexer.l"
            
              yylval.S := To_Unbounded_String (filter_lexer_dfa.yytext);
              return IDENTIFIER_TOKEN;
            

         when 20 =>
--# line 40 "filter_lexer.l"
            
              yylval.N := Float'Value (filter_lexer_dfa.yytext);
              return NUMBER_TOKEN;
            

         when 21 =>
--# line 44 "filter_lexer.l"
            
              yylval.S := To_Unbounded_String (yytext (yytext'First+1 .. yytext'Last-1));
              return STRING_TOKEN;
            

         when 22 =>
--# line 48 "filter_lexer.l"
             yylval.C := filter_lexer_dfa.yytext(1); return '('; 

         when 23 =>
--# line 49 "filter_lexer.l"
             yylval.C := filter_lexer_dfa.yytext(1); return ')'; 

         when 24 =>
--# line 50 "filter_lexer.l"
             yylval.C := filter_lexer_dfa.yytext(1); return '+'; 

         when 25 =>
--# line 51 "filter_lexer.l"
             yylval.C := filter_lexer_dfa.yytext(1); return '='; 

         when 26 =>
--# line 52 "filter_lexer.l"
             yylval.C := filter_lexer_dfa.yytext(1); return '>'; 

         when 27 =>
--# line 53 "filter_lexer.l"
             yylval.C := filter_lexer_dfa.yytext(1); return '<'; 

         when 28 =>
--# line 54 "filter_lexer.l"
             yylval.C := filter_lexer_dfa.yytext(1); return '-'; 

         when 29 =>
--# line 55 "filter_lexer.l"
             yylval.C := filter_lexer_dfa.yytext(1); return ' '; 

         when 30 =>
--# line 56 "filter_lexer.l"
             yylval.C := filter_lexer_dfa.yytext(1); return '.'; 

         when 31 =>
--# line 57 "filter_lexer.l"
             yylval.C := filter_lexer_dfa.yytext(1); return ','; 

         when 32 =>
--# line 58 "filter_lexer.l"
             yylval.C := filter_lexer_dfa.yytext(1); return ':'; 

         when 33 =>
--# line 60 "filter_lexer.l"
             return LF_TOKEN; 

         when 34 =>
--# line 61 "filter_lexer.l"
             return CR_TOKEN; 

         when 35 =>
--# line 62 "filter_lexer.l"
             return HT_TOKEN; 

         when 36 =>
--# line 63 "filter_lexer.l"
             return VT_TOKEN; 

         when 37 =>
--# line 64 "filter_lexer.l"
             return FF_TOKEN; 

         when 38 =>
--# line 66 "filter_lexer.l"
             yylval.C := filter_lexer_dfa.yytext(1); return ERROR; 

         when 39 =>
--# line 68 "filter_lexer.l"
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

--# line 68 "filter_lexer.l"

end filter_lexer;

