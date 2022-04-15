extends Spatial

const CARD = preload("res://Objects/Karte.tscn")

func _physics_process(delta):
	if Input.is_action_just_pressed("create_new_card"):
		var new_card = CARD.instance()
		get_tree().current_scene.add_child(new_card)
		new_card.translation = mouse_position
#		new_card.translation.y = .726
#		new_card.translation.x = rand_range(-.5,.5)
#		new_card.translation.z = rand_range(-.5,.5)

var mouse_position := Vector3.ZERO

func _on_MouseLayer_input_event(camera, event, position, normal, shape_idx):
	if event is InputEventMouseMotion:
		mouse_position = position
