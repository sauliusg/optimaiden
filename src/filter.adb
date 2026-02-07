with Text_IO, Filter_Lexer, YYErrors; use Text_IO, Filter_Lexer, YYErrors;

with Filter_Goto, Filter_Tokens, Filter_Shift_Reduce;
with Ada.Strings.Unbounded;
with YYStype_Definition;
with YYInput_Definition;

use Filter_Goto, Filter_Tokens, Filter_Shift_Reduce;
use Ada.Strings.Unbounded;
use YYStype_Definition;
use YYInput_Definition;

package body Filter is

    Parsed_Expression : Filter_AST.AST_Type;

    function Parse (S : String) return Filter_AST.AST_Type is
    begin
        YYInput_Definition.Start_Parsing (S);
        YYParse;
        return Return_AST : AST_Type := Parsed_Expression do
            Parsed_Expression := Null_AST ;
        end return;
    end;

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

when 1 => -- #line 41

 Parsed_Expression := yy.value_stack (yy.tos);

when 2 => -- #line 48

 YYVal := yy.value_stack (yy.tos); -- Pass the received AST ($1) to the upper level

when 3 => -- #line 52

 YYVal := yy.value_stack (yy.tos);

when 4 => -- #line 59

 YYVal := New_AST (True);

when 5 => -- #line 63

 YYVal := New_AST (False);

when 6 => -- #line 70

 YYVal := yy.value_stack (yy.tos);

when 7 => -- #line 74

 YYVal := yy.value_stack (yy.tos);

when 8 => -- #line 81

 YYVal := yy.value_stack (yy.tos);

when 9 => -- #line 85

 YYVal := yy.value_stack (yy.tos);

when 10 => -- #line 92

 YYVal := yy.value_stack (yy.tos);

when 11 => -- #line 96

 YYVal := yy.value_stack (yy.tos);

when 12 => -- #line 100

 YYVal := yy.value_stack (yy.tos);

when 13 => -- #line 104

 YYVal := yy.value_stack (yy.tos);

when 14 => -- #line 111

    if Is_Null (yy.value_stack (yy.tos)) then
        YYVal := yy.value_stack (yy.tos-1);
    else
        YYVal := New_AST (',', yy.value_stack (yy.tos-1), yy.value_stack (yy.tos));
    end if;

when 15 => -- #line 122

    if Is_Null (yy.value_stack (yy.tos)) then
        YYVal := New_AST (':', yy.value_stack (yy.tos-3), yy.value_stack (yy.tos-1));
    else
        YYVal := New_AST (':', yy.value_stack (yy.tos-3), New_AST (':', yy.value_stack (yy.tos-1), yy.value_stack (yy.tos)));
    end if;

when 16 => -- #line 133

    if Is_Null (yy.value_stack (yy.tos)) then
        YYVal := yy.value_stack (yy.tos-1);
    else
        YYVal := New_AST (',', yy.value_stack (yy.tos-1), yy.value_stack (yy.tos));
    end if;

when 17 => -- #line 144

 if Is_Null (yy.value_stack (yy.tos)) then
     YYVal := yy.value_stack (yy.tos-1);
 else
     YYVal := New_AST (OP_OR, yy.value_stack (yy.tos-1), Operand (yy.value_stack (yy.tos)));
 end if;

when 18 => -- #line 155

 if Is_Null (yy.value_stack (yy.tos)) then
    YYVal := yy.value_stack (yy.tos-1);
 else
    YYVal := New_AST (OP_AND, yy.value_stack (yy.tos-1), Operand (yy.value_stack (yy.tos)));
 end if;

when 19 => -- #line 166

 if Is_Null (yy.value_stack (yy.tos-1)) then
     YYVal := yy.value_stack (yy.tos);
 else
     YYVal := new_AST (Operator (yy.value_stack (yy.tos-1)), yy.value_stack (yy.tos));
 end if;

