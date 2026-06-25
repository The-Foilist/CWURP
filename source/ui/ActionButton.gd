class_name ActionButton
extends Button

@export var stats: DataButton


func update():
	
	for child in get_children():
		remove_child(child)
		child.queue_free()
		
	if stats.texture:
		var new_texture = TextureRect.new()
		new_texture.texture = stats.texture
		new_texture.set_anchors_preset(Control.PRESET_CENTER)
		new_texture.custom_minimum_size = Vector2(64, 64)
		new_texture.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		new_texture.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		add_child(new_texture)
	
	for event in InputMap.action_get_events(stats.input_action):
		if event is InputEventKey:
			var new_label = Label.new()
			new_label.text = event.as_text()
			new_label.custom_minimum_size = Vector2(80, 0)
			new_label.clip_text = true
			new_label.vertical_alignment = VERTICAL_ALIGNMENT_BOTTOM
			add_child(new_label)
			break


func _ready():
	update()


func _unhandled_input(event):
	if event.is_action(stats.input_action):
		button_pressed = event.is_pressed()
