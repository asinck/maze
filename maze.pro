%Adam Sinck

%This program will implement a quest. It will start the user at the beginning of
%a maze, and they will have to get to the end of the maze and open a gate with a
%key that they get from a minotaur. The picture I used was adapted from
%http://www.scnfamily.org/youth/maze/files/maze2_img.jpg
%The minotaur is in the dead end at the center of the maze. For the dead end
%counter, this state is not counted unless the minotaur is dead and you have the
%key.

%I wrote this program for my CSC 240 class. The goal was to create a
%choose-your-own-adventure program, with both good and bad outcome(s). I
%generated most of the code with a secondary python program, because it would
%have taken forever to type it all, and would be error prone. The code after
%the comment that says, "basic finite state machine engine" was given to the
%class by the professor so that we could focus on the states of the adventure,
%instead of getting the program to run. Each student was to customize the engine
%to work for their code. This code works under Ubuntu 14.10, running SWI-Prolog
%in the command line. This is the original code that I submitted.

%The optimal sequence is:
% state - option
% 1 - right
% 3 - right
% 6 - forward
% 10 - left
% 7 - left
% fight the minotaur
% face the minotaur with your skill against his
% search for useful items
% take the key and leave
% 7 - right
% 10 - right
% 6 - right
% 2 - right
% 5 - right
% 8 - left
% 11 - right
% 14 - right
% 13 - right
% 9 - forward
% 12 - left
% exit - try the gate
% gate - exit

%If you lose your place, you either look at the code and figure out what section
%of tunnel you just walked through, start over, or hope for really good luck.

%the user will begin at state one, facing forward
start_state(state_1_forward).

display_intro :-
    write('You have been given a mission. You do not'), nl,
    write('know who gave you the mission, or why you'), nl,
    write('need to complete the mission, but you know'), nl,
    write('that it must be completed. You have been '), nl,
    write('placed at the beginning of a set of tunnels,'), nl,
    write('and you must navigate your way to the end.'), nl, nl,
    write('As soon as you entered the tunnels, the gate'), nl,
    write('closed behind you. You cannot go back now.'), nl,
    write('The only thing that you have is your torch.'), nl.
    
%set up the initial values
initialize :-
    asserta(stored_answer(gate_locked, yes)),
    asserta(stored_answer(minotaur_alive, yes)),
    asserta(stored_answer(minotaur_has_key, yes)),
    asserta(stored_answer(has_key, no)),
    asserta(stored_answer(dead_ends_reached, 0)),
    asserta(stored_answer(moves, 0)).


%these are the state directions. They are in the form
%next_state(current_state, option, next_state)

next_state(state_1_forward, a, dead_end_3).
next_state(state_1_forward, b, state_3_forward).
next_state(state_1_forward, c, state_1_forward).
next_state(state_2_forward, a, dead_end_1).
next_state(state_2_forward, b, state_5_forward).
next_state(state_2_forward, c, state_6_retracing_from_2).
next_state(state_3_forward, a, dead_end_2).
next_state(state_3_forward, b, state_6_forward).
next_state(state_3_forward, c, state_1_retracing).
next_state(state_4_forward, a, dead_end_4).
next_state(state_4_forward, b, dead_end_8).
next_state(state_4_forward, c, state_7_retracing).
next_state(state_5_forward, a, dead_end_5).
next_state(state_5_forward, b, state_8_forward).
next_state(state_5_forward, c, state_2_retracing).
next_state(state_6_forward, a, state_10_forward).
next_state(state_6_forward, b, state_2_forward).
next_state(state_6_forward, c, state_3_retracing).
next_state(state_7_forward, a, minotaur) :-
    stored_answer(minotaur_alive, yes).
next_state(state_7_forward, a, dead_end_7_with_key) :-
    stored_answer(minotaur_alive, no),
    stored_answer(has_key, yes).
next_state(state_7_forward, a, dead_end_7_without_key) :-
    stored_answer(minotaur_alive, no),
    stored_answer(has_key, no).
next_state(state_7_forward, b, state_4_forward).
next_state(state_7_forward, c, state_10_retracing).
next_state(state_8_forward, a, dead_end_12).
next_state(state_8_forward, b, state_11_forward).
next_state(state_8_forward, c, state_5_retracing).
next_state(state_9_forward, a, state_12_forward).
next_state(state_9_forward, b, dead_end_6).
next_state(state_9_forward, c, state_13_retracing).
next_state(state_10_forward, a, dead_end_10).
next_state(state_10_forward, b, state_7_forward).
next_state(state_10_forward, c, state_6_retracing_from_10).
next_state(state_11_forward, a, dead_end_9).
next_state(state_11_forward, b, state_14_forward).
next_state(state_11_forward, c, state_8_retracing).
next_state(state_12_forward, a, dead_end_13).
next_state(state_12_forward, b, exit) :-
    stored_answer(gate_locked, yes).
next_state(state_12_forward, b, gate_open) :-
    stored_answer(gate_locked, no).
next_state(state_12_forward, c, state_9_retracing).
next_state(state_13_forward, a, dead_end_11).
next_state(state_13_forward, b, state_9_forward).
next_state(state_13_forward, c, state_14_retracing).
next_state(state_14_forward, a, dead_end_14).
next_state(state_14_forward, b, state_13_forward).
next_state(state_14_forward, c, state_11_retracing).

next_state(state_1_retracing, a, state_1_forward).
next_state(state_1_retracing, b, dead_end_3).
next_state(state_1_retracing, c, state_3_forward).
next_state(state_2_retracing, a, state_6_retracing_from_2).
next_state(state_2_retracing, b, dead_end_1).
next_state(state_2_retracing, c, state_5_forward).
next_state(state_3_retracing, a, state_1_retracing).
next_state(state_3_retracing, b, dead_end_2).
next_state(state_3_retracing, c, state_6_forward).

%there is no state four retracing, because state four only leads to
%dead ends and they take care of their own transitions/options

next_state(state_5_retracing, a, state_2_retracing).
next_state(state_5_retracing, b, dead_end_5).
next_state(state_5_retracing, c, state_8_forward).
%state six has two directions it can retrace from
next_state(state_6_retracing_from_2, a, state_10_forward).
next_state(state_6_retracing_from_2, b, state_3_retracing).
next_state(state_6_retracing_from_2, c, state_2_forward).
next_state(state_6_retracing_from_10, a, state_3_retracing).
next_state(state_6_retracing_from_10, b, state_2_forward).
next_state(state_6_retracing_from_10, c, state_10_forward).
next_state(state_7_retracing, a, minotaur) :-
    stored_answer(minotaur_alive, yes).
next_state(state_7_retracing, a, dead_end_7_without_key) :-
    stored_answer(minotaur_alive, no),
    stored_answer(has_key, no).
next_state(state_7_retracing, a, dead_end_7_with_key) :-
    stored_answer(minotaur_alive, no),
    stored_answer(has_key, yes).
next_state(state_7_retracing, b, state_10_retracing).
next_state(state_7_retracing, c, state_4_forward).
next_state(state_8_retracing, a, dead_end_12).
next_state(state_8_retracing, b, state_5_retracing).
next_state(state_8_retracing, c, state_11_forward).
next_state(state_9_retracing, a, state_13_retracing).
next_state(state_9_retracing, b, dead_end_6).
next_state(state_9_retracing, c, state_12_forward).
next_state(state_10_retracing, a, dead_end_10).
next_state(state_10_retracing, b, state_6_retracing_from_10).
next_state(state_10_retracing, c, state_7_forward).
next_state(state_11_retracing, a, state_8_retracing).
next_state(state_11_retracing, b, dead_end_9).
next_state(state_11_retracing, c, state_14_forward).
next_state(state_12_retracing, a, dead_end_13).
next_state(state_12_retracing, b, state_9_retracing).
next_state(state_12_retracing, c, exit) :-
    stored_answer(gate_locked, yes).
next_state(state_12_retracing, c, gate_open) :-
    stored_answer(gate_locked, no).
