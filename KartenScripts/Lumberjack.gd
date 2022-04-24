extends Karte

const LUMBERJACK = preload("res://Units/Lumberjack.tscn")

func play_effect():
	var new_lj = LUMBERJACK.instance()
	get_tree().current_scene.add_child(new_lj)
	new_lj.translation = GameInfo.mouse_position
	new_lj.translation.y = 0
