class_name Session
extends Node


func _init() -> void:
	Global.session = self
	var scenario = Global.scenario_scene.instantiate()
	Global.scenario = scenario
	Global.world = scenario.world


func _ready() -> void:
	add_child(Global.scenario)


# Quit back to main menu
func end() -> void:
	Global.scenario_scene = null
	Global.world = null
	Global.scenario = null
	Global.local_controller = null
	Global.session = null
	get_tree().change_scene_to_file("res://source/ui/menu/MainMenu.tscn")
