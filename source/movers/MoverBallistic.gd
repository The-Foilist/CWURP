class_name MoverBallistic
extends Mover

var drag_coef_quadratic: float = 0
var drag_coef_linear: float = 0

var velocity: Vector2
var air_speed: float
var angle: float
var downrange: float
var flight_time: float


func move(delta: float) -> void:
	var pos_data = world.get_data_at_position(unit.global_position)
	
	velocity.y -= 9.81 * delta
	
	air_speed = velocity.length()
	angle = atan(velocity.y/velocity.x)
	
	var drag = drag_coef_linear + drag_coef_quadratic * air_speed
	velocity -= velocity * drag * delta
	
	var out_vel = velocity.x * unit.global_transform.x + pos_data['wind']
	unit.global_translate(out_vel * delta)
	unit.height += velocity.y * delta
	
	if unit.height < max(0, pos_data['height']):
		unit.kill()
		return
	
	downrange += out_vel * delta
	flight_time += delta
