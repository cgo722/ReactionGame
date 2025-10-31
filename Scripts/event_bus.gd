extends Node

# Player related signals
signal player_input

# Game state signals
signal game_state_changed(new_state)
signal round_won
signal round_lost

# UI signals
signal start_game
signal retry
signal return_to_menu
