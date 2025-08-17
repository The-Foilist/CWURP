class_name LocationMarker
extends Marker

var player: Player
var display_name: String = 'Marker'


func _ready() -> void:
	$PanelContainer/VBoxContainer/Name.text = display_name
	$PanelContainer/VBoxContainer/Time.text = Global.session.game.current_time


func _process(delta: float) -> void:
	super(delta)
	global_rotation = Global.session.local_controller.cam.global_rotation
	$PanelContainer.scale = Vector2(PlayerSettings.text_scale/PlayerSettings.marker_scale, PlayerSettings.text_scale/PlayerSettings.marker_scale)
	$PanelContainer.visible = (player.selection == self)


func _on_remove_button_pressed():
	player.markers.erase(self)
	Global.session.message_handler.send(null, player, 'map', 'Removed %s.' % Global.session.message_handler.wrap_name(self))
	if player.selection == self:
		player.selection = null
	queue_free()
