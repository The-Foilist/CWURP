extends Node


# Measurement unit conversions
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

enum MovementTypes {
	Ground		= 0,
	Water		= 1,
	Air			= 3,
	Submerged	= 4,
	Interior	= 5
}
enum Terrains {
	Water	= 0,
	Sand	= 1,
	Grass	= 2,
	Forest	= 3,
	Dirt	= 4,
	Paved	= 5,
	Rock	= 6,
	Ice		= 7
}

var game_scene: PackedScene
var player_slot: int
var session: Session
var local_controller: LocalController
var scenario: Scenario
var world: World


func vec_to_br(vec: Vector2) -> Vector2:
	return Vector2(fposmod(rad_to_deg(atan(vec.x / -vec.y)), 360), vec.length())


func br_to_vec(br: Vector2) -> Vector2:
	var b = deg_to_rad(br.x)
	return br.y * Vector2(sin(b),-cos(b))
