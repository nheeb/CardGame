extends Karte

const HOA = preload("res://Projectiles/HailOfArrows.tscn")

func play_effect():
	var new_hoa = HOA.instance()
	get_tree().current_scene.add_child(new_hoa)
	new_hoa.transform.origin = GameInfo.get_mouse_pos("ground")
	GameInfo.faith_count -= 2

func is_play_valid() -> bool:
	return GameInfo.faith_count >= 2

func burn_effect():
	GameInfo.set_holz(GameInfo.holz_count + 1)