next_state(state_13_retracing, a, state_14_retracing).
next_state(state_13_retracing, b, dead_end_11).
next_state(state_13_retracing, c, state_9_forward).
next_state(state_14_retracing, a, state_11_retracing).
next_state(state_14_retracing, b, dead_end_14).
next_state(state_14_retracing, c, state_13_forward).

next_state(dead_end_1, a, state_6_retracing_from_2).
next_state(dead_end_1, b, state_5_forward).
next_state(dead_end_1, c, dead_end_1).
next_state(dead_end_2, a, state_1_retracing).
next_state(dead_end_2, b, state_6_forward).
next_state(dead_end_2, c, dead_end_2).
next_state(dead_end_3, a, state_1_forward).
next_state(dead_end_3, b, state_3_forward).
next_state(dead_end_3, c, dead_end_3).
next_state(dead_end_4, a, dead_end_8).
next_state(dead_end_4, b, state_7_retracing).
next_state(dead_end_4, c, dead_end_4).
next_state(dead_end_5, a, state_2_retracing).
next_state(dead_end_5, b, state_8_forward).
next_state(dead_end_5, c, dead_end_5).
next_state(dead_end_6, a, state_12_forward).
next_state(dead_end_6, b, state_13_retracing).
next_state(dead_end_6, c, dead_end_6).
next_state(dead_end_7_with_key, a, state_4_forward).
next_state(dead_end_7_with_key, b, state_10_retracing).
next_state(dead_end_7_with_key, c, dead_end_7_with_key).
next_state(dead_end_7_without_key, a, searching).
next_state(dead_end_7_without_key, b, leave_minotaur).
next_state(dead_end_8, a, dead_end_4).
next_state(dead_end_8, b, state_7_retracing).
next_state(dead_end_8, c, dead_end_8).
next_state(dead_end_9, a, state_8_retracing).
next_state(dead_end_9, b, state_14_forward).
next_state(dead_end_9, c, dead_end_9).
next_state(dead_end_10, a, state_6_retracing_from_10).
next_state(dead_end_10, b, state_7_forward).
next_state(dead_end_10, c, dead_end_10).
next_state(dead_end_11, a, state_14_retracing).
next_state(dead_end_11, b, state_9_forward).
next_state(dead_end_11, c, dead_end_11).
next_state(dead_end_12, a, state_5_retracing).
next_state(dead_end_12, b, state_11_forward).
next_state(dead_end_12, c, dead_end_12).
next_state(dead_end_13, a, state_9_retracing).
next_state(dead_end_13, b, exit) :-
    stored_answer(gate_locked, yes).
next_state(dead_end_13, b, gate_open) :-
    stored_answer(gate_locked, no).
next_state(dead_end_13, c, dead_end_13).
next_state(dead_end_14, a, state_11_retracing).
next_state(dead_end_14, b, state_13_forward).
next_state(dead_end_14, c, dead_end_14).

next_state(minotaur, a, fighting).
next_state(minotaur, b, running).
next_state(fighting, a, win).
next_state(fighting, b, lost).
next_state(win, a, searching).
next_state(win, b, leave_minotaur).
next_state(running, a, state_4_forward).
next_state(running, b, state_10_retracing).
next_state(running, c, minotaur).
next_state(searching, a, leave_minotaur).
next_state(searching, b, leave_minotaur).
next_state(leave_minotaur, a, state_4_forward).
next_state(leave_minotaur, b, state_10_retracing).
next_state(leave_minotaur, c, dead_end_7_without_key) :-
    stored_answer(has_key, no).
next_state(leave_minotaur, c, dead_end_7_with_key) :-
    stored_answer(has_key, yes).

next_state(exit, a, gate_without_key) :-
    stored_answer(gate_locked, yes),
    stored_answer(has_key, no).
next_state(exit, a, gate_with_key) :-
    stored_answer(gate_locked, yes),
    stored_answer(has_key, yes).
next_state(exit, a, gate_open) :-
    stored_answer(gate_locked, no).
next_state(exit, b, state_12_retracing).
next_state(gate_without_key, a, state_12_retracing).
next_state(gate_without_key, b, gate_without_key).
next_state(gate_with_key, a, done).
next_state(gate_with_key, b, state_12_retracing).
next_state(gate_open, a, done).
next_state(gate_open, b, state_12_retracing).


%these are the output messages. They tell the user when
%they come to a branch in the tunnels, and display a set
%of options. They are (usually) in the form
%show_state(current_state) :-
%    <output of some sort>
%    show_turn(possible_turn_set).

show_state(state_1_forward) :-
    write('You come to a branch in the tunnel.'), nl,
    show_turn(forward_and_right).

show_state(state_2_forward) :-
    write('You come to a branch in the tunnel.'), nl,
    show_turn(forward_and_right).

show_state(state_3_forward) :-
    write('You come to a branch in the tunnel.'), nl,
    show_turn(forward_and_right).

show_state(state_4_forward) :-
    write('You come to a branch in the tunnel.'), nl,
    show_turn(left_and_right).

show_state(state_5_forward) :-
    write('You come to a branch in the tunnel.'), nl,
    show_turn(forward_and_right).

show_state(state_6_forward) :-
    write('You come to a branch in the tunnel.'), nl,
    show_turn(forward_and_left).

show_state(state_7_forward) :-
    write('You come to a branch in the tunnel.'), nl,
    show_turn(left_and_right).

show_state(state_8_forward) :-
    write('You come to a branch in the tunnel.'), nl,
    show_turn(forward_and_left).

show_state(state_9_forward) :-
    write('You come to a branch in the tunnel.'), nl,
    show_turn(forward_and_left).

show_state(state_10_forward) :-
    write('You come to a branch in the tunnel.'), nl,
    show_turn(forward_and_left).

show_state(state_11_forward) :-
    write('You come to a branch in the tunnel.'), nl,
    show_turn(forward_and_right).

show_state(state_12_forward) :-
    write('You come to a branch in the tunnel.'), nl,
    show_turn(forward_and_left).

show_state(state_13_forward) :-
    write('You come to a branch in the tunnel.'), nl,
    show_turn(forward_and_right).

show_state(state_14_forward) :-
    write('You come to a branch in the tunnel.'), nl,
    show_turn(forward_and_right).

show_state(state_1_retracing) :-
    write('You come to a branch in the tunnel.'), nl,
    show_turn(left_and_right).

show_state(state_2_retracing) :-
    write('You come to a branch in the tunnel.'), nl,
    show_turn(left_and_right).

show_state(state_3_retracing) :-
    write('You come to a branch in the tunnel.'), nl,
    show_turn(left_and_right).

%state four cannot retrace

show_state(state_5_retracing) :-
    write('You come to a branch in the tunnel.'), nl,
    show_turn(left_and_right).

show_state(state_6_retracing_from_2) :-
    write('You come to a branch in the tunnel.'), nl,
    show_turn(left_and_right).

show_state(state_6_retracing_from_10) :-
    write('You come to a branch in the tunnel.'), nl,
    show_turn(forward_and_right).

show_state(state_7_retracing) :-
    write('You come to a branch in the tunnel.'), nl,
    show_turn(forward_and_left).

show_state(state_8_retracing) :-
    write('You come to a branch in the tunnel.'), nl,
    show_turn(left_and_right).

show_state(state_9_retracing) :-
    write('You come to a branch in the tunnel.'), nl,
    show_turn(forward_and_right).

show_state(state_10_retracing) :-
    write('You come to a branch in the tunnel.'), nl,
    show_turn(left_and_right).

show_state(state_11_retracing) :-
    write('You come to a branch in the tunnel.'), nl,
    show_turn(left_and_right).

show_state(state_12_retracing) :-
    write('You come to a branch in the tunnel.'), nl,
    show_turn(left_and_right).

show_state(state_13_retracing) :-
    write('You come to a branch in the tunnel.'), nl,
    show_turn(left_and_right).

show_state(state_14_retracing) :-
    write('You come to a branch in the tunnel.'), nl,
    show_turn(left_and_right).

