extends Behavior


var unit: Unit
var mover: MoverTaxi
var engine: AircraftEngine


func _init(in_actor: Actor, params: Dictionary):
	super(in_actor, params)
	self.unit = actor.unit
	if not unit.active_mover is MoverTaxi:
		end()
		return
	self.mover = unit.active_mover
	self.engine = mover.engine


func _to_string() -> String:
	var out_str = "Taking off"
	if mover.runway:
		out_str += " from %s %s" % [mover.runway.unit.name, mover.runway.name]
	return out_str


func process(_delta) -> void:
	if queued_for_deleteion:
		return
	if not mover.active:
		actor.target_altitude = 1000
		actor.target_heading = mover.heading_target
		actor.target_speed = INF
		end()
		return
	if mover.runway:
		mover.heading_target = mover.runway.heading
	if abs(fposmod(mover.heading_target - unit.global_rotation_degrees, 360)) < 0.1:
		mover.set_brake(0)
		engine.set_power(1)
	else:
		mover.set_brake(1)
		engine.set_power(0)
