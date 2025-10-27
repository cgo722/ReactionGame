extends Node2D
@export var playground: Node2D
@export var enemy_timer: Timer
@export var scene_timer: Timer

func _on_enemy_timer_timeout() -> void:
	if playground:
		playground.state = playground.PlaygroundState.STATE_AFTER



func _on_scene_timer_timeout() -> void:
	enemy_timer.start()
