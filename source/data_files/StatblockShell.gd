class_name StatblockShell
extends StatblockUnit

enum FuseType {
	None = 0,
	Timed,
	Impact,
	Proximity
}

@export_group('Movement')
@export var mass: float
@export var linear_drag_coef: float
@export var quadratic_drag_coef: float

@export_group('Payload')
@export var charge: float
@export var fuse_type: FuseType
@export var fuse_time: float
