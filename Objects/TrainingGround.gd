extends Spatial

const FIGHTER = preload("res://Units/Fighter.tscn")

func _ready():
	$RoundProgressBar.progress = 0
	$RoundProgressBar.set_color(Color.brown)
	generate_fighter()
	
func generate_fighter():
	$ProgressTween.interpolate_property($RoundProgressBar, "progress", 0, 1, 5)
	$ProgressTween.start()
	yield($ProgressTween, "tween_all_completed")
	
	var new_fighter = FIGHTER.instance()
	get_tree().current_scene.add_child(new_fighter)
	new_fighter.global_transform.origin = self.global_transform.origin

	
	generate_fighter()


	
