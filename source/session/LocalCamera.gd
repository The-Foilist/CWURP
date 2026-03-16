class_name LocalCamera
extends Camera2D


var zoom_min: float = -10
var zoom_max: float = 40
var dragging := false
@export var zoom_level: int = 0
var following: Node


func _init() -> void:
	ignore_rotation = false


func _ready() -> void:
	zoom *= pow(0.8, zoom_level)


func _unhandled_input(event: InputEvent) -> void:
	if dragging:
		if event is InputEventMouseMotion:
			var trans_vec = (-event.relative.x / zoom.x) * transform.x + (-event.relative.y / zoom.y) * transform.y
			if PlayerSettings.invert_drag_scroll:
				trans_vec = -trans_vec
			translate(trans_vec)
	if event.is_action("camera_drag"):
		dragging = event.pressed
	if event.is_action_pressed("camera_zoom_in"):
		if zoom_level > zoom_min:
			zoom *= 1.25
			translate((position - get_global_mouse_position()) * -0.25)
			zoom_level -= 1
	if event.is_action_pressed("camera_zoom_out"):
		if zoom_level < zoom_max:
			zoom *= 0.8
			translate((position - get_global_mouse_position()) * 0.2)
			zoom_level += 1


func _process(delta: float) -> void:
	var rot_dir := 0.0
	if Input.is_action_pressed("camera_rotate_left"):
		rot_dir += 1
	if Input.is_action_pressed("camera_rotate_right"):
		rot_dir -= 1
	rotate(rot_dir * PlayerSettings.camera_rotation_speed * delta)
	
	var pan_dir := Vector2(0,0)
	if Input.is_action_pressed("camera_pan_up"):
		pan_dir -= transform.y
	if Input.is_action_pressed("camera_pan_down"):
		pan_dir += transform.y
	if Input.is_action_pressed("camera_pan_left"):
		pan_dir -= transform.x
	if Input.is_action_pressed("camera_pan_right"):
		pan_dir += transform.x
	pan_dir = pan_dir.normalized()
	translate(pan_dir * PlayerSettings.camera_pan_speed * delta / zoom.x)
