extends Spatial

var last_pos: Vector3

func _physics_process(delta):
	var mouse := GameInfo.get_mouse_pos("ground")
	mouse.y = 1
	if last_pos != global_transform.origin:
		last_pos = global_transform.origin
	global_transform.origin = mouse
	print($Log.get_transformed_aabb().size)
	var vel = last_pos.direction_to(global_transform.origin)
	vel.x = 1.0 - abs(vel.x)
	vel.y = 1.0 - abs(vel.y)
	vel.z = 1.0 - abs(vel.z)
	print(vel)
	print($Log.get_transformed_aabb().size.dot(vel))
	print("!")
