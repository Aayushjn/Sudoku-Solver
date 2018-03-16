#!/bin/bash


################################################################################
#                                                                              #
#                  Bash Sudoku solver                                          #
#                                                                              #
# NAME        : main.sh                                                        #
# AUTHORS     : Nachiket Naganure  16IT231                                     #
#               Aayush Jain        16IT101                                     #
#               Bachina Sony       16IT208                                     #
#               Aniket Dwivedi     16IT205                                     #
# Fill the 'board' array with the Sudoku table, replacing the empty cells with #
# zeroes, and run this script.                                                 #
#                                                                              #               
################################################################################

#Finding the no of columns and rows available in terminal
cols=$( tput cols )
rows=$( tput lines )
middle_row=$(( $rows / 2 ))
middle_col=$(( $cols / 2 ))


tput clear

#loop around gathering input until QUIT is more than 0

QUIT=0

SEL=0

while [ $QUIT -lt 1 -o $SEL -ne 3 ]

do

   #paint menu onto the screen

   tput cup 0 $middle_col
   tput bold
   echo "Sudoku Puzzle Solver"
   tput sgr0
   echo ""

   echo ""

   echo " SUDOKU MENU"

   echo " 1.   Solve "

   echo " 2.   Enter your own input"

   echo " 3.   QUIT"

   echo ""

   echo "Enter Choice Number: "

   #Move cursor to after select message

   tput cup 8 22

   #Delete from cursor to end of line

   tput el

   read SEL

   if [ ${#SEL} -lt 1 ]

   then

      continue

   fi

   #call the required shell or set QUIT and continue the loop,
   #or continue the loop on any other input

   case $SEL in

      1) chmod 755 sud.sh
         exec ./sud.sh;;

      2) chmod 755 sud2.sh
         exec ./sud2.sh;;

      3) QUIT=1

      continue;;

      *) continue;;

   esac

done

#reset the screen on exit

if [ $TERM = "linux" ]

then

   tput setb 0

fi

tput reset

tput clear

exit