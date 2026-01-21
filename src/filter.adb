with Text_IO, Filter_Lexer, YYErrors; use Text_IO, Filter_Lexer, YYErrors;

with Filter_Goto, Filter_Tokens, Filter_Shift_Reduce, Filter_AST;
use Filter_Goto, Filter_Tokens, Filter_Shift_Reduce, Filter_AST;
package body Filter is

    Parsed_Expression : Filter_AST.AST_Type;

   procedure YYParse is
      --  Rename User Defined Packages to Internal Names.
      package yy_goto_tables renames
         Filter_Goto;
      package yy_shift_reduce_tables renames
         Filter_Shift_Reduce;
      package yy_tokens renames
         Filter_Tokens;

      use yy_tokens, yy_goto_tables, yy_shift_reduce_tables;

      procedure yyerrok;
      procedure yyclearin;
      procedure handle_error;

      subtype goto_row is yy_goto_tables.Row;
      subtype reduce_row is yy_shift_reduce_tables.Row;

      package yy is

         --  the size of the value and state stacks
         --  Affects error 'Stack size exceeded on state_stack'
         stack_size : constant Natural :=  8192;

         --  subtype rule         is Natural;
         subtype parse_state is Natural;
         --  subtype nonterminal  is Integer;

         --  encryption constants
         default           : constant := -1;
         first_shift_entry : constant := 0;
         accept_code       : constant := -3001;
         error_code        : constant := -3000;

         --  stack data used by the parser
         tos                : Natural := 0;
         value_stack        : array (0 .. stack_size) of yy_tokens.YYSType;
         state_stack        : array (0 .. stack_size) of parse_state;

         --  current input symbol and action the parser is on
         action             : Integer;
         rule_id            : Rule;
         input_symbol       : yy_tokens.Token := ERROR;

         --  error recovery flag
         error_flag : Natural := 0;
         --  indicates  3 - (number of valid shifts after an error occurs)

         look_ahead : Boolean := True;
         index      : reduce_row;

         --  Is Debugging option on or off
         debug : constant Boolean := False;
      end yy;

      procedure shift_debug (state_id : yy.parse_state; lexeme : yy_tokens.Token);
      procedure reduce_debug (rule_id : Rule; state_id : yy.parse_state);

      function goto_state
         (state : yy.parse_state;
          sym   : Nonterminal) return yy.parse_state;

      function parse_action
         (state : yy.parse_state;
          t     : yy_tokens.Token) return Integer;

      pragma Inline (goto_state, parse_action);

      function goto_state (state : yy.parse_state;
                           sym   : Nonterminal) return yy.parse_state is
         index : goto_row;
      begin
         index := Goto_Offset (state);
         while Goto_Matrix (index).Nonterm /= sym loop
            index := index + 1;
         end loop;
         return Integer (Goto_Matrix (index).Newstate);
      end goto_state;

      function parse_action (state : yy.parse_state;
                             t     : yy_tokens.Token) return Integer is
         index   : reduce_row;
         tok_pos : Integer;
         default : constant Integer := -1;
      begin
         tok_pos := yy_tokens.Token'Pos (t);
         index   := Shift_Reduce_Offset (state);
         while Integer (Shift_Reduce_Matrix (index).T) /= tok_pos
           and then Integer (Shift_Reduce_Matrix (index).T) /= default
         loop
            index := index + 1;
         end loop;
         return Integer (Shift_Reduce_Matrix (index).Act);
      end parse_action;

      --  error recovery stuff

      procedure handle_error is
         temp_action : Integer;
      begin

         if yy.error_flag = 3 then --  no shift yet, clobber input.
            if yy.debug then
               Text_IO.Put_Line ("  -- Ayacc.YYParse: Error Recovery Clobbers "
                                 & yy_tokens.Token'Image (yy.input_symbol));
            end if;
            if yy.input_symbol = yy_tokens.END_OF_INPUT then  -- don't discard,
               if yy.debug then
                  Text_IO.Put_Line ("  -- Ayacc.YYParse: Can't discard END_OF_INPUT, quiting...");
               end if;
               raise yy_tokens.Syntax_Error;
            end if;

            yy.look_ahead := True;   --  get next token
            return;                  --  and try again...
         end if;

         if yy.error_flag = 0 then --  brand new error
            yyerror ("Syntax Error");
         end if;

         yy.error_flag := 3;

         --  find state on stack where error is a valid shift --

         if yy.debug then
            Text_IO.Put_Line ("  -- Ayacc.YYParse: Looking for state with error as valid shift");
         end if;

         loop
            if yy.debug then
               Text_IO.Put_Line ("  -- Ayacc.YYParse: Examining State "
                                 & yy.parse_state'Image (yy.state_stack (yy.tos)));
            end if;
            temp_action := parse_action (yy.state_stack (yy.tos), ERROR);

            if temp_action >= yy.first_shift_entry then
               if yy.tos = yy.stack_size then
                  Text_IO.Put_Line ("  -- Ayacc.YYParse: Stack size exceeded on state_stack");
                  raise yy_tokens.Syntax_Error;
               end if;
               yy.tos                  := yy.tos + 1;
               yy.state_stack (yy.tos) := temp_action;
               exit;
            end if;

            if yy.tos /= 0 then
               yy.tos := yy.tos - 1;
            end if;

            if yy.tos = 0 then
               if yy.debug then
                  Text_IO.Put_Line
                     ("  -- Ayacc.YYParse: Error recovery popped entire stack, aborting...");
               end if;
               raise yy_tokens.Syntax_Error;
            end if;
         end loop;

         if yy.debug then
            Text_IO.Put_Line ("  -- Ayacc.YYParse: Shifted error token in state "
                              & yy.parse_state'Image (yy.state_stack (yy.tos)));
         end if;

      end handle_error;

      --  print debugging information for a shift operation
      procedure shift_debug (state_id : yy.parse_state; lexeme : yy_tokens.Token) is
      begin
         Text_IO.Put_Line ("  -- Ayacc.YYParse: Shift "
                           & yy.parse_state'Image (state_id) & " on input symbol "
                           & yy_tokens.Token'Image (lexeme));
      end shift_debug;

      --  print debugging information for a reduce operation
      procedure reduce_debug (rule_id : Rule; state_id : yy.parse_state) is
      begin
         Text_IO.Put_Line ("  -- Ayacc.YYParse: Reduce by rule "
                           & Rule'Image (rule_id) & " goto state "
                           & yy.parse_state'Image (state_id));
      end reduce_debug;

      --  make the parser believe that 3 valid shifts have occured.
      --  used for error recovery.
      procedure yyerrok is
      begin
         yy.error_flag := 0;
      end yyerrok;

      --  called to clear input symbol that caused an error.
      procedure yyclearin is
      begin
         --  yy.input_symbol := YYLex;
         yy.look_ahead := True;
      end yyclearin;

   begin
      --  initialize by pushing state 0 and getting the first input symbol
      yy.state_stack (yy.tos) := 0;

      loop
         yy.index := Shift_Reduce_Offset (yy.state_stack (yy.tos));
         if Integer (Shift_Reduce_Matrix (yy.index).T) = yy.default then
            yy.action := Integer (Shift_Reduce_Matrix (yy.index).Act);
         else
            if yy.look_ahead then
               yy.look_ahead := False;
               yy.input_symbol := YYLex;
            end if;
            yy.action := parse_action (yy.state_stack (yy.tos), yy.input_symbol);
         end if;

         if yy.action >= yy.first_shift_entry then  --  SHIFT

            if yy.debug then
               shift_debug (yy.action, yy.input_symbol);
            end if;

            --  Enter new state
            if yy.tos = yy.stack_size then
               Text_IO.Put_Line (" Stack size exceeded on state_stack");
               raise yy_tokens.Syntax_Error;
            end if;
            yy.tos                  := yy.tos + 1;
            yy.state_stack (yy.tos) := yy.action;
            yy.value_stack (yy.tos) := YYLVal;

            if yy.error_flag > 0 then  --  indicate a valid shift
               yy.error_flag := yy.error_flag - 1;
            end if;

            --  Advance lookahead
            yy.look_ahead := True;

         elsif yy.action = yy.error_code then       -- ERROR
            handle_error;

         elsif yy.action = yy.accept_code then
            if yy.debug then
               Text_IO.Put_Line ("  --  Ayacc.YYParse: Accepting Grammar...");
            end if;
            exit;

         else --  Reduce Action

            --  Convert action into a rule
            yy.rule_id := Rule (-1 * yy.action);

            --  Execute User Action
            --  user_action(yy.rule_id);
            case yy.rule_id is
               pragma Style_Checks (Off);

when 1 => -- #line 40

    Put_Line (Image (yy.value_stack (yy.tos).AST));

when 2 => -- #line 46

 YYVal := yy.value_stack (yy.tos);

when 3 => -- #line 50

 YYVal := yy.value_stack (yy.tos);

when 4 => -- #line 55

 YYVal := yy.value_stack (yy.tos);

when 5 => -- #line 60

 YYVal := yy.value_stack (yy.tos);

when 8 => -- #line 69

 YYVal.AST := New_AST (',', yy.value_stack (yy.tos-1).AST, yy.value_stack (yy.tos).AST);

when 11 => -- #line 78

 if Is_Null (yy.value_stack (yy.tos).AST) then
     YYVal.AST := yy.value_stack (yy.tos-1).AST;
 else
     YYVal.AST := New_AST ('|', yy.value_stack (yy.tos-1).AST, Left (yy.value_stack (yy.tos).AST));
 end if;

when 12 => -- #line 87

 if Is_Null (yy.value_stack (yy.tos).AST) then
    YYVal.AST := yy.value_stack (yy.tos-1).AST;
 else
    YYVal.AST := New_AST ('&', yy.value_stack (yy.tos-1).AST, Left (yy.value_stack (yy.tos).AST));
 end if;

when 13 => -- #line 96

 if Is_Null (yy.value_stack (yy.tos-1).AST) then
     YYVal.AST := yy.value_stack (yy.tos).AST;
 else
     YYVal.AST := new_AST (Operator (yy.value_stack (yy.tos-1).AST), yy.value_stack (yy.tos).AST);
 end if;

when 14 => -- #line 106

 YYVal := yy.value_stack (yy.tos);

when 15 => -- #line 110

 YYVal := yy.value_stack (yy.tos);

when 16 => -- #line 115

 YYVal.AST := New_AST (Operator (yy.value_stack (yy.tos).AST), yy.value_stack (yy.tos-1).AST, Left (yy.value_stack (yy.tos).AST));

when 17 => -- #line 119

 YYVal.AST := New_AST (Operator (yy.value_stack (yy.tos).AST), yy.value_stack (yy.tos-1).AST, Left (yy.value_stack (yy.tos).AST));

when 18 => -- #line 124

 if Is_Null (yy.value_stack (yy.tos).AST) then
     YYVal.AST := yy.value_stack (yy.tos-1).AST;
 else
     YYVal.AST := New_AST (Operator (yy.value_stack (yy.tos).AST), yy.value_stack (yy.tos-1).AST, Left (yy.value_stack (yy.tos).AST));
 end if;

when 19 => -- #line 133

 YYVal := yy.value_stack (yy.tos);

when 20 => -- #line 138

 YYVal.AST := new_AST (Operator (yy.value_stack (yy.tos-1).AST), yy.value_stack (yy.tos).AST);

when 21 => -- #line 143

 YYVal.AST := new_AST (Operator (yy.value_stack (yy.tos-1).AST), yy.value_stack (yy.tos).AST);

when 22 => -- #line 148

 YYVal := yy.value_stack (yy.tos);

when 30 => -- #line 163

 YYVal := yy.value_stack (yy.tos);

when 31 => -- #line 167

 YYVal.AST := new_AST ('.', yy.value_stack (yy.tos-2).AST, yy.value_stack (yy.tos).AST);

when 53 => -- #line 214

    if yy.value_stack (yy.tos-2).C = ' ' then
        YYVal.AST := New_Ast ('=', Null_AST);
    else
        YYVal.AST := New_Ast ('!', Null_AST);
    end if;

when 54 => -- #line 223

 if yy.value_stack (yy.tos-1).C = ' ' then
     YYVal.AST := New_AST (Operator_Type (yy.value_stack (yy.tos-2).C), Null_AST);
 else
     if yy.value_stack (yy.tos-2).C = '<' then
         YYVal.AST := New_AST ('L', Null_AST);
     else
         YYVal.AST := New_AST ('G', Null_AST);
     end if;
 end if;

when 57 => -- #line 240

 YYVal.AST := New_AST_Identifier (yy.value_stack (yy.tos-1).S);

when 58 => -- #line 245

 YYVal.AST := New_AST (yy.value_stack (yy.tos-1).S);

when 59 => -- #line 250

 YYVal.AST := New_AST (yy.value_stack (yy.tos-1).N);

when 74 => -- #line 274

 YYVal.AST := New_AST ('|', yy.value_stack (yy.tos).AST);

when 75 => -- #line 278

 YYVal.AST := Null_AST;

when 80 => -- #line 285

 YYVal.C := '<';

when 81 => -- #line 289

 YYVal.C := '>';

when 84 => -- #line 296

 YYVal.C := '!';

when 85 => -- #line 300

 YYVal.C := ' ';

when 90 => -- #line 307

 YYVal := yy.value_stack (yy.tos);

when 91 => -- #line 311

 YYVal.AST := New_AST (',', yy.value_stack (yy.tos-2).AST, yy.value_stack (yy.tos).AST);

when 92 => -- #line 315

 YYVal.AST := Null_AST;

when 93 => -- #line 321

 YYVal := yy.value_stack (yy.tos);

when 94 => -- #line 325

 YYVal := yy.value_stack (yy.tos);

when 95 => -- #line 329

 YYVal := yy.value_stack (yy.tos);

when 96 => -- #line 333

 YYVal := yy.value_stack (yy.tos);

when 97 => -- #line 337

 YYVal := yy.value_stack (yy.tos);

when 98 => -- #line 341

 YYVal := yy.value_stack (yy.tos);

when 99 => -- #line 345

 YYVal := (AST => Null_AST, others => <>);

when 100 => -- #line 351

 YYVal.AST := New_AST (True);

when 101 => -- #line 355

 YYVal.AST := New_AST (False);

when 102 => -- #line 361

 YYVal := yy.value_stack (yy.tos);

when 103 => -- #line 365

 YYVal.AST := New_AST ('A', yy.value_stack (yy.tos).AST);

when 104 => -- #line 369

 YYVal.AST := New_AST ('Y', yy.value_stack (yy.tos).AST);

when 105 => -- #line 373

 YYVal.AST := New_AST ('O', yy.value_stack (yy.tos).AST);

when 112 => -- #line 383

 YYVal.AST := New_AST ('&', yy.value_stack (yy.tos).AST);

when 113 => -- #line 387

 YYVal.AST := Null_AST;

when 114 => -- #line 393

 YYVal.AST := New_AST ('K', Null_AST);

when 115 => -- #line 397

 YYVal.AST := New_Ast ('!', New_AST ('K', Null_AST));

when 119 => -- #line 405

 YYVal := yy.value_stack (yy.tos);

when 120 => -- #line 409

 YYVal := yy.value_stack (yy.tos);

when 121 => -- #line 414

 YYVal.AST := Null_AST;

when 122 => -- #line 418

 YYVal.AST := New_AST ('N', Null_AST);

when 123 => -- #line 424

 YYVal := yy.value_stack (yy.tos);

when 124 => -- #line 429

 YYVal := yy.value_stack (yy.tos);

when 125 => -- #line 435

 YYVal := yy.value_stack (yy.tos);

when 126 => -- #line 440

 YYVal := yy.value_stack (yy.tos-1);

when 127 => -- #line 446

 YYVal := yy.value_stack (yy.tos);

when 128 => -- #line 450

 YYVal := yy.value_stack (yy.tos);

when 129 => -- #line 456

 YYVal := yy.value_stack (yy.tos);

when 130 => -- #line 460

 YYVal := yy.value_stack (yy.tos);

when 131 => -- #line 465

 YYVal.C := '=';

when 132 => -- #line 469

 YYVal.C := ' ';

when 138 => -- #line 483

 YYVal.AST := New_Ast ('@', yy.value_stack (yy.tos).AST);

when 139 => -- #line 487

 YYVal.AST := New_Ast ('?', yy.value_stack (yy.tos).AST);
               pragma Style_Checks (On);

               when others => null;
            end case;

            --  Pop RHS states and goto next state
            yy.tos := yy.tos - Rule_Length (yy.rule_id) + 1;
            if yy.tos > yy.stack_size then
               Text_IO.Put_Line (" Stack size exceeded on state_stack");
               raise yy_tokens.Syntax_Error;
            end if;
            yy.state_stack (yy.tos) := goto_state (yy.state_stack (yy.tos - 1),
                                                   Get_LHS_Rule (yy.rule_id));

            yy.value_stack (yy.tos) := YYVal;
            if yy.debug then
               reduce_debug (yy.rule_id,
                  goto_state (yy.state_stack (yy.tos - 1),
                              Get_LHS_Rule (yy.rule_id)));
            end if;

         end if;
      end loop;

   end YYParse;
end Filter;
