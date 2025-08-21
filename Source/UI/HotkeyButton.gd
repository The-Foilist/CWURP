class_name HotkeyButton
extends Button


@export var command: CommandData
@export var actor: Actor

func _ready() -> void:
	if $TextureRect:
		$TextureRect.texture = command.icon
	for event in InputMap.action_get_events(command.input_action):
		if event is InputEventKey:
			if $Label:
				$Label.text = event.as_text_physical_keycode()
				return
			text = event.as_text_physical_keycode()
			return


func _unhandled_input(event) -> void:
	if !visible:
		return
	if event.is_action(command.input_action):
		toggle_mode = event.pressed
		button_pressed = event.pressed
		if event.pressed:
			_pressed()


func _pressed() -> void:
	var new_command = load(command.script_path).new(command, actor)
	if command is TargetedCommandData:
		Global.session.local_controller.targeting = new_command
	new_command.start({})
