extends VBoxContainer

var max_seconds: int = 3600
var selected_seconds: float

var marker_list: Array[UnitMarker] = []


func create_markers() -> void:
	for marker in Global.game.map_ui_layer.get_children():
		if marker is UnitMarker:
			if marker.unit.mover:
				if marker.unit.mover is PoweredMover:
					marker_list.append(marker)


func update_markers() -> void:
	if selected_seconds <= 0:
		for marker in marker_list:
			marker.snap_on_unit = true
	else:
		for marker in marker_list:
			marker.snap_on_unit = false
			var tf = marker.unit.mover.get_transform_after_time(selected_seconds)
			marker.position = tf.get_origin()
			marker.rotation = tf.get_rotation()


func _process(delta) -> void:
	if !Global.game.pause:
		selected_seconds = max(0, selected_seconds - delta * Global.game.time_scale)
		$TimeSlider.value -= delta * Global.game.time_scale / max_seconds
	var selected_time = Time.get_datetime_dict_from_unix_time(Global.game.start_timestamp + Global.game.elapsed_time + selected_seconds)
	var offset = " (+%0d:%02d:%02d)" % [int(selected_seconds / 3600), int(selected_seconds / 60) % 60, int(selected_seconds) % 60]
	$TimeReadout.text = "%04d-%02d-%02d %02d:%02d:%02d" % [
		selected_time.year,
		selected_time.month,
		selected_time.day, 
		selected_time.hour,
		selected_time.minute,
		selected_time.second
	] + offset
	update_markers()


func _on_max_time_value_changed(value) -> void:
	var prev_max_seconds = max_seconds
	max_seconds = int(value * 3600)
	$TimeSlider.value = $TimeSlider.value * prev_max_seconds / max_seconds


func _on_time_slider_value_changed(value) -> void:
	selected_seconds = value * max_seconds
