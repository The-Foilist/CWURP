class_name MoverAirplane2
extends Mover

@export var taxi_mover: MoverTaxi

var engine_thrust: float
var wing_area: float
var lift_coef: float
var c_d_0: float
var c_d_i: float
var aoa_max: float
var pitch_rate: float = 0.331613
var roll_rate: float = 1.22173

var normal_climb_angle: float = deg_to_rad(5)
var normal_bank_angle: float = deg_to_rad(45)

var true_airspeed: float
var velocity: Vector3
var facing: Basis
var pitch_angle: float
var roll_angle: float
var angle_of_attack: float
var track_heading: float
var vertical_speed: float

var power_setting: float
var target_speed: float
var target_heading: float
var target_altitude: float


func _ready() -> void:
	super()
	wing_area = unit.statblock.wing_area
	engine_thrust = unit.statblock.engine_thrust
	lift_coef = unit.statblock.lift_coef
	c_d_0 = unit.statblock.zero_lift_drag_coef
	c_d_i = unit.statblock.induced_drag_coef
	aoa_max = deg_to_rad(unit.statblock.max_angle_of_attack)
	inspector = load("res://source/ui/game/inspectors/InspectorAirplane.tscn")


func angle_diff_proj(a: Vector3, b: Vector3, n: Vector3) -> float:
	n = n.normalized()
	return a.slide(n).signed_angle_to(b.slide(n), n)


func pitch(amt: float) -> void:
	facing = facing.rotated(facing.x, amt)


func roll(amt: float) -> void:
	facing = facing.rotated(-facing.z, amt)


func yaw(amt: float) -> void:
	facing = facing.rotated(facing.y, amt)


func start(vel: Vector2, pitch: float) -> void:
	print(pitch)
	facing = Basis.IDENTITY
	facing = facing.rotated(Vector3.DOWN, unit.global_rotation)
	facing = facing.rotated(facing.x, pitch)
	velocity = Vector3(vel.x, 0, vel.y)
	true_airspeed = velocity.length()
	angle_of_attack = pitch
	target_heading = fposmod(unit.global_rotation_degrees, 360)
	target_altitude = 1000
	power_setting = 1


func linear_forces() -> Vector3:
	var vel = velocity
	
	# Gravity pulls you down
	var weight = Vector3.DOWN * World.GRAVITY
	
	# Engine pulls you forward
	var thrust = -facing.z * engine_thrust * power_setting * pos_data['air_density'] / unit.mass
	
	# Lift pulls you up
	var lift_dir = facing.y.slide(vel.normalized()).normalized()
	angle_of_attack = angle_diff_proj(lift_dir, facing.y, facing.x)
	var cl = max(0, lift_coef * rad_to_deg(angle_of_attack))
	var lift = lift_dir * cl * vel.length_squared() * pos_data['air_density'] * wing_area * 0.5 / unit.mass
	
	# Drag pushes you backwards
	var drag = vel * (c_d_0 + c_d_i * cl**2) * vel.length() * pos_data['air_density'] * wing_area * 0.5 / unit.mass
	
	return weight + thrust + lift - drag


func move(delta: float) -> void:
	facing = facing.orthonormalized()
	
	velocity += linear_forces() * delta
	true_airspeed = velocity.length()
	vertical_speed = velocity.y
	
	unit.height += vertical_speed * delta
	if unit.height < max(0, pos_data['height']):
		unit.kill()
		return
	
	# Set roll in response to target heading and current heading
	var roll_amt = deg_to_rad(fposmod(target_heading - unit.global_rotation_degrees + 180, 360) - 180)
	roll_amt = clamp(roll_amt, -normal_bank_angle - roll_angle, normal_bank_angle - roll_angle)
	roll_amt = clamp(roll_amt, -roll_rate * delta, roll_rate * delta)
	roll(roll_amt)
	
	# Set pitch in response to target current altitude, target altitude, and current velocity
	var vel_angle_target = clamp(asin((target_altitude - unit.height) / (true_airspeed)), -normal_climb_angle, normal_climb_angle)
	var vel_angle_current = asin(vertical_speed / true_airspeed)
	var pitch_amt = (vel_angle_target - vel_angle_current) / cos(roll_angle)
	pitch_amt = clamp(pitch_amt, -pitch_rate * delta, pitch_rate * delta)
	pitch_amt = clamp(pitch_amt, -aoa_max - angle_of_attack, aoa_max - angle_of_attack)
	pitch(pitch_amt)
	
	# Keep yaw aligned with velocity component at all times
	yaw(angle_diff_proj(-facing.z, velocity, facing.y))
	
	unit.global_rotation = angle_diff_proj(-facing.z, Vector3.FORWARD, Vector3.UP)
	pitch_angle = angle_diff_proj(-facing.z, -facing.z.slide(Vector3.UP), -facing.x.slide(Vector3.UP))
	roll_angle = angle_diff_proj(Vector3.UP, facing.y, -facing.z)
	
	var ground_vel = Vector2(velocity.x, velocity.z) + pos_data['wind']
	unit.translate(ground_vel * delta)
	unit.speed = ground_vel.length()
	track_heading = fposmod(rad_to_deg(Vector2(0,-1).angle_to(ground_vel)), 360)
