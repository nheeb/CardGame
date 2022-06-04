extends Karte

const TG = preload("res://Objects/TrainingGround.tscn")
const FIGHTER = preload("res://Units/Fighter.tscn")

func play_effect():

	var new_TG = TG.instance()
	get_tree().current_scene.add_child(new_TG)
	new_TG.translation = GameInfo.get_mouse_pos("ground")
	new_TG.translation.y = 0
	GameInfo.holz_count -= 20
	GameInfo.iron_count -= 10

func is_play_valid() -> bool:
	return GameInfo.holz_count >= 20 and GameInfo.iron_count >= 10

func burn_effect():
	var new_fighter = FIGHTER.instance()
	get_tree().current_scene.add_child(new_fighter)
	new_fighter.translation = GameInfo.get_mouse_layer("ground").get_global_layer_mouse_position()
	new_fighter.translation.y = 0
