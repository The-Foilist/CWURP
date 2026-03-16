class_name LocalController
extends CanvasLayer


var player: Player
var cam: LocalCamera

var mouse_intersect_params: PhysicsPointQueryParameters2D

var mouse_coords: Vector2
var hovered_object: Unit


func _init() -> void:
	Global.local_controller = self
	player = Global.scenario.players[Global.player_slot]
	mouse_intersect_params = PhysicsPointQueryParameters2D.new()
	mouse_intersect_params.collide_with_areas = true
	mouse_intersect_params.collision_mask = 1


func _ready() -> void:
	cam = $HSplitContainer/VSplitContainer/Overlay/SubViewportContainer/SubViewport/LocalCamera
	player.selection_updated.connect($HSplitContainer/SideBar/MarginContainer/VBoxContainer/TabContainer/Selection._on_object_selected)


func sort_by_z(a, b) -> bool:
	if a.collider.z_index > b.collider.z_index:
		return true
	return false


func get_object_under_mouse():
	mouse_coords = cam.get_global_mouse_position()
	mouse_intersect_params.position = mouse_coords
	var result = cam.get_world_2d().direct_space_state.intersect_point(mouse_intersect_params)
	if result:
		result.sort_custom(sort_by_z)
		if result[0].collider is Unit:
			return result[0].collider
		elif result[0].collider is Marker and result[0].collider.input_pickable:
			return result[0].collider.unit
		elif result[0].collider is UnitComponent:
			return result[0].collider.unit


func _process(_delta) -> void:
	hovered_object = get_object_under_mouse()
	if cam.dragging:
		Input.set_default_cursor_shape(Input.CURSOR_DRAG)
	elif hovered_object:
		Input.set_default_cursor_shape(Input.CURSOR_POINTING_HAND)
	else:
		Input.set_default_cursor_shape(Input.CURSOR_ARROW)


func _unhandled_input(event) -> void:
	if event.is_action_pressed("select"):
		if hovered_object:
			player.select(hovered_object)
	if event.is_action_pressed("deselect"):
		player.select(null)
