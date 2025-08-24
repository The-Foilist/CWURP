extends Command


func start(_kwargs: Dictionary):
	actor.switch_behavior(null)
	actor.rudder.set_target(0)
	actor.powerplant.set_target(actor.speed_to_setting(actor.speed))
	var message = "Maintaining present course and speed."
	Global.session.message_handler.send(actor, Global.local_controller.player, 'ack', message)
