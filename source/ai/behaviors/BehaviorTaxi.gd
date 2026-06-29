extends Behavior


var unit: Unit
var mover: MoverTaxi
var engine: AircraftEngine

var target_point: Vector2


func _init(in_actor: Actor, params: Dictionary) -> void:
	super(in_actor, params)
	self.unit = actor.unit
	if not unit.active_mover is MoverTaxi:
		end()
		return
	self.mover = unit.active_mover
	self.engine = mover.engine
	
	if 'target' in params:
		if params['target'] is Node2D:
			self.target_point = params['target'].global_position
		elif params['target'] is Vector2:
			self.target_point = params['target']
		elif mover.runway:
			self.target_point = mover.runway.touchdown_point.global_position
		else:
			end()
			return
	else:
		end()
		return


func _to_string() -> String:
	if queued_for_deleteion:
		return ''
	return "Taxiing to %s" % Global.world.get_coords_at_position(target_point)


func end() -> void:
	super()


func process(delta) -> void:
	if queued_for_deleteion:
		return
	
	var br = Global.vec_to_br(target_point - unit.global_position)
	mover.heading_target = br.x
	actor.target_heading = br.x
	
	if br.y <= 1:
		mover.set_brake(1)
		end()
		return
	
	if mover.ground_speed > mover.taxi_speed:
		mover.set_brake((mover.ground_speed - mover.taxi_speed)/(mover.deceleration * delta))
		engine.set_thrust(0)
	elif mover.ground_speed < mover.taxi_speed:
		mover.brake = 0
		engine.set_thrust((mover.taxi_speed - mover.ground_speed) * unit.mass / (mover.accel_coef * delta))
	else:
		mover.brake = 0
		engine.set_thrust(0)
