extends Spatial

const GOBLIN = preload("res://Units/Goblin.tscn")

#func _physics_process(delta):
#	var camera = $MainCam
#	var from = camera.project_ray_origin(get_viewport().get_mouse_position())
#	var to = camera.project_ray_normal(get_viewport().get_mouse_position())
#	var cursorPos = Plane(Vector3.UP, .2).intersects_ray(from, to)
#	GameInfo.mouse_position = cursorPos

func _ready():
	GameInfo.ui = $UI
	GameInfo.main_cam = $MainCam

func _on_Timer_timeout():
	var new_goblin = GOBLIN.instance()
	get_tree().current_scene.add_child(new_goblin)
	new_goblin.translation = Vector3(3*randf(),0,3*randf())

