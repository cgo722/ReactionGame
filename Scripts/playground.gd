extends Node2D

# Signal to notify GameManager of state changes
signal state_changed(new_state)

enum PlaygroundState {
    STATE_WIN,
    STATE_LOSE
}
    # Holds the current state of the playground
var state = PlaygroundState.STATE_LOSE
@export var timer: Timer
@export var timer_duration_min: float = 1.0
@export var timer_duration_max: float = 5.0
@export var player: Node2D
@export var go : NodePath
func _ready():
    timer.wait_time = randf_range(timer_duration_min, timer_duration_max)
    timer.start()
    # Set initial state when spawned
    set_state(PlaygroundState.STATE_LOSE)
    # Find Player node and connect to its screen_touched signal
    if player:
        player.connect("screen_touched", Callable(self, "_on_player_screen_touched"))

# Helper to set state and emit signal
func set_state(new_state, emit: bool = true):
    state = new_state
    if emit:
        emit_signal("state_changed", state)

func _on_player_screen_touched():
    if state == PlaygroundState.STATE_LOSE:
        set_state(PlaygroundState.STATE_LOSE)
    elif state == PlaygroundState.STATE_WIN:
        set_state(PlaygroundState.STATE_WIN)

func _on_timer_timeout() -> void:
    # Set state to win, but do NOT emit signal
    set_state(PlaygroundState.STATE_WIN, false)
    get_node(go).visible = true
