with Text_IO, Filter_Lexer, YYErrors; use Text_IO, Filter_Lexer, YYErrors;

with Filter_Goto, Filter_Tokens, Filter_Shift_Reduce, Filter_AST;
with Ada.Strings.Unbounded;
with YYStype_Definition;

use Filter_Goto, Filter_Tokens, Filter_Shift_Reduce, Filter_AST;
use Ada.Strings.Unbounded;
use YYStype_Definition;

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

    Put_Line (Image (yy.value_stack (yy.tos)));

when 2 => -- #line 46

 YYVal := yy.value_stack (yy.tos);

when 3 => -- #line 50

 YYVal := yy.value_stack (yy.tos);

when 4 => -- #line 55

 YYVal := yy.value_stack (yy.tos);

when 5 => -- #line 60

 YYVal := yy.value_stack (yy.tos);

when 6 => -- #line 65

 YYVal := yy.value_stack (yy.tos);

when 7 => -- #line 70

 YYVal := yy.value_stack (yy.tos);

when 8 => -- #line 75

    if Is_Null (yy.value_stack (yy.tos)) then
        YYVal := yy.value_stack (yy.tos-1);
    else
        YYVal := New_AST (',', yy.value_stack (yy.tos-1), yy.value_stack (yy.tos));
    end if;

when 9 => -- #line 84

    if Is_Null (yy.value_stack (yy.tos)) then
        YYVal := New_AST (':', yy.value_stack (yy.tos-3), yy.value_stack (yy.tos-1));
    else
        YYVal := New_AST (':', yy.value_stack (yy.tos-3), New_AST (':', yy.value_stack (yy.tos-1), yy.value_stack (yy.tos)));
    end if;

when 10 => -- #line 93

    if Is_Null (yy.value_stack (yy.tos)) then
        YYVal := yy.value_stack (yy.tos-1);
    else
        YYVal := New_AST (',', yy.value_stack (yy.tos-1), yy.value_stack (yy.tos));
    end if;

when 11 => -- #line 102

 if Is_Null (yy.value_stack (yy.tos)) then
     YYVal := yy.value_stack (yy.tos-1);
 else
     YYVal := New_AST (OP_OR, yy.value_stack (yy.tos-1), Operand (yy.value_stack (yy.tos)));
 end if;

when 12 => -- #line 111

 if Is_Null (yy.value_stack (yy.tos)) then
    YYVal := yy.value_stack (yy.tos-1);
 else
    YYVal := New_AST (OP_AND, yy.value_stack (yy.tos-1), Operand (yy.value_stack (yy.tos)));
 end if;

when 13 => -- #line 120

 if Is_Null (yy.value_stack (yy.tos-1)) then
     YYVal := yy.value_stack (yy.tos);
 else
     YYVal := new_AST (Operator (yy.value_stack (yy.tos-1)), yy.value_stack (yy.tos));
 end if;

when 14 => -- #line 130

 YYVal := yy.value_stack (yy.tos);

when 15 => -- #line 134

 YYVal := yy.value_stack (yy.tos);

when 16 => -- #line 140

 YYVal := New_AST (Operator (yy.value_stack (yy.tos)), yy.value_stack (yy.tos-1), Operand (yy.value_stack (yy.tos)));

when 17 => -- #line 144

 YYVal := New_AST (Operator (yy.value_stack (yy.tos)), yy.value_stack (yy.tos-1), Operand (yy.value_stack (yy.tos)));

when 18 => -- #line 149

 -- Put ("1 >>> " & Image ($1)); Put_Line (" <<<< 1");
 -- Put ("2 >>> " & Image ($2)); Put_Line (" <<<< 2");

 if Is_Null (yy.value_stack (yy.tos)) then
     YYVal := yy.value_stack (yy.tos-1);
 else
     case Kind (yy.value_stack (yy.tos)) is
         when OPERATOR =>
             if Is_Null (Right (yy.value_stack (yy.tos))) then
                 YYVal := New_AST (Operator (yy.value_stack (yy.tos)), yy.value_stack (yy.tos-1), Left (yy.value_stack (yy.tos)));
             else
                 case Kind (Left (yy.value_stack (yy.tos))) is
                     when OPERATOR =>
                         if Operator (Left (yy.value_stack (yy.tos))) = ':' then
                             YYVal := New_AST (Operator (yy.value_stack (yy.tos)),
                                            New_AST (':', yy.value_stack (yy.tos-1), Left (yy.value_stack (yy.tos))),
                                            (if Kind (Right (yy.value_stack (yy.tos))) = UNARY_OPERATOR
                                                then Operand (Right (yy.value_stack (yy.tos)))
                                                else Right (yy.value_stack (yy.tos))
                                             )
                                            );
                         else
                             YYVal := New_AST (Operator (yy.value_stack (yy.tos)), yy.value_stack (yy.tos-1), yy.value_stack (yy.tos));
                         end if;
                     when others =>
                         YYVal := New_AST (Operator (yy.value_stack (yy.tos)), yy.value_stack (yy.tos-1), yy.value_stack (yy.tos));
                 end case;
             end if;
         when UNARY_OPERATOR =>
             YYVal := New_AST (Operator (yy.value_stack (yy.tos)), yy.value_stack (yy.tos-1), Operand (yy.value_stack (yy.tos)));
         when others =>
             YYVal := New_AST ('?', yy.value_stack (yy.tos-1), yy.value_stack (yy.tos));
     end case;
 end if;

