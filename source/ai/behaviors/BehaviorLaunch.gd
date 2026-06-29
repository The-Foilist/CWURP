extends Behavior

var interval: float = 0
var planes: Array[Unit]
var next_plane: Unit
var timer: float = 0


func _init(in_actor: Actor, params: Dictionary) -> void:
	super(in_actor, params)
	
	for child in actor.active_runway.get_children():
		if child is Unit:
			planes.append(child)
	
	if 'interval' in params:
		self.interval = params['interval']


func _to_string() -> String:
	if queued_for_deleteion:
		return ''
	return 'Launching aircraft'


func end() -> void:
	super()


func process(delta) -> void:
	if queued_for_deleteion:
		return
	
	if planes.size() == 0:
		if next_plane.active_mover is MoverFlying:
			end()
		return
	
	if interval > 0:
		if timer == 0:
			next_plane = planes.pop_front()
			actor.comms.send(next_plane.comms, "takeoff")
		timer += delta
		if timer >= interval:
			timer = 0
	
	if !next_plane or next_plane.active_mover is MoverFlying:
		next_plane = planes.pop_front()
		actor.comms.send(next_plane.comms, "takeoff")