when 20 => -- #line 177

 YYVal := yy.value_stack (yy.tos);

when 21 => -- #line 181

 YYVal := yy.value_stack (yy.tos);

when 22 => -- #line 188

 YYVal := New_AST (Operator (yy.value_stack (yy.tos)), yy.value_stack (yy.tos-1), Operand (yy.value_stack (yy.tos)));

when 23 => -- #line 192

 YYVal := New_AST (Operator (yy.value_stack (yy.tos)), yy.value_stack (yy.tos-1), Operand (yy.value_stack (yy.tos)));

when 24 => -- #line 206

 if Is_Null (yy.value_stack (yy.tos)) then
     YYVal := yy.value_stack (yy.tos-1);
 else
     case Kind (yy.value_stack (yy.tos)) is
         when OPERATOR =>
             if Is_Null (Right (yy.value_stack (yy.tos))) then
                 YYVal := New_AST (Operator (yy.value_stack (yy.tos)), yy.value_stack (yy.tos-1), Left (yy.value_stack (yy.tos)));
             else
                 declare
                     Right_Operand : constant AST_Type :=
                         (if Kind (Right (yy.value_stack (yy.tos))) = UNARY_OPERATOR
                             then Operand (Right (yy.value_stack (yy.tos)))
                             else Right (yy.value_stack (yy.tos))
                         );
                 begin
                     case Kind (Left (yy.value_stack (yy.tos))) is
                         when OPERATOR =>
                             if Operator (Left (yy.value_stack (yy.tos))) = ':' or else
                                Operator (Left (yy.value_stack (yy.tos))) = '.'  then
                                 YYVal := New_AST (Operator (yy.value_stack (yy.tos)),
                                                New_AST (':', yy.value_stack (yy.tos-1), Left (yy.value_stack (yy.tos))),
                                                Right_Operand
                                               );
                             else
                                 YYVal := New_AST (Operator (yy.value_stack (yy.tos)), yy.value_stack (yy.tos-1), yy.value_stack (yy.tos));
                             end if;
                         when VARIABLE =>
                             YYVal := New_AST (Operator (yy.value_stack (yy.tos)),
                                            New_AST (':', yy.value_stack (yy.tos-1), Left (yy.value_stack (yy.tos))),
                                            Right_Operand
                                           );
                         when others =>
                             YYVal := New_AST (Operator (yy.value_stack (yy.tos)), yy.value_stack (yy.tos-1), yy.value_stack (yy.tos));
                     end case;
                 end;
             end if;
         when UNARY_OPERATOR =>
             if Is_Null (Operand (yy.value_stack (yy.tos))) then
                 YYVal := New_AST (Operator (yy.value_stack (yy.tos)), yy.value_stack (yy.tos-1));
             else
                 YYVal := New_AST (Operator (yy.value_stack (yy.tos)), yy.value_stack (yy.tos-1), Operand (yy.value_stack (yy.tos)));
             end if;
         when others =>
             YYVal := New_AST ('?', yy.value_stack (yy.tos-1), yy.value_stack (yy.tos));
     end case;
 end if;

when 25 => -- #line 258

 YYVal := yy.value_stack (yy.tos);

when 26 => -- #line 262

 YYVal := yy.value_stack (yy.tos);

when 27 => -- #line 269

 YYVal := new_AST (Operator (yy.value_stack (yy.tos-1)), yy.value_stack (yy.tos));

when 28 => -- #line 276

 YYVal := new_AST (Operator (yy.value_stack (yy.tos-1)), yy.value_stack (yy.tos));

when 29 => -- #line 283

 YYVal := yy.value_stack (yy.tos);

when 30 => -- #line 290

 YYVal := New_AST (OP_CONTAINS, yy.value_stack (yy.tos));

when 31 => -- #line 294

 YYVal := New_AST (OP_STARTS_WITH, yy.value_stack (yy.tos));

when 32 => -- #line 298

 YYVal := New_AST (OP_ENDS_WITH, yy.value_stack (yy.tos));

