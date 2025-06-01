class_name Session
extends Node

@onready var local_controller := $LocalController
@onready var message_handler := $MessageHandler

var game: Game
var players: Array[Player]


signal game_start()


func setup() -> bool:
	game = Global.game_scene.instantiate()
	add_child(game)
	local_controller.game = game
	
	for player in game.players.get_children():
		players.append(player)
	
	var cam = LocalCamera.new()
	game.world.add_child(cam)
	local_controller.cam = cam
	local_controller.switch_player(Global.player_slot)
	cam.position = local_controller.player.start_location.position
	
	for player in players:
		$MessageHandler.send(null, player, 'welcome', "Welcome to Carter's Weird Unnamed RTS Project.")
		$MessageHandler.send(null, player, 'welcome', "Session started. You are %s. Good luck!" % $MessageHandler.wrap_name(player))
	
	local_controller.process_mode = Node.PROCESS_MODE_INHERIT
	return true


func _ready() -> void:
	Global.session = self
	setup()
	emit_signal("game_start")