when 19 => -- #line 187

 YYVal := yy.value_stack (yy.tos);

when 20 => -- #line 192

 YYVal := new_AST (Operator (yy.value_stack (yy.tos-1)), yy.value_stack (yy.tos));

when 21 => -- #line 197

 YYVal := new_AST (Operator (yy.value_stack (yy.tos-1)), yy.value_stack (yy.tos));

when 22 => -- #line 202

 YYVal := yy.value_stack (yy.tos);

when 26 => -- #line 210

    if Kind (yy.value_stack (yy.tos)) = UNARY_OPERATOR then
        YYVal := yy.value_stack (yy.tos);
    else
        YYVal := New_AST (OP_HAS_ALL, yy.value_stack (yy.tos));
    end if;

when 27 => -- #line 219

    if Operator (yy.value_stack (yy.tos)) = ':' then
        YYVal := New_AST (OP_HAS_ALL, yy.value_stack (yy.tos-2), yy.value_stack (yy.tos));
    else
        YYVal := New_AST (Operator (yy.value_stack (yy.tos)), yy.value_stack (yy.tos-2), yy.value_stack (yy.tos));
    end if;

when 28 => -- #line 228

    if Is_Null (yy.value_stack (yy.tos)) then
        YYVal := yy.value_stack (yy.tos-1);
    else
        YYVal := New_AST (':', yy.value_stack (yy.tos-1), yy.value_stack (yy.tos));
    end if;

when 29 => -- #line 237

 YYVal := New_AST (OP_LENGTH, yy.value_stack (yy.tos));

when 30 => -- #line 242

 YYVal := yy.value_stack (yy.tos);

when 31 => -- #line 246

 YYVal := new_AST ('.', yy.value_stack (yy.tos-2), yy.value_stack (yy.tos));

when 52 => -- #line 291

 YYVal := yy.value_stack (yy.tos);

when 53 => -- #line 296

    if Is_NULL (yy.value_stack (yy.tos-2)) then
        YYVal := New_Ast ('=', Null_AST);
    else
        YYVal := New_Ast (OP_NE, Null_AST);
    end if;

