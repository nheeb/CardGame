extends Spatial

const LJ = preload("res://Units/Lumberjack.tscn")

func _physics_process(delta):
	if Input.is_action_just_pressed("create_new_card"):
		var new_obj = LJ.instance()
		get_tree().current_scene.add_child(new_obj)
		new_obj.translation = GameInfo.mouse_position
		new_obj.translation.y = 0
	var camera = $Camera
	var from = camera.project_ray_origin(get_viewport().get_mouse_position())
	var to = camera.project_ray_normal(get_viewport().get_mouse_position())
	var cursorPos = Plane(Vector3.UP, .2).intersects_ray(from, to)
	GameInfo.mouse_position = cursorPos

func _ready():
	GameInfo.ui = $UI
