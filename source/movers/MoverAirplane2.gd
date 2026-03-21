class_name MoverAirplane2
extends Mover

@export var taxi_mover: MoverTaxi

var engine_thrust: float
var wing_area: float
var lift_coef: float
var c_d_0: float
var c_d_i: float
var aoa_max: float

var true_airspeed: float
var velocity: Vector3
var facing: Basis
var pitch_angle: float
var angle_of_attack: float
var track_heading: float
var vertical_speed: float

var power_setting: float
var target_speed: float
var target_heading: float
var target_pitch: float


func _ready() -> void:
	super()
	wing_area = unit.statblock.wing_area
	engine_thrust = unit.statblock.engine_thrust
	lift_coef = unit.statblock.lift_coef
	c_d_0 = unit.statblock.zero_lift_drag_coef
	c_d_i = unit.statblock.induced_drag_coef
	aoa_max = unit.statblock.max_angle_of_attack
	inspector = load("res://source/ui/game/inspectors/InspectorAirplane.tscn")


func start(vel: Vector2) -> void:
	facing = Basis(Vector3(unit.transform.x.x, 0, unit.transform.x.y), Vector3.UP, Vector3(unit.transform.y.x, 0, unit.transform.y.y))
	facing = facing.rotated(facing.x, deg_to_rad(5))
	velocity = Vector3(vel.x, 0, vel.y)
	angle_of_attack = 5
	power_setting = 1


func linear_forces() -> Vector3:
	var air_density = world.get_air_density_at_height(unit.height)
	var vel = velocity
	
	# Gravity pulls you down
	var weight = Vector3.DOWN * World.GRAVITY
	
	# Engine pulls you forward
	var thrust = -facing.z * engine_thrust * power_setting / unit.mass
	
	# Lift pulls you up
	var lift_dir = facing.y.slide(vel.normalized()).normalized()
	angle_of_attack = rad_to_deg(lift_dir.signed_angle_to(facing.y, facing.x))
	var cl = max(0, lift_coef * angle_of_attack)
	var lift = lift_dir * cl * vel.length_squared() * air_density * wing_area * 0.5 / unit.mass
	
	# Drag pushes you backwards
	var drag = vel * (c_d_0 + c_d_i * cl**2) * vel.length() * air_density * wing_area * 0.5 / unit.mass
	
	return weight + thrust + lift - drag


func move(delta: float) -> void:
	facing = facing.orthonormalized()
	
	velocity += linear_forces() * delta
	true_airspeed = velocity.length()
	
	# Prevent stall
	if angle_of_attack > aoa_max:
		facing = facing.rotated(facing.x, deg_to_rad(angle_of_attack - aoa_max))
	
	unit.height += velocity.y * delta
	if unit.height < pos_data['height']:
		unit.kill()
		return
	
	unit.global_rotation = Vector3.FORWARD.signed_angle_to(-facing.z, Vector3.DOWN)
	track_heading = rad_to_deg(velocity.signed_angle_to(Vector3.FORWARD, Vector3.UP))
	pitch_angle = 90 - rad_to_deg(Vector3.UP.angle_to(-facing.z))
	vertical_speed = velocity.y
	
	var ground_vel = Vector2(velocity.x, velocity.z) + pos_data['wind']
	unit.translate(ground_vel * delta)
	unit.speed = ground_vel.length()
