class_name Unit
extends StaticBody2D

@export var display_name: String
@export var owning_player: Player
@export var statblock: Statblock
@onready var unit_name = statblock.unit_name
@export var mover: Mover

@export var speed: float