when 33 => -- #line 305

    if Kind (yy.value_stack (yy.tos)) = UNARY_OPERATOR and then
       Operator (yy.value_stack (yy.tos)) in OP_HAS_ALL .. OP_HAS_ONLY
    then
        YYVal := yy.value_stack (yy.tos);
    else
        YYVal := New_AST (OP_HAS_ALL, yy.value_stack (yy.tos));
    end if;

when 34 => -- #line 318

    if Operator (yy.value_stack (yy.tos)) = ':' then
        YYVal := New_AST (OP_HAS_ALL, yy.value_stack (yy.tos-2), yy.value_stack (yy.tos));
    else
        YYVal := New_AST (Operator (yy.value_stack (yy.tos)), yy.value_stack (yy.tos-2), yy.value_stack (yy.tos));
    end if;

when 35 => -- #line 329

    if Is_Null (yy.value_stack (yy.tos)) then
        YYVal := yy.value_stack (yy.tos-1);
    else
        YYVal := New_AST (':', yy.value_stack (yy.tos-1), yy.value_stack (yy.tos));
    end if;

when 36 => -- #line 340

    if Is_Null (yy.value_stack (yy.tos-1)) then
        YYVal := New_AST (OP_LENGTH, New_AST ('=', yy.value_stack (yy.tos)));
    else
        YYVal := New_AST (OP_LENGTH, New_AST (Operator (yy.value_stack (yy.tos-1)), yy.value_stack (yy.tos)));
    end if;

when 37 => -- #line 351

 YYVal := yy.value_stack (yy.tos);

when 38 => -- #line 355

 YYVal := new_AST ('.', yy.value_stack (yy.tos-2), yy.value_stack (yy.tos));

when 59 => -- #line 402

 YYVal := yy.value_stack (yy.tos);

when 60 => -- #line 406

 YYVal := yy.value_stack (yy.tos);

when 61 => -- #line 413

    if Is_NULL (yy.value_stack (yy.tos-2)) then
        YYVal := New_Ast ('=', Null_AST);
    else
        YYVal := New_Ast (OP_NE, Null_AST);
    end if;

when 62 => -- #line 424

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

when 65 => -- #line 447

 YYVal := yy.value_stack (yy.tos-1);

when 66 => -- #line 454

 YYVal := yy.value_stack (yy.tos-1);

when 67 => -- #line 461

 YYVal := yy.value_stack (yy.tos-1);

when 82 => -- #line 484

 YYVal := New_AST (OP_OR, yy.value_stack (yy.tos));

when 83 => -- #line 488

 YYVal := Null_AST;

when 84 => -- #line 495

 YYVal := yy.value_stack (yy.tos);

when 85 => -- #line 499

 YYVal := New_AST (OP_HAS_ONLY, yy.value_stack (yy.tos));

when 86 => -- #line 503

 YYVal := New_AST (OP_HAS_ALL, yy.value_stack (yy.tos));

when 87 => -- #line 507

 YYVal := New_AST (OP_HAS_ANY, yy.value_stack (yy.tos));

when 88 => -- #line 514

 YYVal := New_AST ('<', Null_AST, Null_AST);

when 89 => -- #line 518

 YYVal := New_AST ('>', Null_AST, Null_AST);

when 90 => -- #line 525

 YYVal := yy.value_stack (yy.tos);

when 91 => -- #line 529

 YYVal := Null_AST;

when 92 => -- #line 536

 YYVal := New_AST ('!', Null_AST);

when 93 => -- #line 540

 YYVal := Null_AST;

when 94 => -- #line 547

 YYVal := yy.value_stack (yy.tos);

when 95 => -- #line 551

    if Is_Null (yy.value_stack (yy.tos-2)) then
        YYVal := yy.value_stack (yy.tos);
    else
        YYVal := New_AST (',', yy.value_stack (yy.tos-2), yy.value_stack (yy.tos));
    end if;

