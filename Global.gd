extends Node


const DISTANCE_CONVERSION = {
	"m": 1.0,
	"nm": 1852,
	"mi": 1609.34,
	"km": 1000,
	"ft": 0.3048,
	"yd": 0.9144,
}

const SPEED_CONVERSION = {
	"m/s": 1.0,
	"kt": 0.514444,
	"mph": 0.44704,
	"kph": 0.277778,
	"fps": 0.3048,
	"fpm": 0.00508,
	"m/m": 0.0166667,
}

const MASS_CONVERSION = {
	"kg": 1.0,
	"lb": 0.453592,
	"tons": 1016.05,
	"t": 1000,
}

const VOLUME_CONVERSION = {
	"L": 1.0,
	"gal": 3.78541,
}

var session: Session
var local_controller: LocalController
var game: Game
var game_scene: PackedScene
var player_slot: int = 1


func bearing_to(origin: Vector2, target: Vector2) -> float:
	return fposmod(rad_to_deg(origin.angle_to_point(target)) + 90, 360)


func seconds_to_time_string(seconds: float) -> String:
	var s = int(seconds) % 60
	var m = int(floor(seconds/60)) % 60
	var h = int(floor(seconds/3600))
	return "%d:%02d:%02d" % [h,m,s]
