class_name InGameTimer
extends Timer


func _ready() -> void:
	process_callback = TIMER_PROCESS_PHYSICS
	Global.game.time_scale_changed.connect(scale_time_remaining)
	Global.game.paused.connect(toggle_pause)


func toggle_pause(on) -> void:
	paused = on


func scale_time_remaining(amt: float) -> void:
	wait_time *= amt
	var scaled_time = time_left * amt
	if is_stopped():
		return
	stop()
	start(scaled_time)
