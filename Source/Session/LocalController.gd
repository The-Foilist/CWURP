class_name LocalController
extends Node

@onready var session := get_parent()
var player: Player
var cam: LocalCamera
var game: Game

var mouse_coords: Vector2 = Vector2(0,0)
var hovered_object
var mouse_intersect_params: PhysicsPointQueryParameters2D
var targeting: TargetedCommand
var marker_number: int = 1


func sort_by_z(a, b) -> bool:
	if a.collider.z_index > b.collider.z_index:
		return true
	return false


func get_object_under_mouse():
	if !cam:
		return
	mouse_coords = cam.get_global_mouse_position()
	mouse_intersect_params.position = mouse_coords
	var result = cam.get_world_2d().direct_space_state.intersect_point(mouse_intersect_params)
	if result:
		result.sort_custom(sort_by_z)
		if result[0].collider is SelectionArea and result[0].collider.input_pickable:
			return result[0].collider.connected_object
		elif result[0].collider is UnitComponent:
			return result[0].collider.unit
	return cam.get_global_mouse_position()


func setup_player(idx: int) -> void:
	player = session.players[idx]
	
	player.selection_updated.connect($UI/HSplitContainer/SideBar/VBoxContainer/TabContainer/Units._on_object_selected)
	player.selection_updated.connect($UI/HSplitContainer/SideBar/VBoxContainer/TabContainer/Selection._on_object_selected)
	player.selection_updated.connect($UI/HSplitContainer/VSplitContainer/BottomBar/VBoxContainer/MessageInput._on_object_selected)
	
	$UI/HSplitContainer/VSplitContainer/BottomBar/VBoxContainer/Messages.update()
	$UI/HSplitContainer/SideBar/VBoxContainer/TabContainer/Units.update()
	$UI/HSplitContainer/VSplitContainer/BottomBar/VBoxContainer/HBoxContainer2/MessageTypeFilter.setup()
	$UI/HSplitContainer/VSplitContainer/BottomBar/VBoxContainer/HBoxContainer2/PlayerFilter.setup()
	$UI/HSplitContainer/SideBar/VBoxContainer/TabContainer/Selection._on_object_selected(player.selection)
	

func target_command(command: TargetedCommand):
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
	elif hovered_object is Unit:
		Input.set_default_cursor_shape(Input.CURSOR_POINTING_HAND)
	else:
		Input.set_default_cursor_shape(Input.CURSOR_ARROW)


func _input(event) -> void:
	if targeting && event.is_action_pressed("confirm_target_queue"):
		targeting.confirm_queue({'target': hovered_object})
	elif targeting && event.is_action_pressed('confirm_target'):
		targeting.confirm({'target': hovered_object})
	elif targeting && event.is_action_released('confirm_target'):
		if hovered_object:
			targeting.release({'target': hovered_object})
	elif targeting && event.is_action_pressed("cancel_target"):
		targeting.cancel()
	elif event.is_action_pressed("select_group"):
		if hovered_object is Unit:
			if hovered_object.group:
				player.select(hovered_object.group)
			else:
				player.select(hovered_object)
		else:
			player.select(hovered_object)
	elif event.is_action_pressed("select"):
		if hovered_object is Unit:
			player.select(hovered_object)
		elif hovered_object is LocationMarker:
			hovered_object.toggle_panel_visibility()
	elif event.is_action_pressed('deselect'):
		player.select(null)


func _on_messages_meta_clicked(meta):
	if !meta:
		return
	var obj = instance_from_id(int(meta))
	if obj is Unit or obj is Group:
		player.select(obj)