when 96 => -- #line 559

 YYVal := Null_AST;

when 97 => -- #line 566

 YYVal := yy.value_stack (yy.tos);

when 98 => -- #line 570

 YYVal := yy.value_stack (yy.tos);

when 99 => -- #line 574

 YYVal := yy.value_stack (yy.tos);

when 100 => -- #line 578

 YYVal := yy.value_stack (yy.tos);

when 101 => -- #line 582

 YYVal := yy.value_stack (yy.tos);

when 102 => -- #line 586

 YYVal := yy.value_stack (yy.tos);

when 103 => -- #line 590

 YYVal := Null_AST;

when 104 => -- #line 597

 YYVal := yy.value_stack (yy.tos);

when 105 => -- #line 601

 YYVal := New_Ast (Operator (yy.value_stack (yy.tos-1)), yy.value_stack (yy.tos));

when 106 => -- #line 605

 YYVal := New_Ast (Operator (yy.value_stack (yy.tos-1)), yy.value_stack (yy.tos));

when 107 => -- #line 609

 YYVal := yy.value_stack (yy.tos);

when 108 => -- #line 613

 YYVal := New_AST (OP_HAS_ALL, yy.value_stack (yy.tos));

when 109 => -- #line 617

 YYVal := New_AST (OP_HAS_ANY, yy.value_stack (yy.tos));

when 110 => -- #line 621

 YYVal := New_AST (OP_HAS_ONLY, yy.value_stack (yy.tos));

when 111 => -- #line 628

 YYVal := yy.value_stack (yy.tos);

when 112 => -- #line 632

    if Is_Null (yy.value_stack (yy.tos-2)) then
        YYVal := yy.value_stack (yy.tos);
    else
        YYVal := New_AST (':', yy.value_stack (yy.tos-2), yy.value_stack (yy.tos));
    end if;

when 113 => -- #line 640

 YYVal := Null_AST;

when 114 => -- #line 647

 YYVal := yy.value_stack (yy.tos);

when 115 => -- #line 651

    if Is_Null (yy.value_stack (yy.tos-2)) then
        YYVal := yy.value_stack (yy.tos);
    else
        YYVal := New_AST (':', yy.value_stack (yy.tos-2), yy.value_stack (yy.tos));
    end if;

when 116 => -- #line 659

 YYVal := Null_AST;

when 117 => -- #line 666

 YYVal := New_AST (OP_AND, yy.value_stack (yy.tos));

when 118 => -- #line 670

 YYVal := Null_AST;

when 119 => -- #line 677

 YYVal := New_AST (OP_IS_KNOWN, Null_AST);

when 120 => -- #line 681

 YYVal := New_Ast (OP_IS_UNKNOWN, Null_AST);

when 121 => -- #line 688

 YYVal := yy.value_stack (yy.tos);

when 122 => -- #line 692

    if Is_Null (yy.value_stack (yy.tos-2)) then
        YYVal := yy.value_stack (yy.tos);
    else
        YYVal := New_AST (',', yy.value_stack (yy.tos-2), yy.value_stack (yy.tos));
    end if;

when 123 => -- #line 700

 YYVal := Null_AST;

when 124 => -- #line 707

 YYVal := Null_AST;

when 125 => -- #line 711

 YYVal := New_AST (OP_NOT, Null_AST);

when 126 => -- #line 718

 YYVal := yy.value_stack (yy.tos);

when 127 => -- #line 722

 YYVal := yy.value_stack (yy.tos-1);

when 128 => -- #line 729

 YYVal := New_AST ('=', Null_AST, Null_AST);

when 129 => -- #line 733

 YYVal := Null_AST;

when 130 => -- #line 740

 YYVal := Null_AST;

when 131 => -- #line 744

 YYVal := Null_AST;

when 132 => -- #line 751

 YYVal := Null_AST;

when 133 => -- #line 755

 YYVal := Null_AST;
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