show_state(dead_end) :-
    stored_answer(dead_ends_reached, Number),
    retract(stored_answer(dead_ends_reached,_)),
    NewNumber is Number + 1,
    asserta(stored_answer(dead_ends_reached,NewNumber)),
    write('You come to dead end. You turn'), nl,
    write('around and get back to the branch'), nl,
    write('in the tunnel.'), nl.

show_state(dead_end_1) :-
    show_state(dead_end),
    show_turn(forward_and_left).

show_state(dead_end_2) :-
    show_state(dead_end),
    show_turn(forward_and_left).

show_state(dead_end_3) :-
    show_state(dead_end),
    show_turn(forward_and_left).

show_state(dead_end_4) :-
    show_state(dead_end),
    show_turn(forward_and_right).

show_state(dead_end_5) :-
    show_state(dead_end),
    show_turn(forward_and_left).

show_state(dead_end_6) :-
    show_state(dead_end),
    show_turn(left_and_right).

show_state(dead_end_7_with_key) :-
    write('You have reached the dead end that contained'), nl,
    write('the minotaur. There is nothing else that can'), nl,
    write('be done here, so you decide to go back to the'), nl,
    write('intersection.'), nl,
    stored_answer(dead_ends_reached, Number),
    retract(stored_answer(dead_ends_reached,_)),
    NewNumber is Number + 1,
    asserta(stored_answer(dead_ends_reached,NewNumber)),
    show_turn(forward_and_right).

%I'm not counting this dead end in the total because the user can
%benefit from being here.
show_state(dead_end_7_without_key) :-
    write('You have reached the dead end that contained'), nl,
    write('the minotaur. '), nl,
    write('    a - see if the minotaur has anything useful'), nl,
    write('	   and risk having more danger come'), nl,
    write('    b - go back to trying to find your way'), nl,
    write('        out of the maze'), nl,
    write('    q - quit'), nl.

show_state(dead_end_8) :-
    show_state(dead_end),
    show_turn(forward_and_left).

show_state(dead_end_9) :-
    show_state(dead_end),
    show_turn(forward_and_left).

show_state(dead_end_10) :-
    show_state(dead_end),
    show_turn(forward_and_right).

show_state(dead_end_11) :-
    show_state(dead_end),
    show_turn(forward_and_left).

show_state(dead_end_12) :-
    show_state(dead_end),
    show_turn(forward_and_right).

show_state(dead_end_13) :-
    show_state(dead_end),
    show_turn(forward_and_right).

show_state(dead_end_14) :-
    show_state(dead_end),
    show_turn(forward_and_left).


show_state(minotaur) :-
    write('You have reached a minotaur, armed with a sword.'), nl,
    write('Do you want to fight it or run?'), nl,
    write('   a - fight it'), nl,
    write('   b - run'), nl,
    write('   q - quit'), nl.

show_state(fighting) :-
    write('How do you want to fight against the minotaur?'), nl,
    write('    a - Face it as God intended. Sportsmanlike.'), nl,
    write('        No, tricks, no weapons, skill against'), nl,
    write('        skill alone.'), nl,
    write('    b - Throw large rocks at it'), nl,
    write('    q - quit'), nl.

show_state(win) :-
    retract(stored_answer(minotaur_alive, yes)),
    asserta(stored_answer(minotaur_alive, no)),
    write('You fight it, skill against skill alone. You'), nl,
    write('charge, towards the minotaur, and slay him. '), nl,
    write('If you escape the maze, the battle will go down'), nl,
    write('in history, and become legend. But now, you must'), nl,
    write('decide what you will do.'), nl,
    write('    a - see if the minotaur has anything useful'), nl,
    write('	   and risk having more danger come'), nl,
    write('    b - continue trying to find your way'), nl,
    write('        out of the maze'), nl,
    write('    q - quit'), nl.

show_state(searching) :-
    write('You search for anything useful that the'), nl,
    write('minotaur had. You find nothing but a sword'), nl,
    write('(that you can''t lift), and a key.'), nl,
    write('    a - take the key and leave the area'), nl,
    write('    b - leave the key and go back to trying'), nl,
    write('	   to find the exit'), nl,
    write('    q - quit'), nl.
    
show_state(running) :-
    write('You run, but the minotaur doesn''t chase you. '), nl,
    write('He knows that you will face him eventually, and'), nl,
    write('he will be ready then.'), nl,
    write('You come to an intersection. What direction would'), nl,
    write('you like to go? '), nl,
    show_turn(forward_and_right).
    
show_state(leave_minotaur) :-
    write('You leave the area, and come to a branch in the '), nl,
    write('tunnel. What direction would you like to go? '), nl,
    show_turn(forward_and_right).

show_state(lost) :-
    write('You throw rocks at the minotaur, but he deflects'), nl,
    write('them easily. He charges torwards you, and the'), nl,
    write('battle is over quickly. He is victorious; your'), nl,
    write('mission is over. '), nl.

show_state(exit) :-
    write('You reach the exit, but it is blocked by a gate.'), nl,
    write('Do you want to try the gate?'), nl,
    write('    a - try the gate'), nl,
    write('    b - go back the way you came'), nl,
    write('    q - quit'), nl.

show_state(gate_without_key) :-
    write('You try the gate, but it is locked. You must find'), nl,
    write('the key to exit.'), nl,
    write('    a - turn around and try to find a key in the maze'),
    nl,
    write('    b - try the gate again'), nl,
    write('    q - quit'), nl.

show_state(gate_with_key) :-
    retract(stored_answer(gate_locked, yes)),
    asserta(stored_answer(gate_locked, no)),
    write('You try the gate, but it is locked. However,'), nl,
    write('you have the key to the gate. You use the key,'), nl,
    write('and it opens the gate.'), nl,
    write('    a - exit'), nl,
    write('    b - go explore the maze some more'), nl,
    write('    q - quit'), nl.

show_state(gate_open) :-
    write('You get back to the exiting gate.'), nl,
    write('    a - exit'), nl,
    write('    b - go explore the maze some more'), nl,
    write('    q - quit'), nl.

show_state(done) :-
    write('You have completed your mission.'), nl.


%these are the transition messages. They output a set
%of steps to indicate to the user how far they are
%traveling from one state to the next. They are in
%the form
%show_transition(current_state) :-
%    <tell them what direction they decided on>
%    <list the steps>

show_transition(state_1_forward, a) :-
    write('You decide to go forward.'), nl,
    write('You walk forward.'), nl,
    write('You walk forward.'), nl.

show_transition(state_1_forward, b) :-
    write('You turn left.'), nl,
    write('You walk forward.'), nl,
    write('You turn left.'), nl,
    write('You turn right.'), nl,
    write('You turn right.'), nl,
    write('You turn left.'), nl,
    write('You turn left.'), nl,
    write('You turn right.'), nl.

show_transition(state_1_forward, c) :-
    write('You turn around.'), nl,
    write('You get back to the gate that'), nl,
    write('you started at, but it''s locked.'), nl,
    write('You turn around, and go back to the'), nl,
    write('intersection.'), nl.

show_transition(state_2_forward, a) :-
    write('You decide to go forward.'), nl,
    write('You walk forward.'), nl,
    write('You walk forward.'), nl,
    write('You walk forward.'), nl,
    write('You walk forward.'), nl,
    write('You walk forward.'), nl,
    write('You walk forward.'), nl.

show_transition(state_2_forward, b) :-
    write('You turn right.'), nl,
    write('You walk forward.'), nl,
    write('You turn left.'), nl,
    write('You walk forward.'), nl,
    write('You walk forward.'), nl,
    write('You walk forward.'), nl,
    write('You walk forward.'), nl,
    write('You walk forward.'), nl,
    write('You turn right.'), nl.

show_transition(state_2_forward, c) :-
    write('You turn around.'), nl,
    write('You walk forward.'), nl,
    write('You turn left.'), nl,
    write('You walk forward.'), nl,
    write('You turn left.'), nl,
    write('You turn right.'), nl,
    write('You turn right.'), nl,
    write('You walk forward.'), nl,
    write('You walk forward.'), nl.

