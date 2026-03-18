class_name Marker
extends Area2D


@export var unit: Unit
@export var scale_threshold: float


func _ready() -> void:
	unit.died.connect(_on_unit_died)
	$Sprite2D.self_modulate = unit.owning_player.color
	get_parent().remove_child.call_deferred(self)
	Global.world.ui_layer.add_child.call_deferred(self)


func _on_unit_died(unit) -> void:
	get_parent().remove_child(self)
	queue_free()


func _process(_delta) -> void:
	var zoom = Global.local_controller.cam.zoom
	global_scale = Vector2(PlayerSettings.marker_scale/zoom.x, PlayerSettings.marker_scale/zoom.y)
	
	global_rotation = unit.global_rotation
	global_position = unit.global_position
	
	visible = not(global_scale.x < scale_threshold)
	input_pickable = visible
