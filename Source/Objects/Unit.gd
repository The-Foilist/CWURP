class_name Unit
extends StaticBody2D

@export var display_name: String
@export var owning_player: Player
@export var statblock: UnitData
@onready var unit_name = statblock.unit_name
@export var mover: Mover
@export var group: Group

@export var starting_parameters: Dictionary

var height: float


signal died


func parse_order(sender: Node, order_text: String) -> void:
	if sender != owning_player:
		return
	
	var words = order_text.to_upper().split(' ')
	var i = 0
	while i < words.size():
		match words[i]:
			'COURSE', 'C':
				if words[i+1].is_valid_int():
					var command_data = load("res://Assets/data/commands/SetCourse.tres")
					var command = load("res://Source/Commands/SetCourse.gd").new(command_data, mover)
					command.confirm({'target': words[i+1].to_float()})
					i += 2
			'SPEED', 'S':
				if words[i+1].is_valid_float():
					var speed = words[i+1].to_float() * Global.SPEED_CONVERSION[PlayerSettings.ship_speed_units]
					var command_data = load("res://Assets/data/commands/SetSpeed.tres")
					var command = load("res://Source/Commands/SetSpeed.gd").new(command_data, mover)
					command.start({'target': speed})
					i += 2
				elif words[i+1] == 'MAX':
					var speed = mover.speed_max
					print("If we could, we would be setting speed to " + str(speed))
					i += 2
			'HEAD', 'MOVE', 'APPROACH':
				pass
