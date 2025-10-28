extends Node2D
@export var playground: Node2D
@export var enemy_timer: NodePath
@export var scene_timer: NodePath
@export var enemy_resource: Array[Resource] = []
var current_enemy_resource: EnemyResource
var enemy_timer_node: Timer

func _ready():
	current_enemy_resource = enemy_resource[randi() % enemy_resource.size()]
	enemy_timer_node = get_node(enemy_timer) as Timer
	enemy_timer_node.wait_time = randf_range(current_enemy_resource.min_wait_time, current_enemy_resource.max_wait_time)
	print("Selected Enemy Resource with wait time range: ", enemy_timer_node.wait_time)
	pass
func _on_enemy_timer_timeout() -> void:
	if playground and playground.has_method("set_state"):
		playground.set_state(playground.PlaygroundState.STATE_LOSE)



func _on_scene_timer_timeout() -> void:
	if enemy_timer_node and enemy_timer_node.is_inside_tree():
		enemy_timer_node.start()
