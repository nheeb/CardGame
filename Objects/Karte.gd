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
			GameInfo.main_cam.generate_target_positions()

var dragMode = false
var hand_target_position := Vector3()

func _input(event):
	if event is InputEventMouseButton:
		if event.pressed == false:
			if dragMode:
				dragMode = false
				GameInfo.main_cam.drag_card = null
				play_action_input()

func drag():
	if GameInfo.is_mouse_on_hand():
		global_transform.origin = lerp(global_transform.origin, GameInfo.get_mouse_pos("hand"), .25)
		GameInfo.main_cam.drag_card_between_the_others(global_transform.origin)
	else:
		follow_hand_target_position()

func follow_hand_target_position():
	translation = lerp(translation, hand_target_position, .1)

func _physics_process(delta):
	if dragMode:
		drag()
		if not GameInfo.is_mouse_on_hand():
			on_ground_hover(GameInfo.get_mouse_pos("ground"))
	else:
		follow_hand_target_position()

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

func is_play_valid() -> bool: # Override
	return true

func play_effect(): # Override
	pass

func on_ground_hover(position: Vector3): # Override
	pass

func on_return_to_hand(): # Override
	pass

func return_to_hand():
	on_return_to_hand()
	GameInfo.main_cam.return_to_hand(self)
	#GameInfo.main_cam.generate_target_positions()

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
	GameInfo.main_cam.generate_target_positions()


func _on_Area_mouse_exited():
	if GameInfo.main_cam.hover_card == self:
		GameInfo.main_cam.hover_card = null
		GameInfo.main_cam.generate_target_positions()
