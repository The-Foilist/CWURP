class_name Session
extends Node

@onready var local_controller := $LocalController
@onready var message_handler := $MessageHandler

var game: Game
var players: Array[Player]


signal session_start


func setup() -> bool:
	Global.local_controller = local_controller
	game = Global.game_scene.instantiate()
	Global.game = game
	local_controller.game = game
	$LocalController/UI/HSplitContainer/VSplitContainer/Overlay/SubViewportContainer/SubViewport.add_child(game)
	
	for player in game.players.get_children():
		players.append(player)
	
	var cam = LocalCamera.new()
	game.world.add_child(cam)
	local_controller.cam = cam
	local_controller.setup_player(Global.player_slot)
	cam.position = local_controller.player.start_location.position
	cam.zoom_level = local_controller.player.start_location.starting_zoom_level
	cam.zoom = cam.zoom * pow(0.8, cam.zoom_level)
	
	local_controller.process_mode = Node.PROCESS_MODE_INHERIT
	session_start.connect(game._on_sesion_start)
	game.game_start.connect($LocalController/UI/HSplitContainer/SideBar/VBoxContainer/TabContainer/Map/Planner.create_markers)
	return true


func _ready() -> void:
	Global.session = self
	setup()
	emit_signal("session_start")
