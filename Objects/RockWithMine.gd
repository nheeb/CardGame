extends Spatial

func _ready():
	$MineModel.set_build_state("none")


func set_build_state(x):
	$MineModel.set_build_state(x)