show_transition(state_3_forward, a) :-
    write('You decide to go forward.'), nl,
    write('You walk forward.'), nl.

show_transition(state_3_forward, b) :-
    write('You turn right.'), nl,
    write('You walk forward.'), nl,
    write('You turn left.'), nl,
    write('You walk forward.'), nl,
    write('You turn left.'), nl,
    write('You walk forward.'), nl,
    write('You turn left.'), nl,
    write('You walk forward.'), nl,
    write('You walk forward.'), nl,
    write('You walk forward.'), nl,
    write('You walk forward.'), nl,
    write('You turn right.'), nl.

show_transition(state_3_forward, c) :-
    write('You turn around.'), nl,
    write('You walk forward.'), nl,
    write('You turn left.'), nl,
    write('You turn right.'), nl,
    write('You turn right.'), nl,
    write('You turn left.'), nl,
    write('You turn left.'), nl,
    write('You turn right.'), nl.

show_transition(state_4_forward, a) :-
    write('You turn left.'), nl,
    write('You walk forward.'), nl.

show_transition(state_4_forward, b) :-
    write('You turn right.'), nl,
    write('You walk forward.'), nl,
    write('You turn right.'), nl,
    write('You walk forward.'), nl,
    write('You turn right.'), nl.

show_transition(state_4_forward, c) :-
    write('You turn around.'), nl,
    write('You walk forward.'), nl,
    write('You turn right.'), nl,
    write('You turn left.'), nl,
    write('You turn right.'), nl,
    write('You walk forward.'), nl.

show_transition(state_5_forward, a) :-
    write('You decide to go forward.'), nl,
    write('You walk forward.'), nl,
    write('You turn right.'), nl.

show_transition(state_5_forward, b) :-
    write('You turn right.'), nl,
    write('You walk forward.'), nl,
    write('You walk forward.'), nl,
    write('You turn left.'), nl,
    write('You walk forward.'), nl.

show_transition(state_5_forward, c) :-
    write('You turn around.'), nl,
    write('You walk forward.'), nl,
    write('You turn left.'), nl,
    write('You walk forward.'), nl,
    write('You walk forward.'), nl,
    write('You walk forward.'), nl,
    write('You walk forward.'), nl,
    write('You walk forward.'), nl,
    write('You turn right.'), nl.

show_transition(state_6_forward, a) :-
    write('You decide to go forward.'), nl,
    write('You walk forward.'), nl,
    write('You walk forward.'), nl.

show_transition(state_6_forward, b) :-
    write('You turn left.'), nl,
    write('You walk forward.'), nl,
    write('You walk forward.'), nl,
    write('You walk forward.'), nl,
    write('You turn left.'), nl,
    write('You turn left.'), nl,
    write('You turn right.'), nl,
    write('You walk forward.'), nl,
    write('You turn right.'), nl.

show_transition(state_6_forward, c) :-
    write('You turn around.'), nl,
    write('You walk forward.'), nl,
    write('You turn left.'), nl,
    write('You walk forward.'), nl,
    write('You walk forward.'), nl,
    write('You walk forward.'), nl,
    write('You walk forward.'), nl,
    write('You turn right.'), nl,
    write('You walk forward.'), nl,
    write('You turn right.'), nl,
    write('You walk forward.'), nl,
    write('You turn right.'), nl.

show_transition(state_7_forward, a) :-
    write('You turn left.'), nl,
    write('You walk forward.'), nl.

show_transition(state_7_forward, b) :-
    write('You turn right.'), nl,
    write('You walk forward.'), nl,
    write('You walk forward.'), nl,
    write('You turn left.'), nl,
    write('You turn right.'), nl,
    write('You turn left.'), nl.

show_transition(state_7_forward, c) :-
    write('You turn around.'), nl,
    write('You walk forward.'), nl,
    write('You turn right.'), nl,
    write('You walk forward.'), nl.

show_transition(state_8_forward, a) :-
    write('You decide to go forward.'), nl,
    write('You walk forward.'), nl,
    write('You walk forward.'), nl,
    write('You walk forward.'), nl.

show_transition(state_8_forward, b) :-
    write('You turn left.'), nl,
    write('You walk forward.'), nl,
    write('You walk forward.'), nl,
    write('You turn right.'), nl.

show_transition(state_8_forward, c) :-
    write('You turn around.'), nl,
    write('You walk forward.'), nl,
    write('You walk forward.'), nl,
    write('You turn right.'), nl,
    write('You walk forward.'), nl.

show_transition(state_9_forward, a) :-
    write('You decide to go forward.'), nl,
    write('You walk forward.'), nl,
    write('You walk forward.'), nl,
    write('You turn left.'), nl,
    write('You walk forward.'), nl,
    write('You walk forward.'), nl,
    write('You walk forward.'), nl,
    write('You turn left.'), nl,
    write('You walk forward.'), nl,
    write('You walk forward.'), nl.

show_transition(state_9_forward, b) :-
    write('You turn left.'), nl,
    write('You walk forward.'), nl,
    write('You walk forward.'), nl,
    write('You walk forward.'), nl,
    write('You turn left.'), nl,
    write('You turn left.'), nl,
    write('You walk forward.'), nl.

show_transition(state_9_forward, c) :-
    write('You turn around.'), nl,
    write('You walk forward.'), nl,
    write('You walk forward.'), nl,
    write('You walk forward.'), nl,
    write('You turn left.'), nl,
    write('You walk forward.'), nl,
    write('You turn left.'), nl,
    write('You walk forward.'), nl,
    write('You turn right.'), nl,
    write('You walk forward.'), nl,
    write('You turn left.'), nl,
    write('You turn right.'), nl,
    write('You turn right.'), nl,
    write('You walk forward.'), nl,
    write('You turn left.'), nl,
    write('You turn left.'), nl,
    write('You walk forward.'), nl,
    write('You turn right.'), nl,
    write('You turn right.'), nl,
    write('You walk forward.'), nl,
    write('You walk forward.'), nl.

show_transition(state_10_forward, a) :-
    write('You decide to go forward.'), nl,
    write('You walk forward.'), nl,
    write('You walk forward.'), nl.
    
show_transition(state_10_forward, b) :-
    write('You turn left.'), nl,
    write('You walk forward.'), nl,
    write('You walk forward.'), nl,
    write('You turn left.'), nl.
    
show_transition(state_10_forward, c) :-
    write('You turn around.'), nl,
    write('You walk forward.'), nl,
    write('You walk forward.'), nl.
    
show_transition(state_11_forward, a) :-
    write('You decide to go forward.'), nl,
    write('You walk forward.'), nl.
    
show_transition(state_11_forward, b) :-
    write('You turn right.'), nl,
    write('You walk forward.'), nl,
    write('You turn left.'), nl,
    write('You walk forward.'), nl,
    write('You turn left.'), nl,
    write('You turn right.'), nl.
    
show_transition(state_11_forward, c) :-
    write('You turn around.'), nl,
    write('You walk forward.'), nl,
    write('You turn left.'), nl,
    write('You walk forward.'), nl.
    
show_transition(state_12_forward, a) :-
    write('You decide to go forward.'), nl,
    write('You walk forward.'), nl,
    write('You walk forward.'), nl,
    write('You walk forward.'), nl,
    write('You turn left.'), nl,
    write('You turn left.'), nl,
    write('You walk forward.'), nl,
    write('You turn right.'), nl,
    write('You turn right.'), nl,
    write('You walk forward.'), nl.
    
show_transition(state_12_forward, b) :-
    write('You turn left.'), nl,
    write('You walk forward.'), nl,
    write('You walk forward.'), nl,
    write('You walk forward.'), nl,
    write('You turn right.'), nl,
    write('You walk forward.'), nl,
    write('You walk forward.'), nl,
    write('You turn left.'), nl,
    write('You walk forward.'), nl,
    write('You walk forward.'), nl,
    write('You walk forward.'), nl,
    write('You walk forward.'), nl,
    write('You walk forward.'), nl,
    write('You walk forward.'), nl.
    
