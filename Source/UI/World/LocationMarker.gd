class_name LocationMarker
extends Marker

@export var display_name: String
var player: Player
var location_label: Label

var dragging: bool

signal removed(marker: LocationMarker)


func _ready() -> void:
	$PanelContainer/VBoxContainer/HBoxContainer/Name.text = display_name
	location_label = $PanelContainer/VBoxContainer/LocationLabel
	location_label.text = "(%.d, %.d)" % [global_position.x, global_position.y]
	$PanelContainer/VBoxContainer/TimeLabel.text = Global.game.current_time


func _process(delta: float) -> void:
	super(delta)
	$SelectionArea.input_pickable = visible
	global_rotation = Global.local_controller.cam.global_rotation
	$PanelContainer.scale = Vector2(PlayerSettings.text_scale/PlayerSettings.marker_scale, PlayerSettings.text_scale/PlayerSettings.marker_scale)


func remove():
	emit_signal("removed", self)
	player.markers.erase(self)
	Global.session.message_handler.send(null, player, 'map', 'Removed %s.' % Global.session.message_handler.wrap_name(self))
	if player.selection == self:
		player.selection = null
	get_parent().remove_child(self)
	queue_free()


func drag_input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			dragging = event.pressed
	if event is InputEventMouseMotion && dragging:
		translate(event.relative / Global.local_controller.cam.zoom)
		location_label.text = "(%.d, %.d)" % [global_position.x, global_position.y]


func _on_selection_area_input_event(viewport, event, shape_idx):
	if event.is_action_pressed("select"):
		$PanelContainer.visible = !$PanelContainer.visible
