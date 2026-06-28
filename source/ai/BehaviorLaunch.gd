extends Behavior

var interval: float
var planes: Array[Unit]
var next_plane: Unit
#var timer: float = 0


func _init(in_actor: Actor, params: Dictionary):
	super(in_actor, params)
	
	for child in actor.active_runway.get_children():
		if child is Unit:
			planes.append(child)
	
	if 'interval' in params:
		self.interval = params['heading']
	else:
		interval = 10


func _to_string():
	if queued_for_deleteion:
		return ''
	return 'Launching aircraft'


func end() -> void:
	super()


func process(_delta):
	if queued_for_deleteion:
		return
	
	if planes.size() == 0:
		if next_plane.active_mover is MoverAirplane:
			end()
		return
	
	if !next_plane or next_plane.active_mover is MoverAirplane:
		next_plane = planes.pop_front()
		actor.comms.send(next_plane.comms, "takeoff")
