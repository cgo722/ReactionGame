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
@export var playground_scene: PackedScene
@export var enemy_resources : Array[Resource]
var current_round = 0

func _ready() -> void:
    EventBus.start_game.connect(_on_event_bus_start_game)
    EventBus.round_won.connect(_on_event_bus_round_won)
    EventBus.round_lost.connect(_on_event_bus_round_lost)
    EventBus.retry.connect(_on_event_bus_retry)
    EventBus.return_to_menu.connect(_on_event_bus_return_to_menu)

    current_state = GameState.STATE_MENU
    update_scene()

func _exit_tree():
    EventBus.start_game.disconnect(_on_event_bus_start_game)
    EventBus.round_won.disconnect(_on_event_bus_round_won)
    EventBus.round_lost.disconnect(_on_event_bus_round_lost)
    EventBus.retry.disconnect(_on_event_bus_retry)
    EventBus.return_to_menu.disconnect(_on_event_bus_return_to_menu)

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
        GameState.STATE_PLAYING:
            if playground_scene and enemy_resources:
                var playground_instance = playground_scene.instantiate()
                var enemy_index = current_round % enemy_resources.size()
                if current_round > 0 and enemy_index == 0: # A full cycle is complete
                    for resource in enemy_resources:
                        resource.min_wait_time /= 2
                        resource.max_wait_time /= 2
                playground_instance.enemy_resource = enemy_resources[enemy_index]
                playground_instance.current_round = current_round
                add_child(playground_instance)
        GameState.STATE_GAME_OVER:
            var game_over_instance = game_over_scene.instantiate()
            add_child(game_over_instance)
        GameState.STATE_POWERUP:
            pass

func _on_event_bus_start_game():
    current_round = 0
    current_state = GameState.STATE_PLAYING
    update_scene()

func _on_event_bus_round_won():
    print("GameManager: Win")
    current_round += 1
    current_state = GameState.STATE_PLAYING
    update_scene()

func _on_event_bus_round_lost():
    print("GameManager: Lose")
    current_state = GameState.STATE_GAME_OVER
    update_scene()

func _on_event_bus_retry():
    current_state = GameState.STATE_PLAYING
    update_scene()

func _on_event_bus_return_to_menu():
    current_state = GameState.STATE_MENU
    update_scene()