
package body Filter_Lexer is


   function YYLex return Token is
      subtype Short is Integer range -32768 .. 32767;

      --  returned upon end-of-file
      YY_END_TOK : constant Integer := 0;
      subtype yy_state_type is Integer;
      YY_END_OF_BUFFER : constant := 29;
      INITIAL : constant := 0;
      yy_accept : constant array (0 .. 98) of Short :=
          (0,
        0,    0,   29,   27,   24,   22,   25,   26,   23,   27,
       27,   27,   20,   18,   18,   18,   18,   18,   18,   18,
       18,   18,   18,   18,   18,   18,   18,   18,   19,    0,
       21,    0,    0,   20,   20,   20,    0,   18,   18,   18,
       18,   18,   18,   18,    4,   18,   18,   18,   18,    3,
       18,   18,   18,   18,   19,   21,   20,    0,   20,   13,
        1,   15,   18,   18,   18,   12,   18,   18,    2,   18,
       18,   18,   18,   18,   18,    9,   18,   18,   18,   14,
       18,   16,   18,   10,   18,   17,    5,   18,   18,   18,
       18,   11,    8,   18,   18,    6,    7,    0

       );

      yy_ec : constant array (ASCII.NUL .. Character'Last) of Short := (0,
        1,    1,    1,    1,    1,    1,    1,    1,    2,    3,
        4,    5,    6,    1,    1,    1,    1,    1,    1,    1,
        1,    1,    1,    1,    1,    1,    1,    1,    1,    1,
        1,    1,    1,    7,    1,    1,    1,    1,    1,    1,
        1,    1,    8,    1,    8,    9,    1,   10,   10,   10,
       10,   10,   10,   10,   10,   10,   10,    1,    1,    1,
        1,    1,    1,    1,   11,   12,   13,   14,   15,   16,
       17,   18,   19,   12,   20,   21,   12,   22,   23,   12,
       12,   24,   25,   26,   27,   12,   28,   12,   29,   12,
        1,   30,    1,    1,   31,    1,   31,   31,   31,   31,

       32,   31,   31,   31,   31,   31,   31,   31,   31,   31,
       31,   31,   31,   31,   31,   31,   31,   31,   31,   31,
       31,   31,    1,    1,    1,    1,    1,    1,    1,    1,
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

      yy_meta : constant array (0 .. 32) of Short :=
          (0,
        1,    1,    2,    1,    1,    1,    1,    1,    1,    1,
        3,    3,    3,    3,    3,    3,    3,    3,    3,    3,
        3,    3,    3,    3,    3,    3,    3,    3,    3,    1,
        1,    1
       );

      yy_base : constant array (0 .. 100) of Short :=
          (0,
        0,    0,  129,  130,  130,  130,  130,  130,  130,   26,
       25,  118,   27,   17,    0,  104,  104,  114,  113,   98,
      100,  106,   97,   19,   93,   94,   95,   97,   30,   37,
      130,   38,  105,   37,   38,   39,   47,    0,   93,   36,
       91,   98,   90,   85,    0,   86,   86,   81,   85,    0,
       94,   77,   83,   76,   41,   51,   64,   91,   90,    0,
        0,    0,   72,   70,   69,    0,   65,   75,    0,   62,
       66,   74,   66,   69,   75,    0,   70,   62,   57,    0,
       56,    0,   57,    0,   59,    0,    0,   59,   51,   47,
       44,    0,    0,   42,   38,    0,    0,  130,   96,   57

       );

      yy_def : constant array (0 .. 100) of Short :=
          (0,
       98,    1,   98,   98,   98,   98,   98,   98,   98,   99,
       98,   98,   98,  100,  100,  100,  100,  100,  100,  100,
      100,  100,  100,  100,  100,  100,  100,  100,   98,   99,
       98,   99,   98,   98,   98,   98,   98,  100,  100,  100,
      100,  100,  100,  100,  100,  100,  100,  100,  100,  100,
      100,  100,  100,  100,   98,   99,   98,   98,   98,  100,
      100,  100,  100,  100,  100,  100,  100,  100,  100,  100,
      100,  100,  100,  100,  100,  100,  100,  100,  100,  100,
      100,  100,  100,  100,  100,  100,  100,  100,  100,  100,
      100,  100,  100,  100,  100,  100,  100,    0,   98,   98

       );

      yy_nxt : constant array (0 .. 162) of Short :=
          (0,
        4,    5,    6,    7,    8,    9,   10,   11,   12,   13,
       14,   15,   16,   15,   17,   18,   15,   19,   20,   21,
       22,   23,   24,   15,   25,   26,   27,   28,   15,    4,
       29,   29,   31,   33,   34,   36,   34,   39,   40,   55,
       49,   37,   50,   31,   56,   36,   34,   35,   57,   61,
       55,   37,   37,   37,   58,   32,   59,   31,   37,   38,
       55,   55,   97,   96,   62,   95,   32,   32,   37,   37,
       37,   55,   55,   57,   94,   93,   92,   91,   37,   90,
       32,   89,   88,   87,   86,   85,   84,   83,   82,   81,
       80,   79,   78,   77,   76,   37,   30,   75,   30,   59,

       59,   74,   73,   72,   71,   70,   69,   68,   67,   66,
       65,   64,   63,   60,   35,   54,   53,   52,   51,   48,
       47,   46,   45,   44,   43,   42,   41,   35,   98,    3,
       98,   98,   98,   98,   98,   98,   98,   98,   98,   98,
       98,   98,   98,   98,   98,   98,   98,   98,   98,   98,
       98,   98,   98,   98,   98,   98,   98,   98,   98,   98,
       98,   98
       );

      yy_chk : constant array (0 .. 162) of Short :=
          (0,
        1,    1,    1,    1,    1,    1,    1,    1,    1,    1,
        1,    1,    1,    1,    1,    1,    1,    1,    1,    1,
        1,    1,    1,    1,    1,    1,    1,    1,    1,    1,
        1,    1,   10,   11,   11,   13,   13,   14,   14,   29,
       24,   13,   24,   30,   32,   34,   34,   35,   36,   40,
       55,   34,   35,   36,   37,   10,   37,   56,   13,  100,
       29,   29,   95,   94,   40,   91,   30,   32,   34,   35,
       36,   55,   55,   57,   90,   89,   88,   85,   57,   83,
       56,   81,   79,   78,   77,   75,   74,   73,   72,   71,
       70,   68,   67,   65,   64,   57,   99,   63,   99,   59,

       58,   54,   53,   52,   51,   49,   48,   47,   46,   44,
       43,   42,   41,   39,   33,   28,   27,   26,   25,   23,
       22,   21,   20,   19,   18,   17,   16,   12,    3,   98,
       98,   98,   98,   98,   98,   98,   98,   98,   98,   98,
       98,   98,   98,   98,   98,   98,   98,   98,   98,   98,
       98,   98,   98,   98,   98,   98,   98,   98,   98,   98,
       98,   98
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
               if yy_current_state >= 99 then
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
                  if yy_current_state >= 99 then
                     yy_c := yy_meta (yy_c);
                  end if;
               end loop;
               yy_current_state := yy_nxt (yy_base (yy_current_state) + yy_c);
            yy_cp := yy_cp + 1;
            if yy_current_state = 98 then
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
             yylval := Null_AST; return AND_TOKEN; 

         when 2 =>
--# line 14 "filter_lexer.l"
             yylval := Null_AST; return NOT_TOKEN; 

         when 3 =>
--# line 15 "filter_lexer.l"
             yylval := Null_AST; return OR_TOKEN; 

         when 4 =>
--# line 16 "filter_lexer.l"
             yylval := Null_AST; return IS_TOKEN; 

         when 5 =>
--# line 17 "filter_lexer.l"
             yylval := Null_AST; return KNOWN_TOKEN; 

         when 6 =>
--# line 18 "filter_lexer.l"
             yylval := Null_AST; return UNKNOWN_TOKEN; 

         when 7 =>
--# line 19 "filter_lexer.l"
             yylval := Null_AST; return CONTAINS_TOKEN; 

         when 8 =>
--# line 20 "filter_lexer.l"
             yylval := Null_AST; return STARTS_TOKEN; 

         when 9 =>
--# line 21 "filter_lexer.l"
             yylval := Null_AST; return ENDS_TOKEN; 

         when 10 =>
--# line 22 "filter_lexer.l"
             yylval := Null_AST; return WITH_TOKEN; 

         when 11 =>
--# line 23 "filter_lexer.l"
             yylval := Null_AST; return LENGTH_TOKEN; 

         when 12 =>
--# line 24 "filter_lexer.l"
             yylval := Null_AST; return HAS_TOKEN; 

         when 13 =>
--# line 25 "filter_lexer.l"
             yylval := Null_AST; return ALL_TOKEN; 

         when 14 =>
--# line 26 "filter_lexer.l"
             yylval := Null_AST; return ONLY_TOKEN; 

         when 15 =>
--# line 27 "filter_lexer.l"
             yylval := Null_AST; return ANY_TOKEN; 

         when 16 =>
--# line 29 "filter_lexer.l"
             yylval := Null_AST; return TRUE_TOKEN; 

         when 17 =>
--# line 30 "filter_lexer.l"
             yylval := Null_AST; return FALSE_TOKEN; 

         when 18 =>
--# line 32 "filter_lexer.l"
            
               yylval := New_AST (filter_lexer_dfa.yytext);
               return KEYWORD_TOKEN;
             

         when 19 =>
--# line 36 "filter_lexer.l"
            
               yylval := New_AST_Identifier (filter_lexer_dfa.yytext);
               return IDENTIFIER_TOKEN;
             

         when 20 =>
--# line 40 "filter_lexer.l"
            
               yylval := New_AST (Float'Value (filter_lexer_dfa.yytext));
               return NUMBER_TOKEN;
             

         when 21 =>
--# line 44 "filter_lexer.l"
            
               yylval := New_AST (yytext (yytext'First + 1 ..
                                          yytext'Last  - 1));
               return STRING_TOKEN;
             

         when 22 =>
--# line 50 "filter_lexer.l"
             yylval := Null_AST; return LF_TOKEN; 

         when 23 =>
--# line 51 "filter_lexer.l"
             yylval := Null_AST; return CR_TOKEN; 

         when 24 =>
--# line 52 "filter_lexer.l"
             yylval := Null_AST; return HT_TOKEN; 

         when 25 =>
--# line 53 "filter_lexer.l"
             yylval := Null_AST; return VT_TOKEN; 

         when 26 =>
--# line 54 "filter_lexer.l"
             yylval := Null_AST; return FF_TOKEN; 

-- The remaining single character tokens are processed in Ada so that
-- we get compiler error if some character is not covered:
         when 27 =>
--# line 59 "filter_lexer.l"
            
              declare
                  BS : constant Character := '\';
                  S  : String := filter_lexer_dfa.yytext(1 .. 1);
              begin
                 yylval := New_AST (S);
                 case S (1) is
                     when ' ' => return Token'(' ');
                     when '(' => return Token'('(');
                     when ')' => return Token'(')');
                     when '.' => return Token'('.');
                     when ',' => return Token'(',');
                     when ':' => return Token'(':');
                     when '=' => return Token'('=');
                     when '<' => return Token'('<');
                     when '>' => return Token'('>');
                     when '!' => return Token'('!');
             
                     -- We list all remaining characters explicitly
                     -- so that if a new token is introduced into the grammar,
                     -- or removed from it, we get an Ada compiler
                     -- error:
             
                     when ASCII.NUL .. ASCII.US |
                          '#' .. ''' |
                          '*' .. '+' |
                          '-'        |
                          '/'        |
                          ';'        |
                          '?' .. '@' |
                          '['        |
                          ']' .. '^' |
                          '`'        |
                          '{' .. '~' |
                          character'val(127) .. character'val(255) |
                          'A' .. 'Z' | 'a' .. 'z' | '0' .. '9' |
                          BS | '_' | '"'
                         => return ERROR;
                 end case;
              end;


         when 28 =>
--# line 101 "filter_lexer.l"
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

--# line 101 "filter_lexer.l"

end Filter_Lexer;

