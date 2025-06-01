class_name Marker
extends Sprite2D

var player: Player


func _ready() -> void:
	$PanelContainer/VBoxContainer/Name.text = name
	$PanelContainer/VBoxContainer/Time.text = Global.session.game.current_time


func _process(delta: float) -> void:
	var zoom = Global.session.local_controller.cam.zoom
	global_scale = Vector2(PlayerSettings.marker_scale/zoom.x, PlayerSettings.marker_scale/zoom.y)
	global_rotation = Global.session.local_controller.cam.global_rotation
	$PanelContainer.scale = Vector2(PlayerSettings.text_scale/PlayerSettings.marker_scale, PlayerSettings.text_scale/PlayerSettings.marker_scale)
	$PanelContainer.visible = (player.selection == self)


func _on_remove_button_pressed():
	player.markers.erase(self)
	Global.session.message_handler.send(null, player, 'map', 'Removed %s.' % Global.session.message_handler.wrap_name(self))
	if player.selection == self:
		player.selection = null
	queue_free()
