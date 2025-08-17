class_name Marker
extends Sprite2D


func _process(_delta: float) -> void:
	var zoom = Global.session.local_controller.cam.zoom
	global_scale = Vector2(PlayerSettings.marker_scale/zoom.x, PlayerSettings.marker_scale/zoom.y)
