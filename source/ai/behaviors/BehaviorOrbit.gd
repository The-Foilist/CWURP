extends Behavior


var unit: Unit
var mover: MoverFlying
var engine: AircraftEngine

var target: Node2D
var target_distance: float
var left: bool
var target_altitude: float
var target_speed: float


func _init(in_actor: Actor, params: Dictionary) -> void:
	super(in_actor, params)
	self.unit = actor.unit
	if not unit.active_mover is MoverFlying:
		end()
		return
	self.mover = unit.active_mover
	self.engine = mover.engine
	
	if not 'target' in params:
		end()
		return
	self.target = params['target']
	
	if 'range' in params:
		self.target_distance = params['range']
	else:
		self.target_distance = 0
	
	if 'speed' in params:
		self.target_speed = params['speed']
		actor.target_speed = self.target_speed
	else:
		target_speed = actor.target_speed
	
	if 'altitude' in params:
		self.target_altitude = params['altitude']
		actor.target_altitude = self.target_altitude
	else:
		target_altitude = actor.target_altitude
	
	if 'direction' in params:
		if params['direction'] == 'left':
			self.left = true
			return
		elif params['direction'] == 'right':
			self.left = false
			return
	var target_br = Global.vec_to_br(target.global_position - unit.global_position)
	var heading_target = target_br.x
	var offset = rad_to_deg(asin(target_distance/max(target_distance, target_br.y)))
	var left_diff = abs(fposmod(heading_target + offset - unit.global_rotation_degrees + 180, 360) - 180)
	var right_diff = abs(fposmod(heading_target - offset - unit.global_rotation_degrees + 180, 360) - 180)
	self.left = left_diff >= right_diff


func _to_string() -> String:
	if queued_for_deleteion:
		return ''
	var speed: String
	if target_speed == INF:
		speed = 'maximum speed'
	else:
		speed = 'speed %.0f ' % (target_speed / Global.UNIT_CONVERSION[PlayerSettings.aircraft_speed_units]) + PlayerSettings.aircraft_speed_units
	return "Orbiting %s at range %.2f %s, %s, and altitude %.0f %s" % [
		target.name,
		target_distance / Global.UNIT_CONVERSION[PlayerSettings.distance_units],
		PlayerSettings.distance_units,
		speed,
		target_altitude / Global.UNIT_CONVERSION[PlayerSettings.altitude_units],
		PlayerSettings.altitude_units
	]


func end() -> void:
	super()
	if not target:
		return
	if not target is Unit:
		target.get_parent().remove_child(target)
		target.queue_free()
	


func process(delta) -> void:
	if queued_for_deleteion:
		return
	var thrust_target = clamp(mover.pos_data['air_density'] * mover.drag_coef * target_speed**2, 0, engine.thrust_max * engine.active_engines)
	var alt_diff = (target_altitude - unit.height)/(100 * mover.air_speed * delta)
	var pitch_target = asin(clamp(alt_diff, -thrust_target / (unit.mass * 9.8), 2 * thrust_target / (3 * unit.mass * 9.8)))	
	var target_br = Global.vec_to_br(target.global_position - unit.global_position)
	var heading_target = target_br.x
	if target.br.y < target_distance:
		heading_target += 180
	else:
		var offset = rad_to_deg(asin(target_distance/target_br.y))
		if left:
			heading_target += offset
		else:
			heading_target -= offset
	heading_target = fposmod(heading_target, 360)
	
	actor.target_heading = heading_target
	engine.set_thrust(thrust_target + unit.mass * 9.8 * sin(pitch_target))
	mover.pitch_target = pitch_target
	mover.heading_target = heading_target
