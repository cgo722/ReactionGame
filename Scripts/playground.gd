extends Node2D

enum PlaygroundState {
    STATE_BEFORE,
    STATE_ACTIVE,
    STATE_AFTER
}
    # Holds the current state of the playground
var state = PlaygroundState.STATE_BEFORE
@export var timer: Timer
@export var timer_duration_min: float = 1.0
@export var timer_duration_max: float = 5.0
@export var player: Node2D
func _ready():
    timer.wait_time = randf_range(timer_duration_min, timer_duration_max)
    timer.start()
    # Set initial state when spawned
    state = PlaygroundState.STATE_BEFORE
    # Find Player node and connect to its screen_touched signal
    if player:
        player.connect("screen_touched", Callable(self, "_on_player_screen_touched"))

func _on_player_screen_touched():
    if state == PlaygroundState.STATE_BEFORE or state == PlaygroundState.STATE_AFTER:
        print("Lose")
    elif state == PlaygroundState.STATE_ACTIVE:
        print("Win")

func _on_timer_timeout() -> void:
    # Set state to active when timer times out
    state = PlaygroundState.STATE_ACTIVE
