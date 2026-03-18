class_name MoverAirplane2
extends Mover

@export var taxi_mover: MoverTaxi

var drag_coef_quadratic: float
var drag_coef_angular: float
var engine_power: float
var turn_rate: float

var power_setting: float

var air_speed: float
var velocity: Vector3
var facing: Basis
var pitch_angle: float
var runway: Unit

@export var target_speed: float
@export var target_heading: float
@export var target_pitch: float


func _ready() -> void:
	super()
	inspector = load("res://source/ui/game/inspectors/InspectorAirplane.tscn")
	


func move(delta: float) -> void:
	facing = facing.orthonormalized()
	
	var air_density = world.get_air_density_at_height(unit.height)
	
	# Gravity pulls you down
	velocity += Vector3(0,1,0) * World.GRAVITY * delta
	
	# Engine provides thrust
	velocity += -facing.z * engine_power * power_setting / unit.mass * delta
	
	# Wings provide lift
	velocity += facing.y * World.GRAVITY * delta
	
	# Drag pulls you backward
	var drag = velocity.length() * (drag_coef_quadratic + sin(velocity.angle_to(-facing.z)) * drag_coef_angular) * air_density
	velocity -= velocity * drag / unit.mass * delta
