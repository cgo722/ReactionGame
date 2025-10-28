extends Node

enum GameState {
    STATE_MENU,
    STATE_PLAYING,
    STATE_POWERUP,
    STATE_GAME_OVER
}

@export var current_state: GameState = GameState.STATE_MENU
@export var main_menu: PackedScene
@export var game_over_scene: PackedScene
@export var all_levels : Array[PackedScene]

func _ready() -> void:
    current_state = GameState.STATE_MENU
    update_scene()
func update_scene():
    for child in get_children():
        remove_child(child)
        child.queue_free()

    # Spawn scene based on state
    match current_state:
        GameState.STATE_MENU:
            if main_menu:
                var menu_instance = main_menu.instantiate()
                add_child(menu_instance)
                # Connect the signal from main menu
                if menu_instance.has_signal("request_playing_state"):
                    menu_instance.connect("request_playing_state", Callable(self, "_on_request_playing_state"))
        GameState.STATE_PLAYING:
            if all_levels:
                var playground_instance = all_levels[0].instantiate()
                add_child(playground_instance)
                # Connect to playground state_changed signal
                if playground_instance.has_signal("state_changed"):
                    playground_instance.connect("state_changed", Callable(self, "_on_playground_state_changed"))
        GameState.STATE_GAME_OVER:
            # Overlay game over screen, keep playground
            var game_over_instance = game_over_scene.instantiate()
            add_child(game_over_instance)
            # Connect signals from game over screen
            if game_over_instance.has_signal("request_main_menu"):
                game_over_instance.connect("request_main_menu", Callable(self, "_on_request_main_menu"))
            if game_over_instance.has_signal("request_retry"):
                game_over_instance.connect("request_retry", Callable(self, "_on_request_retry"))
        GameState.STATE_POWERUP:
            # Handle power-up state (not implemented here)
            pass
# Handler for ad continue signal

# Handler for game over screen main menu signal
func _on_request_main_menu():
    current_state = GameState.STATE_MENU
    update_scene()

# Handler for game over screen retry signal
func _on_request_retry():
    current_state = GameState.STATE_PLAYING
    update_scene()

# Handler for playground state changes
func _on_playground_state_changed(new_state):
    # Only process if still playing
    match new_state:
        0: # PlaygroundState.STATE_Win
            print("GameManager: Win")
            current_state = GameState.STATE_POWERUP
            update_scene()
        1: # PlaygroundState.STATE_LOSE
            print("GameManager: Lose")
            current_state = GameState.STATE_GAME_OVER
            update_scene()

# Handler for main menu signal
func _on_request_playing_state():
    current_state = GameState.STATE_PLAYING
    update_scene()

