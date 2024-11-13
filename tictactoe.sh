#!/bin/bash

# Setup stats file
stats="tictactoe_stats.csv"

if [ ! -f "$stats" ]; then
  touch "$stats"
  echo -e "Created $stats\n"
fi

# Init tic-tac-toe array and stats
ttt=(0 0 0 0 0 0 0 0 0)
num_moves=0
game_date=$(date '+%Y-%m-%d %H:%M:%S')

# Function to print game grid
function print_grid() {
    printf "\n"
    for row in {0..2}; do
        for col in {0..2}; do
            if [ "${ttt[row*3+col]}" == 0 ]; then
                printf "* "
            elif [ "${ttt[row*3+col]}" == 1 ]; then
                printf "X "
            else
                printf "0 "
            fi
        done
        printf "\n"
    done
}

# Function to declare victory and write out game stats
function game_end() {
    print_grid
    if [ "$1" != 0 ]; then
        echo -e "\nWINNER: PLAYER $1"
    else
        echo -e "\nDRAW"
    fi
    echo "$game_date, $1, $num_moves, ${ttt[*]}" >> $stats
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
            do ((target_row+=ttt[i*3+j]))
            ((target_col+=ttt[j*3+i])) 
        done
        win_check $target_row
        win_check $target_col
        target_row=0 # reset
        target_col=0 # reset
    done

    # Diagionals
    ((target+=(ttt[0]+ttt[4]+ttt[8]))) 
    win_check $target
    target=0 # reset

    ((target+=(ttt[2]+ttt[4]+ttt[6]))) 
    win_check $target
}

# Run until game end
while true; do
    print_grid

    # Player interaction
    read -rp "Select square: " selection
    if ((selection >= 1 && selection <= 9)); then
        if [[ ttt[$selection-1] -eq 0 ]]; then
            (( ttt[selection-1]++ ))
            (( num_moves+=1 ))
        else
            printf "Invalid input\n"
        fi
    else
        printf "Invalid input\n"
    fi
    check_board_state
    
    # AI move
    choice_invalid=true
    tries_counter=0
    while [ $choice_invalid == true ]; do
        ai_choice=$(shuf -i 0-8 -n 1)
        if [[ ttt[ai_choice] -eq 0 ]]; then
            choice_invalid=false
            (( ttt[ai_choice]-=1 ))
            (( num_moves+=1 ))
        fi
        ((tries_counter++))
        if [ $tries_counter -gt 30 ]; then
            game_end 0
            choice_invalid=false
        fi
    done
    check_board_state

done