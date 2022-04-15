extends Spatial
class_name Karte

func _on_Area_mouse_entered():
	scale = Vector3(1.1, 1.1, 1.1)
	$KartModel.card_type = 0

func _on_Area_mouse_exited():
	scale = Vector3.ONE
	$KartModel.card_type = 1

func _on_Area_input_event(camera, event, position, normal, shape_idx):
	if event is InputEventMouseButton:
		print(position)
		queue_free()
