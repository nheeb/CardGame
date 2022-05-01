extends Spatial
class_name Karte

var card_name := ""

func _init():
	card_name = str(get_script().get_path()).split("/")[-1].split(".gd")[0]

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
	global_transform.origin = lerp(global_transform.origin, GameInfo.get_mouse_pos("hand" if GameInfo.is_mouse_on_hand() else "ground"), .25)

func follow_hand_pivot():
	translation = lerp(translation, hand_pivot.origin, .15)
	transform.basis.x = lerp(transform.basis.x, hand_pivot.basis.x, .15)
	transform.basis.y = lerp(transform.basis.y, hand_pivot.basis.y, .15)
	transform.basis.z = lerp(transform.basis.z, hand_pivot.basis.z, .15)

func _physics_process(delta):
	if dragMode:
		drag()
	else:
		follow_hand_pivot()

func play_action_input():
	if GameInfo.is_mouse_on_hand():
		return_to_hand()
		return
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

func change_type(_card_name: String):
	$KartModel.card_name = _card_name
	set_script_by_name(_card_name)

func list_files_in_directory(path: String) -> Array:
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

func get_script_path_by_name(name: String) -> String:
	var all_files = list_files_in_directory("res://KartenScripts/")
	for filename in all_files:
		if filename == name + ".gd":
			return "res://KartenScripts/" + filename
	return "ERROR"

func set_script_by_name(name: String) -> void:
	var path = get_script_path_by_name(name)
	if path == "ERROR":
		printerr("Wrong Name to load Card Script")
		return
	var script = load(path)
	set_script(script)

func _on_Area_mouse_entered():
	GameInfo.main_cam.hover_card = self
	GameInfo.main_cam.generate_pivots()


func _on_Area_mouse_exited():
	if GameInfo.main_cam.hover_card == self:
		GameInfo.main_cam.hover_card = null
		GameInfo.main_cam.generate_pivots()
