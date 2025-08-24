class_name UnitMarker
extends Marker


@export var unit: Unit
@export var scale_threshold: float

var snap_on_unit: bool = true


func _ready() -> void:
	if !unit:
		if !(get_parent() is Unit):
			queue_free()
			return
		unit = get_parent()
	$SelectionArea.connected_object = unit
	$Sprite2D.self_modulate = unit.owning_player.color
	Global.session.connect("session_start", _on_session_start)
	unit.died.connect(_on_unit_died)


func _on_session_start() -> void:
	get_parent().remove_child(self)
	Global.game.map_ui_layer.add_child(self)


func _on_unit_died() -> void:
	get_parent().remove_child(self)
	queue_free()


func _physics_process(delta: float) -> void:
	if snap_on_unit:
		rotation = unit.rotation
		global_position = unit.global_position
	
	visible = not(global_scale.x < scale_threshold)
	$SelectionArea.input_pickable = visible
