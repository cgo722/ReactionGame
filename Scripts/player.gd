extends Node2D

func _input(event):
    if event is InputEventScreenTouch and event.pressed:
        EventBus.emit_signal("player_input")
