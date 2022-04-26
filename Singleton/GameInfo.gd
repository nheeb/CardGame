extends Spatial

var mouse_position : Vector3
func is_mouse_on_hand():
	print(get_viewport().get_mouse_position())
	return get_viewport().get_mouse_position()[1] > 730

func _ready():
	randomize()

var treeListe := []
var enemyListe := []
var unitListe := []

var holz_count : int = 0 setget set_holz
var holz_amount : int = 10
var ui : UI
var main_cam : MainCam

func set_holz(number):
	holz_count = number 
	ui.set_wood_label(holz_count)

var card_pool := ["Lumberjack", "Tree", "Fighter"]

func get_random_card_name_from_pool():
	return card_pool[randi() % card_pool.size()]
