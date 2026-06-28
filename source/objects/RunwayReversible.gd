class_name RunwayReversible
extends Runway


@export var reversed: bool = false
@export var reverse_touchdown_point: Node2D
@export var reverse_end_point: Node2D


func _ready() -> void:
	heading = start_heading
	if reversed:
		reverse()


func reverse() -> void:
	reversed = !reversed
	var num = int(name.trim_prefix('Runway '))
	var td_temp = touchdown_point
	var end_temp = end_point
	touchdown_point = reverse_touchdown_point
	end_point = reverse_end_point
	reverse_touchdown_point = td_temp
	reverse_end_point = end_temp
	heading = fposmod(heading + 180, 360)
	print(heading)
	name = 'Runway ' + str(posmod(18 + num, 36))
