extends Spatial

func _ready():
	$RoundProgressBar.set_color(Color.aquamarine)
	$RoundProgressBar.set_border(.03)
	$RoundProgressBar.progress = 0
	cycle()
	
func cycle():
	$ProgressTween.interpolate_property($RoundProgressBar, "progress", 0 , 1, 5)
	$ProgressTween.start()
	yield($ProgressTween,"tween_all_completed")
	GameInfo.set_faith(GameInfo.faith_amount+GameInfo.faith_count)
	cycle()
	
