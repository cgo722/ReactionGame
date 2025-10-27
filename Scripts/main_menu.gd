extends Control

# Signal to request game state change
signal request_playing_state

func _on_button_pressed() -> void:
	# Emit signal to request game state change to PLAYING
	emit_signal("request_playing_state")
