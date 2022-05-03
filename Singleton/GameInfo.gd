extends Spatial

#var mouse_position : Vector3
func is_mouse_on_hand():
	#print(get_viewport().get_mouse_position())
	return get_viewport().get_mouse_position()[1] > get_viewport().size.y * .69

var mouse_layers := {}
func get_mouse_layer(layer_name: String) -> MouseDetectionLayer:
	return mouse_layers[layer_name]

func get_mouse_pos(layer_name: String) -> Vector3:
	return get_mouse_layer(layer_name).get_global_layer_mouse_position()


func _ready():
	randomize()

var objectDictionary := {}
#objectDictionary["trees"] = [tree1 , tree2 ,tree3]
#var treeListe := []
#var enemyListe := []

var holz_count : int = 0 setget set_holz
var holz_amount : int = 10
var ui : UI
var main_cam : MainCam

func set_holz(number):
	holz_count = number 
	ui.set_wood_label(holz_count)

var card_pool := ["Lumberjack", "Tree", "Fighter", "Mine"]

func get_random_card_name_from_pool():
	return card_pool[randi() % card_pool.size()]