show_transition(state_12_forward, c) :-
    write('You turn around.'), nl,
    write('You walk forward.'), nl,
    write('You walk forward.'), nl,
    write('You walk forward.'), nl,
    write('You turn right.'), nl,
    write('You walk forward.'), nl,
    write('You walk forward.'), nl,
    write('You walk forward.'), nl,
    write('You turn right.'), nl,
    write('You walk forward.'), nl.
    
show_transition(state_13_forward, a) :-
    write('You decide to go forward.'), nl,
    write('You walk forward.'), nl,
    write('You walk forward.'), nl,
    write('You walk forward.'), nl,
    write('You walk forward.'), nl,
    write('You turn right.'), nl,
    write('You turn right.'), nl.
    
show_transition(state_13_forward, b) :-
    write('You turn right.'), nl,
    write('You walk forward.'), nl,
    write('You walk forward.'), nl,
    write('You walk forward.'), nl,
    write('You turn left.'), nl,
    write('You turn left.'), nl,
    write('You walk forward.'), nl,
    write('You turn right.'), nl,
    write('You turn right.'), nl,
    write('You walk forward.'), nl,
    write('You turn left.'), nl,
    write('You turn left.'), nl,
    write('You turn right.'), nl,
    write('You walk forward.'), nl,
    write('You turn left.'), nl,
    write('You walk forward.'), nl,
    write('You turn right.'), nl,
    write('You walk forward.'), nl,
    write('You turn right.'), nl,
    write('You walk forward.'), nl,
    write('You walk forward.'), nl,
    write('You walk forward.'), nl.

show_transition(state_13_forward, c) :-
    write('You turn around.'), nl,
    write('You walk forward.'), nl,
    write('You walk forward.'), nl,
    write('You walk forward.'), nl.
    
show_transition(state_14_forward, a) :-
    write('You decide to go forward.'), nl,
    write('You walk forward.'), nl,
    write('You turn right.'), nl,
    write('You walk forward.'), nl,
    write('You walk forward.'), nl.
    
show_transition(state_14_forward, b) :-
    write('You turn right.'), nl,
    write('You walk forward.'), nl,
    write('You walk forward.'), nl,
    write('You walk forward.'), nl.
    
show_transition(state_14_forward, c) :-
    write('You turn around.'), nl,
    write('You walk forward.'), nl,
    write('You turn left.'), nl,
    write('You turn right.'), nl,
    write('You walk forward.'), nl,
    write('You turn right.'), nl.

show_transition(state_1_retracing, a) :-
    write('You decide to go left.'), nl,
    write('You get back to the gate that'), nl,
    write('you started at, but it''s locked.'), nl,
    write('You turn around, and go back to the'), nl,
    write('intersection.'), nl.

show_transition(state_1_retracing, b) :-
    write('You turn right.'), nl,
    write('You walk forward.'), nl,
    write('You walk forward.'), nl.

show_transition(state_1_retracing, c) :-
    write('You turn around.'), nl,
    write('You walk forward.'), nl,
    write('You turn left.'), nl,
    write('You turn right.'), nl,
    write('You turn right.'), nl,
    write('You turn left.'), nl,
    write('You turn left.'), nl,
    write('You turn right.'), nl.

show_transition(state_2_retracing, a) :-
    write('You turn left.'), nl,
    write('You walk forward.'), nl,
    write('You turn left.'), nl,
    write('You walk forward.'), nl,
    write('You turn left.'), nl,
    write('You turn right.'), nl,
    write('You turn right.'), nl,
    write('You walk forward.'), nl,
    write('You walk forward.'), nl.

show_transition(state_2_retracing, b) :-
    write('You turn right.'), nl,
    write('You walk forward.'), nl,
    write('You walk forward.'), nl,
    write('You walk forward.'), nl,
    write('You walk forward.'), nl,
    write('You walk forward.'), nl,
    write('You walk forward.'), nl.

show_transition(state_2_retracing, c) :-
    write('You turn around.'), nl,
    write('You walk forward.'), nl,
    write('You turn left.'), nl,
    write('You walk forward.'), nl,
    write('You walk forward.'), nl,
    write('You walk forward.'), nl,
    write('You walk forward.'), nl,
    write('You walk forward.'), nl,
    write('You turn right.'), nl.

show_transition(state_3_retracing, a) :-
    write('You turn left.'), nl,
    write('You walk forward.'), nl,
    write('You turn left.'), nl,
    write('You turn right.'), nl,
    write('You turn right.'), nl,
    write('You turn left.'), nl,
    write('You turn left.'), nl,
    write('You turn right.'), nl.

show_transition(state_3_retracing, b) :-
    write('You turn right.'), nl,
    write('You walk forward.'), nl.

show_transition(state_3_retracing, c) :-
    write('You turn around.'), nl,
    write('You walk forward.'), nl,
    write('You turn left.'), nl,
    write('You walk forward.'), nl,
    write('You turn left.'), nl,
    write('You walk forward.'), nl,
    write('You turn left.'), nl,
    write('You walk forward.'), nl,
    write('You walk forward.'), nl,
    write('You walk forward.'), nl,
    write('You walk forward.'), nl,
    write('You turn right.'), nl.

%state four cannot retrace

show_transition(state_5_retracing, a) :-
    write('You turn left.'), nl,
    write('You walk forward.'), nl,
    write('You turn left.'), nl,
    write('You walk forward.'), nl,
    write('You walk forward.'), nl,
    write('You walk forward.'), nl,
    write('You walk forward.'), nl,
    write('You walk forward.'), nl,
    write('You turn right.'), nl.

show_transition(state_5_retracing, b) :-
    write('You turn right.'), nl,
    write('You walk forward.'), nl,
    write('You turn right.'), nl.

show_transition(state_5_retracing, c) :-
    write('You turn around.'), nl,
    write('You walk forward.'), nl,
    write('You walk forward.'), nl,
    write('You turn left.'), nl,
    write('You walk forward.'), nl.

show_transition(state_6_retracing_from_2, a) :-
    write('You turn left.'), nl,
    write('You walk forward.'), nl,
    write('You walk forward.'), nl.

show_transition(state_6_retracing_from_2, b) :-
    write('You turn right.'), nl,
    write('You walk forward.'), nl,
    write('You turn left.'), nl,
    write('You walk forward.'), nl,
    write('You walk forward.'), nl,
    write('You walk forward.'), nl,
    write('You walk forward.'), nl,
    write('You turn right.'), nl,
    write('You walk forward.'), nl,
    write('You turn right.'), nl,
    write('You walk forward.'), nl,
    write('You turn right.'), nl.

show_transition(state_6_retracing_from_2, c) :-
    write('You turn around.'), nl,
    write('You walk forward.'), nl,
    write('You walk forward.'), nl,
    write('You walk forward.'), nl,
    write('You turn left.'), nl,
    write('You turn left.'), nl,
    write('You turn right.'), nl,
    write('You walk forward.'), nl,
    write('You turn right.'), nl.

show_transition(state_6_retracing_from_10, a) :-
    write('You decide to go forward.'), nl,
    write('You walk forward.'), nl,
    write('You turn left.'), nl,
    write('You walk forward.'), nl,
    write('You walk forward.'), nl,
    write('You walk forward.'), nl,
    write('You walk forward.'), nl,
    write('You turn right.'), nl,
    write('You walk forward.'), nl,
    write('You turn right.'), nl,
    write('You walk forward.'), nl,
    write('You turn right.'), nl.

show_transition(state_6_retracing_from_10, b) :-
    write('You turn right.'), nl,
    write('You walk forward.'), nl,
    write('You walk forward.'), nl,
    write('You walk forward.'), nl,
    write('You turn left.'), nl,
    write('You turn left.'), nl,
    write('You turn right.'), nl,
    write('You walk forward.'), nl,
    write('You turn right.'), nl.

show_transition(state_6_retracing_from_10, c) :-
    write('You turn around.'), nl,
    write('You walk forward.'), nl,
    write('You walk forward.'), nl.

show_transition(state_7_retracing, a) :-
    write('You turn left.'), nl,
    write('You walk forward.'), nl.

