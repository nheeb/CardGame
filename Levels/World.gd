extends Spatial

const CARD = preload("res://Objects/Karte.tscn")

func _physics_process(delta):
	if Input.is_action_just_pressed("create_new_card"):
		var new_card = CARD.instance()
		get_tree().current_scene.add_child(new_card)
		new_card.translation = GameInfo.mouse_position
	var camera = $Camera
	var from = camera.project_ray_origin(get_viewport().get_mouse_position())
	var to = camera.project_ray_normal(get_viewport().get_mouse_position())
	var cursorPos = Plane(Vector3.UP, .2).intersects_ray(from, to)
	GameInfo.mouse_position = cursorPos
