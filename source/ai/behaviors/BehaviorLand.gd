extends Behavior


var unit: Unit
var mover: MoverFlying
var engine: AircraftEngine

var target: Runway
var glide_slope: float = 0.05235988

func _init(in_actor: Actor, params: Dictionary) -> void:
	super(in_actor, params)
	self.unit = actor.unit
	if not unit.active_mover is MoverFlying:
		end()
		return
	self.mover = unit.active_mover
	self.engine = mover.engine
	
	if 'target' in params:
		for child in params['target'].get_children():
			if child is FlightController:
				self.target = child.active_runway
				mover.runway = self.target
				break
	
	mover.flaps = true

func _to_string() -> String:
	if queued_for_deleteion:
		return ""
	return "Landing at %s %s" % [target.unit.name, target.name]


func end() -> void:
	mover.flaps = false
	super()


func process(delta) -> void:
	if queued_for_deleteion:
		return
	
	if not mover.active:
		end()
		actor.add_order(load("res://assets/data/orders/Taxi.tres"), 1, {'target': target.end_point})
		return
	
	var height_diff = unit.height - target.height
	var vec = (target.touchdown_point.global_position - unit.global_position) + target.velocity
	var br = Global.vec_to_br(vec)
	var pitch_target = -(2 * atan(height_diff / br.y) - glide_slope)
	var thrust_target = mover.pos_data['air_density'] * mover.drag_coef * (mover.landing_speed)**2
	
	engine.set_thrust(thrust_target + unit.mass * 9.8 * sin(pitch_target + glide_slope))
	mover.pitch_target = pitch_target
	mover.heading_target = br.x
