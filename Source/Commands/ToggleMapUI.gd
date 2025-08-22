extends Command


func start(_kwargs: Dictionary):
	Global.local_controller.show_map_ui = !Global.local_controller.show_map_ui
