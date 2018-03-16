#!/usr/bin/env bash

################################################################################
#                                                                              #
#                  Bash Sudoku solver                                          #
#                                                                              #
# NAME        : sud2.sh                                                        #
# AUTHORS     : Nachiket Naganure  16IT231                                     #
#               Aayush Jain        16IT101                                     #
#               Bachina Sony       16IT208                                     #
#               Aniket Dwivedi     16IT205                                     #
# Fill the 'board' array with the Sudoku table, replacing the empty cells with #
# zeroes, and run this script.                                                 #
#                                                                              #                                                             #
################################################################################

# This is the game board. Fill it with the puzzle you want to solve
board=(0 6 0 1 0 4 0 5 0
       0 0 8 3 0 5 6 0 0
       2 0 0 0 0 0 0 0 1
       8 0 0 4 0 7 0 0 6
       0 0 6 0 0 0 3 0 0
       7 0 0 9 0 1 0 0 4
       5 0 0 0 0 0 0 0 2
       0 0 7 2 0 6 9 0 0
       0 4 0 5 0 8 0 7 0)


################################################################################
# Constants definition                                                         #
################################################################################
SIZE=9                                   # Width of the Sudoku board
BOX_W=3                                  # Width of the inner boxes
BOX_H=3                                  # Height of the inner boxes
EMPTY=0                                  # Empty cells marker

RET_OK=0                                 # Return value upon success
RET_FAIL=1                               # Return value upon failure

################################################################################
# tput column and row calculation                                              #
################################################################################
cols=$( tput cols )
rows=$( tput lines )
middle_row=$(( $rows / 2 ))
middle_col=$(( $cols / 2 ))
################################################################################
# Functions                                                                    #
################################################################################
function guess () {
    # Test all candidate numbers for current cell until board is complete
    local index=$1                       # Index of the cell to guess

    local row=$((index / SIZE ))         # Row index of current cell
    local col=$((index % SIZE ))         # Column index of current cell
    local i                              # Local counter variable

    # Check if $index is out of array bounds
    [[ $index -eq ${#board[@]} ]] && return $RET_OK

    # If the cell isn't empty, go on to the next one
    if [[ ${board[index]} -ne $EMPTY ]]; then
        guess $(( index + 1 ))
        return $?
    fi

    # Test all numbers from 1 to 9
    for ((i=1; i <= SIZE; i++)); do
        check $i $row $col && {
            # Assign $i to cell and go on to the next cell
            board[index]=$i
            guess $(( index + 1 )) && return $RET_OK
        }
    done

    # If all numbers fail, empty the cell and return RET_FAIL
    board[index]=$EMPTY
    return $RET_FAIL
}

function check () {
    # Check if a number is, according to Sudoku rules, a legal candidate for the
    #   cell identified by its row and column indexes
    local num=$1                         # Number to check
    local row=$2                         # Cell's row index
    local col=$3                         # Cell's column index

    local i                              # Local counter variable

    # Check if the cell's row contains num
    for i in ${board[@]:$(( row * SIZE )):SIZE}; do
        [[ $num -eq $i ]] && return $RET_FAIL
    done

    # Check if the cell's column contains num
    for (( i=col; i < ${#board[@]}; i+=SIZE )); do
        [[ $num -eq ${board[i]} ]] && return $RET_FAIL
    done

    # Get the top left corner indexes of the cell's 3x3 box
    local box_row=$(( $row - $row % BOX_H ))
    local box_col=$(( $col - $col % BOX_W ))

    # Check if the box contains num
    for (( r = 0; r < BOX_H; r++ )); do
        for i in ${board[@]:$(( box_col + (box_row + r) * SIZE )):BOX_W}; do
            [[ $num -eq $i ]] && return $RET_FAIL
        done
    done

    # If all previous tests have been passed, return RET_OK
    return $RET_OK
}

# Function to draw the sudoku board
function drawboard()
{
   local index=$1
  tput 'cup' $z 0
  echo -n $'\e[40m'
  for ((j=1;j<=9;j++))
  do
    for ((i=1;i<=9;i++))
    do 
        echo -n " ${board[$index]}"
        ((index=index+1))
    done
 echo ' '
 done
  echo -n $'\e[0m'

}
################################################################################
# Main                                                                         #
################################################################################
clear
tput cup 0 $middle_col
tput bold
echo "Sudoku Puzzle Solver"
tput sgr0
echo ''
echo ''
echo 'Enter your Sudoku input'
echo 'Enter the the 0 for blank box '
echo ''
k=0
for ((j=1;j<=9;j++))
  do
    echo "Enter for row number $j:"
    for ((i=1;i<=9;i++))
    do 
        read n
        board[$k]=$n
        ((k=k+1))
    done
 echo ' '
 done
clear
tput cup 0 $middle_col
tput bold
echo "Sudoku Puzzle Solver"
tput sgr0
echo "Given Input:"
z=3
drawboard
((z=z+11))
guess 0
rc=$?
echo ' '
echo "Output Generated:"
echo ' '

if [[ $rc -eq $RET_OK ]]; then
    drawboard
else
    echo "Sorry, solution not found..."
fi

exit $rc