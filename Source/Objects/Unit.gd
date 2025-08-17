class_name Unit
extends StaticBody2D

@export var owning_player: Player
@export var statblock: Statblock
@onready var display_name = statblock.display_name
@export var mover: Mover
