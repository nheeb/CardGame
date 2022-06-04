extends Karte

const LUMBERJACK = preload("res://Units/Fighter.tscn")

func play_effect():
	var new_fighter = LUMBERJACK.instance()
	get_tree().current_scene.add_child(new_fighter)
	new_fighter.translation = GameInfo.get_mouse_layer("ground").get_global_layer_mouse_position()
	new_fighter.translation.y = 0

func burn_effect():
	GameInfo.set_faith(GameInfo.faith_count + 1)