show_transition(state_7_retracing, b) :-
    write('You turn right.'), nl,
    write('You walk forward.'), nl,
    write('You turn right.'), nl,
    write('You walk forward.'), nl.

show_transition(state_7_retracing, c) :-
    write('You turn around.'), nl,
    write('You walk forward.'), nl,
    write('You walk forward.'), nl,
    write('You turn left.'), nl,
    write('You turn right.'), nl,
    write('You turn left.'), nl.

show_transition(state_8_retracing, a) :-
    write('You turn left.'), nl,
    write('You walk forward.'), nl,
    write('You walk forward.'), nl,
    write('You walk forward.'), nl.

show_transition(state_8_retracing, b) :-
    write('You turn right.'), nl,
    write('You walk forward.'), nl,
    write('You walk forward.'), nl,
    write('You turn right.'), nl,
    write('You walk forward.'), nl.

show_transition(state_8_retracing, c) :-
    write('You turn around.'), nl,
    write('You walk forward.'), nl,
    write('You walk forward.'), nl,
    write('You turn right.'), nl.

show_transition(state_9_retracing, a) :-
    write('You decide to go forwards.'), nl,
    write('You walk forward.'), nl,
    write('You walk forward.'), nl,
    write('You walk forward.'), nl,
    write('You turn left.'), nl,
    write('You walk forward.'), nl,
    write('You turn left.'), nl,
    write('You walk forward.'), nl,
    write('You turn right.'), nl,
    write('You walk forward.'), nl,
    write('You turn left.'), nl,
    write('You turn right.'), nl,
    write('You turn right.'), nl,
    write('You walk forward.'), nl,
    write('You turn left.'), nl,
    write('You turn left.'), nl,
    write('You walk forward.'), nl,
    write('You turn right.'), nl,
    write('You turn right.'), nl,
    write('You walk forward.'), nl,
    write('You walk forward.'), nl.

show_transition(state_9_retracing, b) :-
    write('You turn right.'), nl,
    write('You walk forward.'), nl,
    write('You walk forward.'), nl,
    write('You walk forward.'), nl,
    write('You turn right.'), nl,
    write('You turn right.'), nl,
    write('You walk forward.'), nl.

show_transition(state_9_retracing, c) :-
    write('You turn around.'), nl,
    write('You walk forward.'), nl,
    write('You walk forward.'), nl,
    write('You turn left.'), nl,
    write('You walk forward.'), nl,
    write('You walk forward.'), nl,
    write('You walk forward.'), nl,
    write('You turn left.'), nl,
    write('You walk forward.'), nl,
    write('You walk forward.'), nl.

show_transition(state_10_retracing, a) :-
    write('You turn left.'), nl,
    write('You walk forward.'), nl,
    write('You walk forward.'), nl.

show_transition(state_10_retracing, b) :-
    write('You turn right.'), nl,
    write('You walk forward.'), nl,
    write('You walk forward.'), nl.

show_transition(state_10_retracing, c) :-
    write('You turn around.'), nl,
    write('You walk forward.'), nl,
    write('You walk forward.'), nl,
    write('You turn left.'), nl.

show_transition(state_11_retracing, a) :-
    write('You turn left.'), nl,
    write('You walk forward.'), nl,
    write('You turn left.'), nl,
    write('You walk forward.'), nl.

show_transition(state_11_retracing, b) :-
    write('You turn right.'), nl,
    write('You walk forward.'), nl.

show_transition(state_11_retracing, c) :-
    write('You turn around.'), nl,
    write('You walk forward.'), nl,
    write('You turn left.'), nl,
    write('You walk forward.'), nl,
    write('You turn left.'), nl,
    write('You turn right.'), nl.

show_transition(state_12_retracing, a) :-
    write('You turn left.'), nl,
    write('You walk forward.'), nl,
    write('You walk forward.'), nl,
    write('You walk forward.'), nl,
    write('You turn left.'), nl,
    write('You turn left.'), nl,
    write('You walk forward.'), nl,
    write('You turn right.'), nl,
    write('You turn right.'), nl,
    write('You walk forward.'), nl.

show_transition(state_12_retracing, b) :-
    write('You turn right.'), nl,
    write('You walk forward.'), nl,
    write('You walk forward.'), nl,
    write('You walk forward.'), nl,
    write('You turn right.'), nl,
    write('You walk forward.'), nl,
    write('You walk forward.'), nl,
    write('You walk forward.'), nl,
    write('You turn right.'), nl,
    write('You walk forward.'), nl.

show_transition(state_12_retracing, c) :-
    write('You turn around.'), nl,
    write('You walk forward.'), nl,
    write('You walk forward.'), nl,
    write('You walk forward.'), nl,
    write('You turn right.'), nl,
    write('You walk forward.'), nl,
    write('You walk forward.'), nl,
    write('You turn left.'), nl,
    write('You walk forward.'), nl,
    write('You walk forward.'), nl,
    write('You walk forward.'), nl,
    write('You walk forward.'), nl,
    write('You walk forward.'), nl,
    write('You walk forward.'), nl.

show_transition(state_13_retracing, a) :-
    write('You turn left.'), nl,
    write('You walk forward.'), nl,
    write('You walk forward.'), nl,
    write('You walk forward.'), nl.

show_transition(state_13_retracing, b) :-
    write('You turn right.'), nl,
    write('You walk forward.'), nl,
    write('You walk forward.'), nl,
    write('You walk forward.'), nl,
    write('You walk forward.'), nl,
    write('You turn right.'), nl,
    write('You turn right.'), nl.

show_transition(state_13_retracing, c) :-
    write('You turn around.'), nl,
    write('You walk forward.'), nl,
    write('You walk forward.'), nl,
    write('You walk forward.'), nl,
    write('You turn left.'), nl,
    write('You turn left.'), nl,
    write('You walk forward.'), nl,
    write('You turn right.'), nl,
    write('You turn right.'), nl,
    write('You walk forward.'), nl,
    write('You turn left.'), nl,
    write('You turn left.'), nl,
    write('You turn right.'), nl,
    write('You walk forward.'), nl,
    write('You turn left.'), nl,
    write('You walk forward.'), nl,
    write('You turn right.'), nl,
    write('You walk forward.'), nl,
    write('You turn right.'), nl,
    write('You walk forward.'), nl,
    write('You walk forward.'), nl.

show_transition(state_14_retracing, a) :-
    write('You turn left.'), nl,
    write('You walk forward.'), nl,
    write('You turn left.'), nl,
    write('You turn right.'), nl,
    write('You walk forward.'), nl,
    write('You turn right.'), nl.

show_transition(state_14_retracing, b) :-
    write('You turn right.'), nl,
    write('You walk forward.'), nl,
    write('You turn right.'), nl,
    write('You walk forward.'), nl,
    write('You walk forward.'), nl.

show_transition(state_14_retracing, c) :-
    write('You turn around.'), nl,
    write('You walk forward.'), nl,
    write('You walk forward.'), nl,
    write('You walk forward.'), nl.


show_transition(dead_end_1, a) :-
    write('You decide to go forward.'), nl,
    write('You walk forward.'), nl,
    write('You turn left.'), nl,
    write('You walk forward.'), nl,
    write('You turn left.'), nl,
    write('You turn right.'), nl,
    write('You turn right.'), nl,
    write('You walk forward.'), nl,
    write('You walk forward.'), nl.

show_transition(dead_end_1, b) :-
    write('You turn left.'), nl,
    write('You walk forward.'), nl,
    write('You turn left.'), nl,
    write('You turn left.'), nl,
    write('You walk forward.'), nl,
    write('You walk forward.'), nl,
    write('You walk forward.'), nl,
    write('You walk forward.'), nl,
    write('You walk forward.'), nl,
    write('You turn right.'), nl.

show_transition(dead_end_1, c) :-
    write('You turn around'), nl,
    write('You walk forward.'), nl,
    write('You walk forward.'), nl,
    write('You walk forward.'), nl,
    write('You walk forward.'), nl,
    write('You walk forward.'), nl,
    write('You walk forward.'), nl.

