extends Node2D
@export var playground: Node2D
@export var enemy_timer: Timer
@export var scene_timer: Timer
@export var enemy_resource: Array[Resource] = []
var current_enemy_resource: EnemyResource


func _ready():
	current_enemy_resource = enemy_resource[randi() % enemy_resource.size()]
	enemy_timer.wait_time = randf_range(current_enemy_resource.min_wait_time, current_enemy_resource.max_wait_time)
	print("Selected Enemy Resource with wait time range: ", enemy_timer.wait_time)
	pass
func _on_enemy_timer_timeout() -> void:
	if playground:
		playground.state = playground.PlaygroundState.STATE_LOSE



func _on_scene_timer_timeout() -> void:
	enemy_timer.start()
