extends Node2D
@export var playground: Node2D
@export var enemy_timer: NodePath
@export var scene_timer: NodePath

var enemy_timer_node: Timer

func _ready():
	enemy_timer_node = get_node(enemy_timer) as Timer

func _on_enemy_timer_timeout() -> void:
	if playground and playground.has_method("enemy_attack"):
		# Let playground handle parry/combat flow
		playground.enemy_attack()
	elif playground and playground.has_method("set_state"):
		# Fallback to older behavior
		playground.set_state(playground.PlaygroundState.STATE_LOSE)

func _on_scene_timer_timeout() -> void:
	if enemy_timer_node and enemy_timer_node.is_inside_tree():
		enemy_timer_node.start()
