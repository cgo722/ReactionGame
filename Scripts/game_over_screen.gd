extends Control

# Signal to request state change to main menu
signal request_main_menu
# Signal to request state change to playing
signal request_retry


func _on_main_menu_pressed() -> void:
	emit_signal("request_main_menu")


func _on_retry_pressed() -> void:
	emit_signal("request_retry")


