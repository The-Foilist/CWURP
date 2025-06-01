class_name LocalController
extends Node

@onready var session := get_parent()
var player: Player
var cam: LocalCamera
var game: Game

var mouse_coords: Vector2 = Vector2(0,0)
var hovered_object: Node2D
var mouse_intersect_params: PhysicsPointQueryParameters2D
var targeting: Command
var marker_number: int = 1


func get_object_under_mouse() -> Node2D:
	if !cam:
		return
	mouse_coords = cam.get_global_mouse_position()
	mouse_intersect_params.position = mouse_coords
	var result = cam.get_world_2d().direct_space_state.intersect_point(mouse_intersect_params)
	if result:
		if result[0].collider is SelectionArea:
			return result[0].collider.connected_object
	return null


func switch_player(idx: int) -> void:
	disconnect('player.selection_updated', $UI/HSplitContainer/SideBar/VBoxContainer/TabContainer/Units._on_unit_selected)
	disconnect('player.selection_updated', $UI/HSplitContainer/SideBar/VBoxContainer/TabContainer/Selection._on_unit_selected)
	
	player = session.players[idx]
	
	player.selection_updated.connect($UI/HSplitContainer/SideBar/VBoxContainer/TabContainer/Units._on_unit_selected)
	player.selection_updated.connect($UI/HSplitContainer/SideBar/VBoxContainer/TabContainer/Selection._on_unit_selected)
	
	$UI/HSplitContainer/VSplitContainer/BottomBar/VBoxContainer/Messages.update()
	$UI/HSplitContainer/SideBar/VBoxContainer/TabContainer/Units.update()
	$UI/HSplitContainer/VSplitContainer/BottomBar/VBoxContainer/HBoxContainer/MessageTypeFilter.setup()
	$UI/HSplitContainer/VSplitContainer/BottomBar/VBoxContainer/HBoxContainer/PlayerFilter.setup()
	$UI/HSplitContainer/SideBar/VBoxContainer/TabContainer/Selection._on_unit_selected(player.selection)


func target_command(command: Command):
	if targeting:
		targeting.cancel()
	targeting = command


func _ready() -> void:
	mouse_intersect_params = PhysicsPointQueryParameters2D.new()
	mouse_intersect_params.collide_with_areas = true
	mouse_intersect_params.collision_mask = 1


func _process(delta) -> void:
	hovered_object = get_object_under_mouse()
	if targeting:
		targeting.process(delta)
	# Update mouse cursor
	if cam.dragging:
		Input.set_default_cursor_shape(Input.CURSOR_DRAG)
	elif targeting:
		Input.set_default_cursor_shape(targeting.cursor)
	elif hovered_object:
		Input.set_default_cursor_shape(Input.CURSOR_POINTING_HAND)
	else:
		Input.set_default_cursor_shape(Input.CURSOR_ARROW)


func _unhandled_input(event) -> void:
	if targeting:
		if event.is_action_pressed('confirm_target'):
			targeting.confirm(cam.get_global_mouse_position())
		elif event.is_action_released('confirm_target'):
			targeting.release(cam.get_global_mouse_position())
		if event.is_action_pressed('cancel_target'):
			targeting.cancel()
	if event.is_action_pressed('deselect'):
		print('yo')
		player.select(null)


func _on_messages_meta_clicked(meta):
	var obj = get_node(meta)
	if obj is Unit:
		player.select(obj)
