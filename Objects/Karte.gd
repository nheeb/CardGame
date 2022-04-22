extends Spatial
class_name Karte

var card_type := 0

func _ready():
	if card_type == 0:
		change_type([2, 5][randi()%2])

func _on_Area_input_event(camera, event, position, normal, shape_idx):
	if event is InputEventMouseButton:
		if event.pressed:
			dragMode = true
			GameInfo.main_cam.drag_card = self
			GameInfo.main_cam.generate_pivots()

var dragMode = false
var hand_pivot := Transform()

func _input(event):
	if event is InputEventMouseButton:
		if event.pressed == false:
			if dragMode:
				dragMode = false
				GameInfo.main_cam.drag_card = null
				play_action_input()

func drag():
	global_transform.origin = lerp(global_transform.origin, GameInfo.mouse_position, .25)

func follow_hand_pivot():
	translation = lerp(translation, hand_pivot.origin, .15)
	transform.basis.x = lerp(transform.basis.x, hand_pivot.basis.x, .15)#.slerp(hand_pivot.basis, .15)
	transform.basis.y = lerp(transform.basis.y, hand_pivot.basis.y, .15)
	transform.basis.z = lerp(transform.basis.z, hand_pivot.basis.z, .15)

func _physics_process(delta):
	if dragMode:
		drag()
	else:
		follow_hand_pivot()

func play_action_input():
	if is_play_valid():
		GameInfo.main_cam.remove_from_hand(self)
		play_effect()
		queue_free()
	else:
		return_to_hand()

func is_play_valid() -> bool: #Override
	return true

func play_effect(): #Override
	pass

func return_to_hand():
	GameInfo.main_cam.generate_pivots()

func change_type(_card_type: int):
	$KartModel.card_type = _card_type
	set_script_by_number(_card_type)

func list_files_in_directory(path):
	var files = []
	var dir = Directory.new()
	dir.open(path)
	dir.list_dir_begin()

	while true:
		var file = dir.get_next()
		if file == "":
			break
		elif not file.begins_with("."):
			files.append(file)

	dir.list_dir_end()

	return files

func get_script_path_by_number(number: int) -> String:
	var all_files = list_files_in_directory("res://KartenScripts/")
	for filename in all_files:
		if filename.begins_with(str(number)):
			return "res://KartenScripts/" + filename
	return "ERROR"

func get_script_by_number(number: int):
	var path = get_script_path_by_number(number)
	if path == "ERROR":
		return null
	return load(path)

func set_script_by_number(number: int):
	var script = get_script_by_number(number)
	if script == null:
		return
	set_script(script)


func _on_Area_mouse_entered():
	GameInfo.main_cam.hover_card = self
	GameInfo.main_cam.generate_pivots()


func _on_Area_mouse_exited():
	if GameInfo.main_cam.hover_card == self:
		GameInfo.main_cam.hover_card = null
		GameInfo.main_cam.generate_pivots()
