extends Spatial

func _ready():
	GameInfo.ui = $UI
	GameInfo.main_cam = $MainCam
	GameInfo.test_thing = $TestThing
	GameInfo.test_thing_2 = $TestThing2
	GameInfo.center_cube = $CenterCube
