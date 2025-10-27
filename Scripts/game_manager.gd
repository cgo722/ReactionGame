extends Node

enum GameState {
    STATE_MENU,
    STATE_PLAYING,
    STATE_PAUSED,
    STATE_GAME_OVER
}

@export var current_state: GameState = GameState.STATE_MENU
@export var main_menu: PackedScene
@export var playground_scene: PackedScene

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
            if playground_scene:
                var playground_instance = playground_scene.instantiate()
                add_child(playground_instance)

# Handler for main menu signal
func _on_request_playing_state():
    current_state = GameState.STATE_PLAYING
    update_scene()

