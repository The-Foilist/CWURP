class_name Session
extends Node


func _ready() -> void:
	var scenario = Global.scenario_scene.instantiate()
	Global.local_controller = $LocalController
	Global.session = self
	Global.scenario = scenario
	Global.world = scenario.world
	$LocalController._on_start(scenario)
	add_child(Global.scenario)


# Quit back to main menu
func end() -> void:
	Global.scenario_scene = null
	Global.world = null
	Global.scenario = null
	Global.local_controller = null
	Global.session = null
	get_tree().change_scene_to_file("res://source/ui/menu/MainMenu.tscn")
