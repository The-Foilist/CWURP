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
		out_str += " from " + mover.runway.unit.name
	return out_str


func process(_delta) -> void:
	if queued_for_deleteion:
		return
	if not mover.active:
		end()
		return
	#if mover.runway:
		#mover.heading_target = mover.runway.heading
	if fposmod(mover.heading_target - unit.global_rotation_degrees + 180, 360) - 180 < 1:
		engine.set_power(1)
	else:
		engine.set_power(engine.idle_setting)
