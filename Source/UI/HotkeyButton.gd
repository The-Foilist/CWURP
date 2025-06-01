class_name HotkeyButton
extends Button


@export var action: String


func _unhandled_input(event) -> void:
	if event.is_action(action):
		toggle_mode = event.pressed
		button_pressed = event.pressed
		if event.pressed:
			_pressed()
