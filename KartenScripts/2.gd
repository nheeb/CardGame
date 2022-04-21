extends Karte
const TREE = preload("res://Objects/Tree.tscn")

func _init():
	card_type = 2

func play_effect():
	#print("Confederacy")
	var new_baum = TREE.instance()
	get_tree().current_scene.add_child(new_baum)
	new_baum.translation = GameInfo.mouse_position
	new_baum.translation.y = 0
	GameInfo.holz_count -= 10

func is_play_valid() -> bool:
	return GameInfo.holz_count >= 10
