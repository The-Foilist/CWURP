extends Command


func start(_kwargs: Dictionary):
	Global.game.map_ui_layer.visible = !Global.game.map_ui_layer.visible
