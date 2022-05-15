extends Spatial

func _ready():
	$MineModel.set_build_state("none")
	$RoundProgressBar.progress = 0
	$RoundProgressBar.set_color(Color.slategray)


func set_build_state(x):
	$MineModel.set_build_state(x)
	if x == "build": 
		generate_iron()
	
func generate_iron():
	$ProgressTween.interpolate_property($RoundProgressBar, "progress", 0, 1, 10)
	$ProgressTween.start()
	yield($ProgressTween, "tween_all_completed")
	GameInfo.set_iron(GameInfo.iron_count+GameInfo.iron_amount)
	generate_iron()

