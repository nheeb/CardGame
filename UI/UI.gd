extends Control

class_name UI

func _ready():
	$NotifyBorder.visible = false

func set_wood_label(wood):
	$WoodLabel.text = "Wood: "+str(wood)
	
func set_iron_label(iron):
	$IronLabel.text = "Iron: "+str(iron)
	
func set_faith_label(faith):
	$FaithLabel.text = "Faith: "+str(faith)

func _physics_process(delta):
	notify_about_enemy(Vector3.ZERO)

func notify_about_enemy(pos: Vector3) -> void:
	var camera := GameInfo.main_cam as MainCam
	var y_zero_plane := Plane(Vector3.ZERO, Vector3.ZERO + Vector3.FORWARD, Vector3.ZERO + Vector3.RIGHT)
	var from := camera.global_transform.origin
	var to_center := camera.project_ray_normal(get_viewport().size * .5)
	var to_upscreen := camera.project_ray_normal(Vector2(get_viewport().size.x * .5, 0.0))
	
	var y_zero_upscreen := y_zero_plane.intersects_ray(from, to_upscreen)
	var camera_center := y_zero_plane.intersects_ray(from, to_center)
	GameInfo.test_thing.global_transform.origin = camera_center
	var view_plane := y_zero_plane#Plane(to_center, to_center.dot(camera_center))
	
	var target_projected := get_cam_projected_to_plane(view_plane, pos)
	GameInfo.test_thing_2.global_transform.origin = target_projected
	var dist_vector := target_projected - camera_center
	
	var upscreen_projected := get_cam_projected_to_plane(view_plane, y_zero_upscreen)
	var upscreen_dist_vector := upscreen_projected - camera_center
	
	var angle := dist_vector.angle_to(upscreen_dist_vector) * sign(dist_vector.x - upscreen_dist_vector.x)
	var distance := dist_vector.length()
	
	print("Angle:" + str(angle) + ", Distance: " + str(distance))
	$Skull/Arrow.rotation = angle

	var x_notify_middle : float = ($NotifyBorder.anchor_left + $NotifyBorder.anchor_right) / 2.0
	var y_notify_middle : float = ($NotifyBorder.anchor_top + $NotifyBorder.anchor_bottom) / 2.0
	var notify_middle := Vector2(x_notify_middle, y_notify_middle)
	var notify_dist_half := Vector2($NotifyBorder.anchor_right-$NotifyBorder.anchor_left, $NotifyBorder.anchor_bottom-$NotifyBorder.anchor_top) * .5
	var slope := tan(angle + PI *.5)
	var vertical_point_y = notify_dist_half.x * slope * (1 if angle > 0 else -1) + notify_middle.y
	var vertical_point_x = $NotifyBorder.anchor_right if angle > 0 else $NotifyBorder.anchor_left
	var horizontal_point_x = notify_dist_half.y * (1.0/slope) * (1 if abs(angle) > PI * .5 else -1) + notify_middle.x
	var horizontal_point_y = $NotifyBorder.anchor_bottom if abs(angle) > PI * .5 else $NotifyBorder.anchor_top
	
	var rect_point : Vector2
	
#	if vertical_point_y < $NotifyBorder.anchor_bottom and vertical_point_y > $NotifyBorder.anchor_top:
#		rect_point = Vector2(vertical_point_x, vertical_point_y)
#	else:
#		rect_point = Vector2(horizontal_point_x, horizontal_point_y)
	
	if horizontal_point_x < $NotifyBorder.anchor_left or horizontal_point_x > $NotifyBorder.anchor_right:
		rect_point = Vector2(vertical_point_x, vertical_point_y)
	else:
		rect_point = Vector2(horizontal_point_x, horizontal_point_y)
	
	#rect_point = Vector2(vertical_point_x, vertical_point_y)
	#rect_point = Vector2(horizontal_point_x, horizontal_point_y)
	$Skull.anchor_left = rect_point.x
	$Skull.anchor_top = rect_point.y

func get_cam_projected_to_plane(plane: Plane, pos: Vector3) -> Vector3:
#	var camera := GameInfo.main_cam as MainCam
#	var from := camera.global_transform.origin
#	var to := camera.global_transform.origin.direction_to(pos)
#	return plane.intersects_ray(from, to)
	return plane.project(pos)