when 54 => -- #line 305

 if Is_NULL (yy.value_stack (yy.tos-1)) then
     YYVal := New_AST (Operator (yy.value_stack (yy.tos-2)), Null_AST);
 else
     if Operator (yy.value_stack (yy.tos-2)) = '<' then
         YYVal := New_AST (OP_LE, Null_AST);
     elsif Operator (yy.value_stack (yy.tos-2)) = '>' then
         YYVal := New_AST (OP_GE, Null_AST);
     else
         raise SYNTAX_ERROR with
             "operator """ &  Operator (yy.value_stack (yy.tos-2))'Image &
             """ is not recognised";
     end if;
 end if;

when 57 => -- #line 326

 YYVal := yy.value_stack (yy.tos-1);

when 58 => -- #line 331

 YYVal := yy.value_stack (yy.tos-1);

when 59 => -- #line 336

 YYVal := yy.value_stack (yy.tos-1);

when 74 => -- #line 360

 YYVal := New_AST (OP_OR, yy.value_stack (yy.tos));

when 75 => -- #line 364

 YYVal := Null_AST;

when 76 => -- #line 370

 YYVal := yy.value_stack (yy.tos);

when 77 => -- #line 374

 YYVal := New_AST (OP_HAS_ONLY, yy.value_stack (yy.tos));

when 78 => -- #line 378

 YYVal := New_AST (OP_HAS_ALL, yy.value_stack (yy.tos));

when 79 => -- #line 382

 YYVal := New_AST (OP_HAS_ANY, yy.value_stack (yy.tos));

when 80 => -- #line 388

 YYVal := New_AST ('<');

when 81 => -- #line 392

 YYVal := New_AST ('>');

when 82 => -- #line 398

 YYVal := yy.value_stack (yy.tos);

when 83 => -- #line 402

 YYVal := Null_AST;

when 84 => -- #line 407

 YYVal := New_AST ('!');

when 85 => -- #line 411

 YYVal := Null_AST;

when 86 => -- #line 417

 YYVal := yy.value_stack (yy.tos);

when 87 => -- #line 421

 YYVal := yy.value_stack (yy.tos);

when 88 => -- #line 425

 YYVal := yy.value_stack (yy.tos);

when 89 => -- #line 429

 YYVal := yy.value_stack (yy.tos);

when 90 => -- #line 434

 YYVal := yy.value_stack (yy.tos);

when 91 => -- #line 438

    if Is_Null (yy.value_stack (yy.tos-2)) then
        YYVal := yy.value_stack (yy.tos);
    else
        YYVal := New_AST (',', yy.value_stack (yy.tos-2), yy.value_stack (yy.tos));
    end if;

when 92 => -- #line 446

 YYVal := Null_AST;

when 93 => -- #line 452

 YYVal := yy.value_stack (yy.tos);

when 94 => -- #line 456

 YYVal := yy.value_stack (yy.tos);

when 95 => -- #line 460

 YYVal := yy.value_stack (yy.tos);

when 96 => -- #line 464

 YYVal := yy.value_stack (yy.tos);

when 97 => -- #line 468

 YYVal := yy.value_stack (yy.tos);

when 98 => -- #line 472

 YYVal := yy.value_stack (yy.tos);

when 99 => -- #line 476

 YYVal := Null_AST;

when 100 => -- #line 482

 YYVal := New_AST (True);

when 101 => -- #line 486

 YYVal := New_AST (False);

when 102 => -- #line 492

 YYVal := yy.value_stack (yy.tos);

when 103 => -- #line 496

 YYVal := New_AST (OP_HAS_ALL, yy.value_stack (yy.tos));

when 104 => -- #line 500

 YYVal := New_AST (OP_HAS_ANY, yy.value_stack (yy.tos));

when 105 => -- #line 504

 YYVal := New_AST (OP_HAS_ONLY, yy.value_stack (yy.tos));

when 106 => -- #line 510

 YYVal := yy.value_stack (yy.tos);

when 107 => -- #line 514

    if Is_Null (yy.value_stack (yy.tos-2)) then
        YYVal := yy.value_stack (yy.tos);
    else
        YYVal := New_AST (':', yy.value_stack (yy.tos-2), yy.value_stack (yy.tos));
    end if;

when 108 => -- #line 522

 YYVal := Null_AST;

when 109 => -- #line 528

 YYVal := yy.value_stack (yy.tos);

when 110 => -- #line 532

    if Is_Null (yy.value_stack (yy.tos-2)) then
        YYVal := yy.value_stack (yy.tos);
    else
        YYVal := New_AST (':', yy.value_stack (yy.tos-2), yy.value_stack (yy.tos));
    end if;

when 111 => -- #line 540

 YYVal := Null_AST;

when 112 => -- #line 546

 YYVal := New_AST (OP_AND, yy.value_stack (yy.tos));

when 113 => -- #line 550

 YYVal := Null_AST;

when 114 => -- #line 556

 YYVal := New_AST ('K', Null_AST);

when 115 => -- #line 560

 YYVal := New_Ast ('!', New_AST ('K', Null_AST));

when 116 => -- #line 566

 YYVal := yy.value_stack (yy.tos);

when 117 => -- #line 570

    if Is_Null (yy.value_stack (yy.tos-2)) then
        YYVal := yy.value_stack (yy.tos);
    else
        YYVal := New_AST (',', yy.value_stack (yy.tos-2), yy.value_stack (yy.tos));
    end if;

when 118 => -- #line 578

 YYVal := Null_AST;

when 119 => -- #line 584

 YYVal := yy.value_stack (yy.tos);

when 120 => -- #line 588

 YYVal := yy.value_stack (yy.tos);

when 121 => -- #line 594

 YYVal := Null_AST;

when 122 => -- #line 598

 YYVal := New_AST ('N', Null_AST);

when 123 => -- #line 604

 YYVal := yy.value_stack (yy.tos);

when 124 => -- #line 608

 YYVal := yy.value_stack (yy.tos);

when 125 => -- #line 614

 YYVal := yy.value_stack (yy.tos);

when 126 => -- #line 619

 YYVal := yy.value_stack (yy.tos-1);

when 127 => -- #line 625

 YYVal := yy.value_stack (yy.tos);

when 128 => -- #line 629

 YYVal := yy.value_stack (yy.tos);

when 129 => -- #line 635

 YYVal := yy.value_stack (yy.tos);

when 130 => -- #line 639

 YYVal := yy.value_stack (yy.tos);

when 131 => -- #line 645

 YYVal := New_AST ('=');

when 132 => -- #line 649

 YYVal := Null_AST;

when 133 => -- #line 655

 YYVal := Null_AST;

when 134 => -- #line 659

 YYVal := Null_AST;

when 135 => -- #line 665

 YYVal := Null_AST;

when 136 => -- #line 669

 YYVal := Null_AST;

when 137 => -- #line 677

 YYVal := yy.value_stack (yy.tos);

when 138 => -- #line 681

 YYVal := New_Ast (Operator (yy.value_stack (yy.tos-1)), yy.value_stack (yy.tos));

when 139 => -- #line 685

 YYVal := New_Ast (Operator (yy.value_stack (yy.tos-1)), yy.value_stack (yy.tos));

when 140 => -- #line 689

 YYVal := yy.value_stack (yy.tos);
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
