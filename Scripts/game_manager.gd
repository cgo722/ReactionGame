extends Node

enum GameState {
    STATE_MENU,
    STATE_PLAYING,
    STATE_POWERUP,
    STATE_GAME_OVER
}

@export var current_state: GameState = GameState.STATE_MENU
@export var main_menu: PackedScene
@export var all_levels : Array[PackedScene]

func _ready() -> void:
    current_state = GameState.STATE_MENU
    update_scene()
func update_scene():
    # Remove all children
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

# Handler for playground state changes
func _on_playground_state_changed(new_state):
    # Add your logic here for each state
    match new_state:
        0: # PlaygroundState.STATE_BEFORE
            print("GameManager: Playground state is BEFORE")
        1: # PlaygroundState.STATE_ACTIVE
            print("GameManager: Playground state is ACTIVE")

# Handler for main menu signal
func _on_request_playing_state():
    current_state = GameState.STATE_PLAYING
    update_scene()

