extends Control

func _on_button_pressed() -> void:
	EventBus.emit_signal("start_game")
