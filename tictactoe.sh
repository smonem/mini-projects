#!/bin/bash

# Init tic-tac-toe array
ttt=(0 0 0 0 0 0 0 0 0)

# Function to check game end
function win_check() {
    if [ "$1" == 3 ] || [ "$1" == -3 ]; then 
        echo "WINNER"
        game_valid=false
    fi
}

# Run until game end
game_valid=true
while [ $game_valid == true ]; do
    echo
    for row in {0..2}; do
        for col in {0..2}; do
	    # Print grid
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

    # Player interaction
    read -rp "Select square: " selection
    if ((selection >= 1 && selection <= 9)); then
        if [[ ttt[$selection-1] -eq 0 ]]; then
            (( ttt[selection-1]++ ))
        else
            printf "Invalid input\n"
        fi
    else
        printf "Invalid input\n"
    fi
    
    # AI move
    choice_invalid=true
    tries_counter=0
    while [ $choice_invalid == true ]; do
        ai_choice=$(shuf -i 0-8 -n 1)
        if [[ ttt[ai_choice] -eq 0 ]]; then
            choice_invalid=false
            (( ttt[ai_choice]-=1 ))
        fi
        ((tries_counter++))
        if [ $tries_counter -gt 50 ]; then
            echo "DRAW"
            game_valid=false
            choice_invalid=false
        fi
    done

    # Check game end
    target=0

    # Rows
    for ((i = 0 ; i < 3; i++));
        do for ((j = 0 ; j < 3 ; j++));
            do ((target+=ttt[i*3+j])) 
        done
        win_check $target
        target=0 # reset
    done

    # cols
    for ((i = 0 ; i < 3; i++));
        do for ((j = 0 ; j < 3 ; j++));
            do ((target+=ttt[j*3+i])) 
        done
        win_check $target
        target=0 # reset
    done

    # diag
    ((target+=(ttt[0]+ttt[4]+ttt[8]))) 
    win_check $target
    target=0 # reset

    ((target+=(ttt[2]+ttt[4]+ttt[6]))) 
    win_check $target
    target=0 # reset


done
