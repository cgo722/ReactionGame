extends Node2D

# Signal to notify when the screen is touched
signal screen_touched

func _input(event):
    if event is InputEventScreenTouch and event.pressed:
        emit_signal("screen_touched")
