class_name HotkeyButton
extends Button


@export var action: String
@export var texture: Texture2D


func _ready() -> void:
	if $TextureRect:
		$TextureRect.texture = self.texture
	for event in InputMap.action_get_events(action):
		if event is InputEventKey:
			if $Label:
				$Label.text = event.as_text_physical_keycode()
				return
			text = event.as_text_physical_keycode()
			return


func _unhandled_input(event) -> void:
	if !visible:
		return
	if event.is_action(action):
		toggle_mode = event.pressed
		button_pressed = event.pressed
		if event.pressed:
			_pressed()
