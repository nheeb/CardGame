extends Spatial

const CARD = preload("res://Objects/Karte.tscn")

func _physics_process(delta):
	if Input.is_action_just_pressed("create_new_card"):
		var new_card = CARD.instance()
		get_tree().current_scene.add_child(new_card)
		new_card.translation = GameInfo.mouse_position
	var camera = $Camera
	var from = camera.project_ray_origin(get_viewport().get_mouse_position())
	var to = from + camera.project_ray_normal(get_viewport().get_mouse_position()) * 100
	var cursorPos = Plane(Vector3.UP, .1).intersects_ray(from, to)
	GameInfo.mouse_position = cursorPos
#		new_card.translation.y = .726
#		new_card.translation.x = rand_range(-.5,.5)
#		new_card.translation.z = rand_range(-.5,.5)

#var mouse_position := Vector3.ZERO
var karten_stapel := [0,1]