show_transition(dead_end_2, a) :-
    write('You decide to go forward.'), nl,
    write('You walk forward.'), nl,
    write('You turn left.'), nl,
    write('You turn right.'), nl,
    write('You turn right.'), nl,
    write('You turn left.'), nl,
    write('You turn left.'), nl,
    write('You turn right.'), nl.

show_transition(dead_end_2, b) :-
    write('You turn left.'), nl,
    write('You walk forward.'), nl,
    write('You turn left.'), nl,
    write('You walk forward.'), nl,
    write('You turn left.'), nl,
    write('You turn right.'), nl,
    write('You turn left.'), nl,
    write('You walk forward.'), nl,
    write('You walk forward.'), nl,
    write('You walk forward.'), nl,
    write('You walk forward.'), nl,
    write('You turn right.'), nl.

show_transition(dead_end_2, c) :-
    write('You turn around'), nl,
    write('You walk forward.'), nl.

show_transition(dead_end_3, a) :-
    write('You decide to go forward.'), nl,
    write('You get back to the gate that'), nl,
    write('you started at, but it''s locked.'), nl,
    write('You turn around, and go back to the'), nl,
    write('intersection.'), nl.

show_transition(dead_end_3, b) :-
    write('You turn left.'), nl,
    write('You walk forward.'), nl,
    write('You turn left.'), nl,
    write('You turn right.'), nl,
    write('You turn right.'), nl,
    write('You turn left.'), nl,
    write('You turn left.'), nl,
    write('You turn right.'), nl.

show_transition(dead_end_3, c) :-
    write('You turn around'), nl,
    write('You walk forward.'), nl,
    write('You walk forward.'), nl.

show_transition(dead_end_4, a) :-
    write('You decide to go forward.'), nl,
    write('You walk forward.'), nl,
    write('You turn right.'), nl,
    write('You walk forward.'), nl,
    write('You turn right.'), nl.

show_transition(dead_end_4, b) :-
    write('You turn right.'), nl,
    write('You walk forward.'), nl,
    write('You turn right.'), nl,
    write('You turn left.'), nl,
    write('You turn right.'), nl,
    write('You walk forward.'), nl.

show_transition(dead_end_4, c) :-
    write('You turn around'), nl,
    write('You walk forward.'), nl.

show_transition(dead_end_5, a) :-
    write('You decide to go forward.'), nl,
    write('You walk forward.'), nl,
    write('You turn left.'), nl,
    write('You walk forward.'), nl,
    write('You walk forward.'), nl,
    write('You walk forward.'), nl,
    write('You walk forward.'), nl,
    write('You walk forward.'), nl,
    write('You turn right.'), nl.

show_transition(dead_end_5, b) :-
    write('You turn left.'), nl,
    write('You walk forward.'), nl,
    write('You walk forward.'), nl,
    write('You turn left.'), nl,
    write('You walk forward.'), nl.

show_transition(dead_end_5, c) :-
    write('You turn around'), nl,
    write('You walk forward.'), nl,
    write('You turn right.'), nl.

show_transition(dead_end_6, a) :-
    write('You turn left.'), nl,
    write('You walk forward.'), nl,
    write('You walk forward.'), nl,
    write('You turn left.'), nl,
    write('You walk forward.'), nl,
    write('You walk forward.'), nl,
    write('You walk forward.'), nl,
    write('You turn left.'), nl,
    write('You walk forward.'), nl,
    write('You walk forward.'), nl.

show_transition(dead_end_6, b) :-
    write('You turn right.'), nl,
    write('You walk forward.'), nl,
    write('You walk forward.'), nl,
    write('You walk forward.'), nl,
    write('You turn left.'), nl,
    write('You walk forward.'), nl,
    write('You turn left.'), nl,
    write('You walk forward.'), nl,
    write('You turn right.'), nl,
    write('You walk forward.'), nl,
    write('You turn left.'), nl,
    write('You turn right.'), nl,
    write('You turn right.'), nl,
    write('You walk forward.'), nl,
    write('You turn left.'), nl,
    write('You turn left.'), nl,
    write('You walk forward.'), nl,
    write('You turn right.'), nl,
    write('You turn right.'), nl,
    write('You walk forward.'), nl,
    write('You walk forward.'), nl.

show_transition(dead_end_6, c) :-
    write('You turn around'), nl,
    write('You walk forward.'), nl,
    write('You walk forward.'), nl,
    write('You walk forward.'), nl,
    write('You turn right.'), nl,
    write('You turn right.'), nl,
    write('You walk forward.'), nl.

show_transition(dead_end_7_with_key, a) :-
    write('You decide to go forward.'), nl,
    write('You walk forward.'), nl,
    write('You walk forward.'), nl,
    write('You turn left.'), nl,
    write('You turn right.'), nl,
    write('You turn left.'), nl.

show_transition(dead_end_7_with_key, b) :-
    write('You turn right.'), nl,
    write('You walk forward.'), nl,
    write('You turn right.'), nl,
    write('You walk forward.'), nl.

show_transition(dead_end_7_with_key, c) :-
    write('You turn around'), nl,
    write('You walk forward.'), nl.

%there should be no transition messages for the user at
%dead end 7 if they do not have the key; the output is
%taken care of by the state.

show_transition(dead_end_7_without_key, _).

show_transition(dead_end_8, a) :-
    write('You decide to go forward.'), nl,
    write('You walk forward.'), nl.

show_transition(dead_end_8, b) :-
    write('You turn left.'), nl,
    write('You walk forward.'), nl,
    write('You turn right.'), nl,
    write('You turn left.'), nl,
    write('You turn right.'), nl,
    write('You walk forward.'), nl.

show_transition(dead_end_8, c) :-
    write('You turn around'), nl,
    write('You walk forward.'), nl,
    write('You turn right.'), nl,
    write('You walk forward.'), nl,
    write('You turn right.'), nl.

show_transition(dead_end_9, a) :-
    write('You decide to go forward.'), nl,
    write('You walk forward.'), nl,
    write('You turn left.'), nl,
    write('You walk forward.'), nl.

show_transition(dead_end_9, b) :-
    write('You turn left.'), nl,
    write('You walk forward.'), nl,
    write('You turn left.'), nl,
    write('You walk forward.'), nl,
    write('You turn left.'), nl,
    write('You turn right.'), nl.

show_transition(dead_end_9, c) :-
    write('You turn around'), nl,
    write('You walk forward.'), nl.

show_transition(dead_end_10, a) :-
    write('You decide to go forward.'), nl,
    write('You walk forward.'), nl,
    write('You walk forward.'), nl.

show_transition(dead_end_10, b) :-
    write('You turn right.'), nl,
    write('You walk forward.'), nl,
    write('You walk forward.'), nl,
    write('You turn left.'), nl.

show_transition(dead_end_10, c) :-
    write('You turn around'), nl,
    write('You walk forward.'), nl,
    write('You walk forward.'), nl.

show_transition(dead_end_11, a) :-
    write('You decide to go forward.'), nl,
    write('You walk forward.'), nl,
    write('You walk forward.'), nl,
    write('You walk forward.'), nl.

show_transition(dead_end_11, b) :-
    write('You turn left.'), nl,
    write('You walk forward.'), nl,
    write('You walk forward.'), nl,
    write('You walk forward.'), nl,
    write('You turn left.'), nl,
    write('You turn left.'), nl,
    write('You walk forward.'), nl,
    write('You turn right.'), nl,
    write('You turn right.'), nl,
    write('You walk forward.'), nl,
    write('You turn left.'), nl,
    write('You turn left.'), nl,
    write('You turn right.'), nl,
    write('You walk forward.'), nl,
    write('You turn left.'), nl,
    write('You walk forward.'), nl,
    write('You turn right.'), nl,
    write('You walk forward.'), nl,
    write('You turn right.'), nl,
    write('You walk forward.'), nl,
    write('You walk forward.'), nl,
    write('You walk forward.'), nl.

