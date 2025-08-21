extends Command


func start(_kwargs: Dictionary):
	Global.session.local_controller.show_map_ui = !Global.session.local_controller.show_map_ui
