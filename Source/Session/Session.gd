class_name Session
extends Node

@onready var local_controller := $LocalController
@onready var message_handler := $MessageHandler

var game: Game
var players: Array[Player]


signal game_start()


func setup() -> bool:
	game = Global.game_scene.instantiate()
	$LocalController/UI/HSplitContainer/VSplitContainer/Overlay/SubViewportContainer/SubViewport.add_child(game)
	local_controller.game = game
	
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
	return true


func _ready() -> void:
	Global.session = self
	setup()
	emit_signal("game_start")
