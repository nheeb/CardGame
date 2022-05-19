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

const SKULL_NOTIFIER = preload("res://UI/SkullNotifier.tscn")
func notify_about_enemy(target: Spatial) -> void:
	var notifier = SKULL_NOTIFIER.instance()
	notifier.target = target
	self.add_child(notifier)
	update_notifier_position(notifier, target.global_transform.origin)


func update_notifier_position(target_notifier, pos: Vector3) -> void:
	var x_notify_middle : float = ($NotifyBorder.anchor_left + $NotifyBorder.anchor_right) / 2.0
	var y_notify_middle : float = ($NotifyBorder.anchor_top + $NotifyBorder.anchor_bottom) / 2.0
	var notify_middle := Vector2(x_notify_middle, y_notify_middle)
	var unproj_pos = GameInfo.main_cam.unproject_position(pos)
	unproj_pos.x /= get_viewport().size.x
	unproj_pos.y /= get_viewport().size.y
	var flip_because_behind = GameInfo.main_cam.is_position_behind(pos) and unproj_pos.y < 0
	var angle = -(unproj_pos - notify_middle).angle_to(Vector2.DOWN if flip_because_behind else Vector2.UP)

	var notify_dist_half := Vector2($NotifyBorder.anchor_right-$NotifyBorder.anchor_left, $NotifyBorder.anchor_bottom-$NotifyBorder.anchor_top) * .5
	var slope := tan(angle + PI *.5)
	var vertical_point_y = notify_dist_half.x * slope * (1 if angle > 0 else -1) + notify_middle.y
	var vertical_point_x = $NotifyBorder.anchor_right if angle > 0 else $NotifyBorder.anchor_left
	var horizontal_point_x = notify_dist_half.y * (1.0/slope) * (1 if abs(angle) > PI * .5 else -1) + notify_middle.x
	var horizontal_point_y = $NotifyBorder.anchor_bottom if abs(angle) > PI * .5 else $NotifyBorder.anchor_top

	var rect_point : Vector2

	if horizontal_point_x < $NotifyBorder.anchor_left or horizontal_point_x > $NotifyBorder.anchor_right:
		rect_point = Vector2(vertical_point_x, vertical_point_y)
	else:
		rect_point = Vector2(horizontal_point_x, horizontal_point_y)

	target_notifier.arrow_rotation = angle

	var offset_x = target_notifier.texture.get_width() * .5 / get_viewport().size.x
	var offset_y = target_notifier.texture.get_height() * .5 / get_viewport().size.y

	target_notifier.anchor_left = rect_point.x - offset_x
	target_notifier.anchor_top = rect_point.y - offset_y
	
	var is_pos_centered = unproj_pos.x >= $NotifyBorder.anchor_left and unproj_pos.x <= $NotifyBorder.anchor_right \
		and unproj_pos.y >= $NotifyBorder.anchor_top and unproj_pos.y <= $NotifyBorder.anchor_bottom
	
	target_notifier.visible = not is_pos_centered
