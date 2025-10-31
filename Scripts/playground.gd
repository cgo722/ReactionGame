extends Node2D

enum PlaygroundState {
	STATE_WIN,
	STATE_LOSE
}

var state

@export var timer: Timer
@export var timer_duration_min: float = 1.0
@export var timer_duration_max: float = 5.0
@export var player: NodePath
@export var go : NodePath
@export var enemy_resource: Resource
@export var round_label: RichTextLabel

var current_round: int

# Parry / combat configuration
@export var parry_timer: Timer

# Runtime state
var current_attacker: String = "" # "player" or "enemy"
var parry_active: bool = false

func _ready():
	if round_label:
		round_label.text = "Round: " + str(current_round + 1)
	timer.wait_time = randf_range(timer_duration_min, timer_duration_max)
	timer.start()

	EventBus.player_input.connect(_on_event_bus_player_input)

	if parry_timer:
		if not parry_timer.is_connected("timeout", Callable(self, "_on_parry_timer_timeout")):
			parry_timer.connect("timeout", Callable(self, "_on_parry_timer_timeout"))

	var enemy = get_node("Enemy(base)")
	if enemy and enemy_resource:
		var enemy_timer = enemy.get_node("EnemyTimer")
		if enemy_timer:
			enemy_timer.wait_time = randf_range(enemy_resource.min_wait_time, enemy_resource.max_wait_time)

func _exit_tree():
	EventBus.player_input.disconnect(_on_event_bus_player_input)

# Helper to set state and emit signal
func set_state(new_state, emit: bool = true):
	state = new_state
	if emit:
		if new_state == PlaygroundState.STATE_WIN:
			EventBus.emit_signal("round_won")
		elif new_state == PlaygroundState.STATE_LOSE:
			EventBus.emit_signal("round_lost")

func _on_event_bus_player_input():
	if go and has_node(go) and get_node(go).visible:
		player_attack()
	else:
		# False start
		set_state(PlaygroundState.STATE_LOSE, true)

# Player initiates an attack (called from input)
func player_attack() -> void:
	# If enemy is currently the attacker and a parry window is active, this acts as a parry
	if current_attacker == "enemy" and parry_active:
		parry_success("player")
		return

	# Otherwise start an attack as player
	current_attacker = "player"
	start_parry_window()

# Enemy initiates an attack (called from enemy script)
func enemy_attack() -> void:
	if current_attacker == "player" and parry_active:
		parry_success("enemy")
		return

	current_attacker = "enemy"
	start_parry_window()

# Called when a parry is successful by `by_who` ("player" or "enemy")
func parry_success(by_who: String) -> void:
	# Stop current parry window and switch attacker to successful parrier
	if parry_timer and parry_timer.is_stopped() == false:
		parry_timer.stop()
	parry_active = false

	current_attacker = by_who
	# Immediately start a new parry window giving the other side a chance to parry back
	start_parry_window()

func start_parry_window() -> void:
	parry_active = true
	if parry_timer:
		parry_timer.start()
	# Optionally show attack indicator
	if go and has_node(go):
		get_node(go).visible = true

func _on_timer_timeout() -> void:
	if go and has_node(go):
		get_node(go).visible = true

func _on_parry_timer_timeout():
	# Parry window expired -> defender failed to parry, apply damage
	parry_active = false
	var defender = "player" if current_attacker == "enemy" else "enemy"

	if go and has_node(go):
		get_node(go).visible = false

	# One and done: defender loses instantly
	if defender == "player":
		set_state(PlaygroundState.STATE_LOSE, true)
		return
	else:
		set_state(PlaygroundState.STATE_WIN, true)
		return

	# No further parry windows, combat ends