show_transition(dead_end_11, c) :-
    write('You turn around'), nl,
    write('You walk forward.'), nl,
    write('You walk forward.'), nl,
    write('You walk forward.'), nl,
    write('You walk forward.'), nl,
    write('You turn right.'), nl,
    write('You turn right.'), nl.

show_transition(dead_end_12, a) :-
    write('You decide to go forward.'), nl,
    write('You walk forward.'), nl,
    write('You walk forward.'), nl,
    write('You turn right.'), nl,
    write('You walk forward.'), nl.

show_transition(dead_end_12, b) :-
    write('You turn right.'), nl,
    write('You walk forward.'), nl,
    write('You walk forward.'), nl,
    write('You turn right.'), nl.

show_transition(dead_end_12, c) :-
    write('You turn around'), nl,
    write('You walk forward.'), nl,
    write('You walk forward.'), nl,
    write('You walk forward.'), nl.

show_transition(dead_end_13, a) :-
    write('You decide to go forward.'), nl,
    write('You walk forward.'), nl,
    write('You walk forward.'), nl,
    write('You walk forward.'), nl,
    write('You turn right.'), nl,
    write('You walk forward.'), nl,
    write('You walk forward.'), nl,
    write('You walk forward.'), nl,
    write('You turn right.'), nl,
    write('You walk forward.'), nl.

show_transition(dead_end_13, b) :-
    write('You turn right.'), nl,
    write('You walk forward.'), nl,
    write('You walk forward.'), nl,
    write('You walk forward.'), nl,
    write('You turn right.'), nl,
    write('You walk forward.'), nl,
    write('You walk forward.'), nl,
    write('You turn left.'), nl,
    write('You walk forward.'), nl,
    write('You walk forward.'), nl,
    write('You walk forward.'), nl,
    write('You walk forward.'), nl,
    write('You walk forward.'), nl,
    write('You walk forward.'), nl.

show_transition(dead_end_13, c) :-
    write('You turn around'), nl,
    write('You walk forward.'), nl,
    write('You walk forward.'), nl,
    write('You walk forward.'), nl,
    write('You turn left.'), nl,
    write('You turn left.'), nl,
    write('You walk forward.'), nl,
    write('You turn right.'), nl,
    write('You turn right.'), nl,
    write('You walk forward.'), nl.

show_transition(dead_end_14, a) :-
    write('You decide to go forward.'), nl,
    write('You walk forward.'), nl,
    write('You turn left.'), nl,
    write('You turn right.'), nl,
    write('You walk forward.'), nl,
    write('You turn right.'), nl.

show_transition(dead_end_14, b) :-
    write('You turn left.'), nl,
    write('You walk forward.'), nl,
    write('You walk forward.'), nl,
    write('You walk forward.'), nl.

show_transition(dead_end_14, c) :-
    write('You turn around'), nl,
    write('You walk forward.'), nl,
    write('You turn right.'), nl,
    write('You walk forward.'), nl,
    write('You walk forward.'), nl.

%these are the transition messages for the minotaur

show_transition(running, a) :-
    write('You decide to go forward.'), nl,
    write('You walk forward.'), nl,
    write('You walk forward.'), nl,
    write('You turn left.'), nl,
    write('You turn right.'), nl,
    write('You turn left.'), nl.

show_transition(running, b) :-
    write('You turn right'), nl,
    write('You walk forward.'), nl,
    write('You turn right.'), nl,
    write('You walk forward.'), nl.

show_transition(running, c) :-
    write('You turn around.'), nl,
    write('You walk forward.'), nl.

show_transition(leave_minotaur, a) :-
    write('You decide to go forward.'), nl,
    write('You walk forward.'), nl,
    write('You walk forward.'), nl,
    write('You turn left.'), nl,
    write('You turn right.'), nl,
    write('You turn left.'), nl.

show_transition(leave_minotaur, b) :-
    write('You turn right'), nl,
    write('You walk forward.'), nl,
    write('You turn right.'), nl,
    write('You walk forward.'), nl.

show_transition(leave_minotaur, c) :-
    write('You turn around.'), nl,
    write('You walk forward.'), nl.

show_transition(searching, a) :-
    write('You take the key.'), nl,
    retract(stored_answer(has_key, no)),
    asserta(stored_answer(has_key, yes)).

show_transition(searching, b) :-
    write('You leave the key.'), nl.

%some of the states involving the minotaur should not have
%a transition
show_transition(minotaur, _).
show_transition(fighting, _).
show_transition(win, _).
show_transition(lost, _).
show_transition(running, _).
show_transition(searching, _).

%these are transition messages for the back gate
show_transition(exit, b) :-
    write('You turn around.'), nl,
    write('You walk forward.'), nl,
    write('You walk forward.'), nl,
    write('You walk forward.'), nl,
    write('You walk forward.'), nl,
    write('You walk forward.'), nl,
    write('You walk forward.'), nl,
    write('You walk forward.'), nl,
    write('You turn right.'), nl,
    write('You walk forward.'), nl,
    write('You walk forward.'), nl,
    write('You walk forward.'), nl,
    write('You turn left.'), nl,
    write('You walk forward.'), nl,
    write('You walk forward.'), nl.
    
show_transition(gate_without_key, a) :-
	show_transition(exit, b).
    
show_transition(gate_with_key, b) :-
	show_transition(exit, b).

show_transition(gate_open, b) :-
	show_transition(exit, b).

%some of the states involving the back gate should not have
%a transition
show_transition(exit, _).
show_transition(gate_without_key, _).
show_transition(gate_with_key, _).
show_transition(gate_open, _).

show_transition(_, fail) :-
    write('Enter a valid letter. '), nl.

%this is a catch all in case I missed something. I tested the code
%thoroughly, but it is better to have this than let the program
%crash or stop. Even if I did forget to put a transition in for
%a state, it would not display anything; all of the necessary
%output is in the program one way or the other.
show_transition(_,_).

%these display the turn options.
show_turn(forward_and_right) :-
    write('    a - go forward'), nl,
    write('    b - go right'), nl,
    write('    c - go back'), nl,
    write('    q - quit '), nl.

show_turn(forward_and_left) :-
    write('    a - go forward'), nl,
    write('    b - go left'), nl,
    write('    c - go back'), nl,
    write('    q - quit '), nl.

show_turn(left_and_right) :-
    write('    a - go left'), nl,
    write('    b - go right'), nl,
    write('    c - go back'), nl,
    write('    q - quit '), nl.


% basic finite state machine engine

go :-
    intro,
    start_state(X),
    show_state(X),
    get_choice(X,Y),
    go_to_next_state(X,Y).

intro :-
    display_intro,
    clear_stored_answers,
    initialize.

go_to_next_state(_,q) :-
    goodbye,!.

go_to_next_state(S1,Cin) :-
    next_state(S1,Cin,S2),
    nl, nl, nl,
    show_transition(S1,Cin),
    show_state(S2),
    stored_answer(moves,K),
    OneMoreMove is K + 1,
    retract(stored_answer(moves,_)),
    asserta(stored_answer(moves,OneMoreMove)),
    get_choice(S2,Cnew),
    go_to_next_state(S2,Cnew).

go_to_next_state(S1,Cin) :-
    \+ next_state(S1,Cin,_),
    show_transition(S1,fail),
    get_choice(S1,Cnew),
    go_to_next_state(S1,Cnew).

%this quits the program if the user lost or exited the maze
get_choice(lost, q).
get_choice(done, q).

get_choice(_,C) :-
    write('Next entry (letter followed by a period)? '),
    read(C).

goodbye :-
    stored_answer(moves, Count),
    write('You made '),
    write(Count),
    write(' moves.'), nl,
    stored_answer(dead_ends_reached, Dead_Ends_Reached),
    write('You went down '),
    write(Dead_Ends_Reached),
    write(' dead end(s).'), nl.
    

% case knowledge base - user responses

:- dynamic(stored_answer/2).

% procedure to get rid of previous responses
% without abolishing the dynamic declaration

clear_stored_answers :- retract(stored_answer(_,_)),fail.
clear_stored_answers.
