extends Spatial



func _physics_process(delta):
	var camera = $Camera
	var from = camera.project_ray_origin(get_viewport().get_mouse_position())
	var to = camera.project_ray_normal(get_viewport().get_mouse_position())
	var cursorPos = Plane(Vector3.UP, .2).intersects_ray(from, to)
	GameInfo.mouse_position = cursorPos

