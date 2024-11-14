#!/bin/bash

# Imports
source ./game_library.sh

# Script options
player_1_human=true
while getopts 'ra' flag; do
  case "${flag}" in
    r) # reset
    rm "./tictactoe_stats.csv" ;;
    a) # auto
    player_1_human=false ;;
    *) # Invalid
    printf "Option not recognized\n"
  esac
done

# Setup stats file
stats="tictactoe_stats.csv"

if [ ! -f "$stats" ]; then
  touch "$stats"
  echo "date", "winner", "num_moves", "board" > $stats
  echo -e "Created $stats\n"
fi

# Init tic-tac-toe array and stats
board=(0 0 0 0 0 0 0 0 0)
num_moves=0
game_date=$(date '+%Y-%m-%d %H:%M:%S')

# Function to declare victory and write out game stats
function game_end() {
    print_grid "${board[@]}"
    if [ "$1" != 0 ]; then
        echo -e "\nWINNER: PLAYER $1"
    else
        echo -e "\nDRAW"
    fi
    echo "$game_date,$1,$num_moves,${board[*]}" >> $stats
    exit 0
}

# Function to check game end
function win_check() {
    # 3 or -3 indicates full row/col/diag
    if [ "$1" == -3 ]; then game_end 2 return; fi
    if [ "$1" == 3 ]; then game_end 1; fi
}

# Function to check board state
function check_board_state() {
    # Check game end
    target=0
    target_row=0
    target_col=0

    # Rows and cols
    for ((i = 0 ; i < 3; i++));
        do for ((j = 0 ; j < 3 ; j++));
            do ((target_row+=board[i*3+j]))
            ((target_col+=board[j*3+i])) 
        done
        win_check $target_row
        win_check $target_col
        target_row=0 # reset
        target_col=0 # reset
    done

    # Diagonals
    ((target+=(board[0]+board[4]+board[8]))) 
    win_check $target
    target=0 # reset

    ((target+=(board[2]+board[4]+board[6]))) 
    win_check $target
}

# AI selects choice from board
function ai_move() {
    choice_invalid=true
    tries_counter=0
    while [ $choice_invalid == true ]; do
        ai_choice=$(shuf -i 0-8 -n 1)
        if [[ board[ai_choice] -eq 0 ]]; then
            choice_invalid=false
            (( board[ai_choice]+=$1 ))
            (( num_moves+=1 ))
        fi
        ((tries_counter++))
        if [ $tries_counter -gt 30 ]; then
            game_end 0
        fi
    done
    check_board_state
}

# Run until game end
while true; do
    print_grid "${board[@]}"

    # Player 1 move
    if $player_1_human; then
        read -rp "Select square (1-9): " selection
        if ((selection >= 1 && selection <= 9)) && \
        [[ board[$selection-1] -eq 0 ]]; then
                (( board[selection-1]++ ))
                (( num_moves+=1 ))
            else
                printf "Invalid input\n"
        fi
        check_board_state
    else
        ai_move 1
    fi

    # Player 2 move
    ai_move -1

done