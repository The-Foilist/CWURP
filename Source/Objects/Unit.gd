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
