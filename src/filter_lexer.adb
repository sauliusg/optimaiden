
package body filter_lexer is


   function YYLex return Token is
      subtype Short is Integer range -32768 .. 32767;

      --  returned upon end-of-file
      YY_END_TOK : constant Integer := 0;
      subtype yy_state_type is Integer;
      YY_END_OF_BUFFER : constant := 36;
      INITIAL : constant := 0;
      yy_accept : constant array (0 .. 105) of Short :=
          (0,
        0,    0,   36,   35,   32,   30,   33,   34,   31,   29,
       35,   22,   23,   24,   28,   35,   20,   27,   25,   26,
       18,   18,   18,   18,   18,   18,   18,   18,   18,   18,
       18,   18,   18,   18,   18,   19,    0,   21,    0,    0,
       20,   20,   20,    0,   18,   18,   18,   18,   18,   18,
       18,    4,   18,   18,   18,   18,    3,   18,   18,   18,
       18,   19,   21,   20,    0,   20,   13,    1,   15,   18,
       18,   18,   12,   18,   18,    2,   18,   18,   18,   18,
       18,   18,    9,   18,   18,   18,   14,   18,   16,   18,
       10,   18,   17,    5,   18,   18,   18,   18,   11,    8,

       18,   18,    6,    7,    0
       );

      yy_ec : constant array (ASCII.NUL .. Character'Last) of Short := (0,
        1,    1,    1,    1,    1,    1,    1,    1,    2,    3,
        4,    5,    6,    1,    1,    1,    1,    1,    1,    1,
        1,    1,    1,    1,    1,    1,    1,    1,    1,    1,
        1,    7,    1,    8,    1,    1,    1,    1,    1,    9,
       10,    1,   11,    1,   12,   13,    1,   14,   14,   14,
       14,   14,   14,   14,   14,   14,   14,    1,    1,   15,
       16,   17,    1,    1,   18,   19,   20,   21,   22,   23,
       24,   25,   26,   19,   27,   28,   19,   29,   30,   19,
       19,   31,   32,   33,   34,   19,   35,   19,   36,   19,
        1,   37,    1,    1,   38,    1,   38,   38,   38,   38,

       39,   38,   38,   38,   38,   38,   38,   38,   38,   38,
       38,   38,   38,   38,   38,   38,   38,   38,   38,   38,
       38,   38,    1,    1,    1,    1,    1,    1,    1,    1,
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

      yy_meta : constant array (0 .. 39) of Short :=
          (0,
        1,    1,    2,    1,    1,    1,    1,    1,    1,    1,
        1,    1,    1,    1,    1,    1,    1,    3,    3,    3,
        3,    3,    3,    3,    3,    3,    3,    3,    3,    3,
        3,    3,    3,    3,    3,    3,    1,    1,    1
       );

      yy_base : constant array (0 .. 107) of Short :=
          (0,
        0,    0,  137,  138,  138,  138,  138,  138,  138,  138,
       32,  138,  138,   28,   30,  122,   32,  138,  138,  138,
       19,    0,  105,  105,  115,  114,   99,  101,  107,   98,
       20,   94,   95,   96,   98,   14,   42,  138,   47,  109,
       43,   44,   46,   50,    0,   94,   38,   92,   99,   91,
       86,    0,   87,   87,   82,   86,    0,   95,   78,   84,
       77,   34,   55,   56,   95,   94,    0,    0,    0,   74,
       74,   73,    0,   69,   79,    0,   66,   70,   78,   70,
       72,   76,    0,   71,   62,   57,    0,   56,    0,   58,
        0,   61,    0,    0,   61,   49,   45,   48,    0,    0,

       47,   43,    0,    0,  138,   95,   64
       );

      yy_def : constant array (0 .. 107) of Short :=
          (0,
      105,    1,  105,  105,  105,  105,  105,  105,  105,  105,
      106,  105,  105,  105,  105,  105,  105,  105,  105,  105,
      107,  107,  107,  107,  107,  107,  107,  107,  107,  107,
      107,  107,  107,  107,  107,  105,  106,  105,  106,  105,
      105,  105,  105,  105,  107,  107,  107,  107,  107,  107,
      107,  107,  107,  107,  107,  107,  107,  107,  107,  107,
      107,  105,  106,  105,  105,  105,  107,  107,  107,  107,
      107,  107,  107,  107,  107,  107,  107,  107,  107,  107,
      107,  107,  107,  107,  107,  107,  107,  107,  107,  107,
      107,  107,  107,  107,  107,  107,  107,  107,  107,  107,

      107,  107,  107,  107,    0,  105,  105
       );

      yy_nxt : constant array (0 .. 177) of Short :=
          (0,
        4,    5,    6,    7,    8,    9,   10,   11,   12,   13,
       14,   15,   16,   17,   18,   19,   20,   21,   22,   23,
       22,   24,   25,   22,   26,   27,   28,   29,   30,   31,
       22,   32,   33,   34,   35,   22,    4,   36,   36,   38,
       40,   41,   40,   41,   43,   41,   46,   47,   56,   38,
       57,   62,   62,   44,   63,   43,   41,   42,   68,   64,
       65,   65,   38,   66,   44,   44,   45,   44,   39,   64,
       44,   62,   62,   69,  104,  103,  102,   44,   39,  101,
      100,   44,   44,   39,   44,   99,   98,   97,   96,   95,
       94,   39,   93,   92,   44,   37,   91,   37,   90,   89,

       88,   87,   86,   85,   84,   83,   82,   66,   66,   81,
       80,   79,   78,   77,   76,   75,   74,   73,   72,   71,
       70,   67,   42,   61,   60,   59,   58,   55,   54,   53,
       52,   51,   50,   49,   48,   42,  105,    3,  105,  105,
      105,  105,  105,  105,  105,  105,  105,  105,  105,  105,
      105,  105,  105,  105,  105,  105,  105,  105,  105,  105,
      105,  105,  105,  105,  105,  105,  105,  105,  105,  105,
      105,  105,  105,  105,  105,  105,  105
       );

      yy_chk : constant array (0 .. 177) of Short :=
          (0,
        1,    1,    1,    1,    1,    1,    1,    1,    1,    1,
        1,    1,    1,    1,    1,    1,    1,    1,    1,    1,
        1,    1,    1,    1,    1,    1,    1,    1,    1,    1,
        1,    1,    1,    1,    1,    1,    1,    1,    1,   11,
       14,   14,   15,   15,   17,   17,   21,   21,   31,   37,
       31,   36,   36,   17,   39,   41,   41,   42,   47,   43,
       44,   44,   63,   44,   41,   42,  107,   43,   11,   64,
       17,   62,   62,   47,  102,  101,   98,   64,   37,   97,
       96,   41,   42,   39,   43,   95,   92,   90,   88,   86,
       85,   63,   84,   82,   64,  106,   81,  106,   80,   79,

       78,   77,   75,   74,   72,   71,   70,   66,   65,   61,
       60,   59,   58,   56,   55,   54,   53,   51,   50,   49,
       48,   46,   40,   35,   34,   33,   32,   30,   29,   28,
       27,   26,   25,   24,   23,   16,    3,  105,  105,  105,
      105,  105,  105,  105,  105,  105,  105,  105,  105,  105,
      105,  105,  105,  105,  105,  105,  105,  105,  105,  105,
      105,  105,  105,  105,  105,  105,  105,  105,  105,  105,
      105,  105,  105,  105,  105,  105,  105
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
               if yy_current_state >= 106 then
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
                  if yy_current_state >= 106 then
                     yy_c := yy_meta (yy_c);
                  end if;
               end loop;
               yy_current_state := yy_nxt (yy_base (yy_current_state) + yy_c);
            yy_cp := yy_cp + 1;
            if yy_current_state = 105 then
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
              Put_Line (">>> Token: KEYWORD_TOKEN, """ & To_String (yylval.S) & """");
              return KEYWORD_TOKEN;
            

         when 19 =>
--# line 37 "filter_lexer.l"
            
              yylval.S := To_Unbounded_String (filter_lexer_dfa.yytext);
              Put_Line (">>> Token: IDENTIFIER_TOKEN, """ & To_String (yylval.S) & """");
              return IDENTIFIER_TOKEN;
            

         when 20 =>
--# line 42 "filter_lexer.l"
            
              yylval.N := Float'Value (filter_lexer_dfa.yytext);
              Put_Line (">>> Token: NUMBER_TOKEN, """ &
              filter_lexer_dfa.yytext & """" & " (" & yylval.N'Image & ")");
              return NUMBER_TOKEN;
            

         when 21 =>
--# line 48 "filter_lexer.l"
            
              yylval.S := To_Unbounded_String (yytext (yytext'First+1 .. yytext'Last-1));
              return STRING_TOKEN;
            

         when 22 =>
--# line 52 "filter_lexer.l"
             yylval.C := filter_lexer_dfa.yytext(1); return '('; 

         when 23 =>
--# line 53 "filter_lexer.l"
             yylval.C := filter_lexer_dfa.yytext(1); return ')'; 

         when 24 =>
--# line 54 "filter_lexer.l"
             yylval.C := filter_lexer_dfa.yytext(1); return '+'; 

         when 25 =>
--# line 55 "filter_lexer.l"
             yylval.C := filter_lexer_dfa.yytext(1); return '='; 

         when 26 =>
--# line 56 "filter_lexer.l"
             yylval.C := filter_lexer_dfa.yytext(1); return '>'; 

         when 27 =>
--# line 57 "filter_lexer.l"
             yylval.C := filter_lexer_dfa.yytext(1); return '<'; 

         when 28 =>
--# line 58 "filter_lexer.l"
             yylval.C := filter_lexer_dfa.yytext(1); return '-'; 

         when 29 =>
--# line 59 "filter_lexer.l"
             yylval.C := filter_lexer_dfa.yytext(1); return ' '; 

         when 30 =>
--# line 61 "filter_lexer.l"
             return LF_TOKEN; 

         when 31 =>
--# line 62 "filter_lexer.l"
             return CR_TOKEN; 

         when 32 =>
--# line 63 "filter_lexer.l"
             return HT_TOKEN; 

         when 33 =>
--# line 64 "filter_lexer.l"
             return VT_TOKEN; 

         when 34 =>
--# line 65 "filter_lexer.l"
             return FF_TOKEN; 

         when 35 =>
--# line 66 "filter_lexer.l"
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

--# line 66 "filter_lexer.l"

end filter_lexer;

