extends Spatial

func _ready():
	$MineModel.set_build_state("none")
	yield(get_tree().create_timer(5),"timeout")
	$MineModel.set_build_state("hover")
	yield(get_tree().create_timer(5),"timeout")
	$MineModel.set_build_state("build")
