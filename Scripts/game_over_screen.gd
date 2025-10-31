extends Control

func _on_main_menu_pressed() -> void:
	EventBus.emit_signal("return_to_menu")


func _on_retry_pressed() -> void:
	EventBus.emit_signal("retry")
