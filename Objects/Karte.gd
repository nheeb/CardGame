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
		dragMode = event.pressed
		#print(position)
		#queue_free()

var dragMode = false

func _input(event):
	if event is InputEventMouseButton:
		if event.pressed == false:
			dragMode = false

func drag():
	translation = get_parent().mouse_position
			
func _physics_process(delta):
	if dragMode:
		drag()
		
