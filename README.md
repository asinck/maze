# maze

This program will implement a quest. It will start the user at the beginning of
a maze, and they will have to get to the end of the maze and open a gate with a
key that they get from a minotaur. The picture I used was adapted from
http://www.scnfamily.org/youth/maze/files/maze2_img.jpg . 
The minotaur is in the dead end at the center of the maze. For the dead end
counter, this state is not counted unless the minotaur is dead and you have the
key.

I wrote this program for my CSC 240 class. The goal was to create a
choose-your-own-adventure program, with both good and bad outcome(s). I
generated most of the code with a secondary python program, because it would
have taken forever to type it all, and would be error prone. The code after
the comment that says, "basic finite state machine engine" was given to the
class by the professor so that we could focus on the states of the adventure,
instead of getting the program to run. Each student was to customize the engine
to work for their code. This code works under Ubuntu 14.10, running SWI-Prolog
in the command line. This is the original code that I submitted.

The optimal sequence is:
```
 state - option
 1 - right
 3 - right
 6 - forward
 10 - left
 7 - left
 fight the minotaur
 face the minotaur with your skill against his
 search for useful items
 take the key and leave
 7 - right
 10 - right
 6 - right
 2 - right
 5 - right
 8 - left
 11 - right
 14 - right
 13 - right
 9 - forward
 12 - left
 exit - try the gate
 gate - exit
```
If you lose your place, you either look at the code and figure out what section
of tunnel you just walked through, start over, or hope for really good luck.
