extends Spatial
class_name Karte

var card_type := 0

func _ready():
	if card_type == 0:
		change_type(randi() % 4 + 1)

func _on_Area_input_event(camera, event, position, normal, shape_idx):
	if event is InputEventMouseButton:
		dragMode = event.pressed
		if event.pressed == false:
			if is_play_valid():
				play_effect()
			else:
				return_to_hand()

var dragMode = false

func _input(event):
	if event is InputEventMouseButton:
		if event.pressed == false:
			dragMode = false

func drag():
	#global_transform.origin = GameInfo.mouse_position
	global_transform.origin = lerp(global_transform.origin, GameInfo.mouse_position, .5)

func _physics_process(delta):
	if dragMode:
		drag()

func is_play_valid() -> bool: #Override
	return false

func play_effect(): #Override
	pass

func return_to_hand():
	pass

func change_type(card_type: int):
	$KartModel.card_type = card_type
	set_script_by_number(card_type)

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
