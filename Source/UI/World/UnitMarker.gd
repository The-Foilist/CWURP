class_name UnitMarker
extends Marker


@onready var unit: Unit = get_parent()
@export var scale_threshold: float


func _ready() -> void:
	self_modulate = unit.owning_player.color


func _process(delta: float) -> void:
	super(delta)
	visible = not(global_scale.x < scale_threshold)
	$SelectionArea.input_pickable = not(global_scale.x < scale_threshold)
