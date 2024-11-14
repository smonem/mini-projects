#!/bin/bash

# Imports
source ./game_library.sh

# Print overall game stats
num_games=0
games_won=0
avg_moves=0
win_rate=0
{
read -r
while IFS=, read -r date winner moves board
do
    (( num_games+=1 ))
    (( avg_moves = (avg_moves * (num_games-1) + moves) / num_games )) # Calculate moving average
    if [ "$winner" == 1 ]; then
        (( games_won+=1 ))
    fi
    win_rate=$(echo "scale=2; $games_won / $num_games" | bc) # using bc for floating point calculation
done
} < tictactoe_stats.csv

echo "Aggregate Statistics for games"
echo "Total Games Played: $num_games"
echo "Win percentage: $win_rate"
echo "Average number of moves: $avg_moves"

# Print games
{
read -r 
while IFS=, read -r date winner moves board
do
    IFS=', ' read -r -a grid <<< "$board" # Convert board state into array
    print_grid "${grid[@]}"
    echo "$date"
    if [ "$winner" != 0 ]; then
        echo "Winner: Player $winner"
    else
        echo "Draw"
    fi
    echo "Number of Moves: $moves"
done
} < tictactoe_stats.csv