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

var drag_clip_position = null

func drag():
	if GameInfo.is_mouse_on_hand():
		global_transform.origin = lerp(global_transform.origin, GameInfo.get_mouse_pos("hand"), .25)
		GameInfo.main_cam.drag_card_between_the_others(global_transform.origin)
	else:
		var ground_pos : Vector3 = GameInfo.get_mouse_pos("ground")
		follow_hand_target_position()
		on_ground_hover(ground_pos)
		
		if drag_clip_position == null or fire_clip:
			test_for_fire_pit(ground_pos)
			
		if drag_clip_position != null:
			GameInfo.main_cam.draw_arrow(drag_clip_position)
		else:
			GameInfo.main_cam.draw_arrow(ground_pos)

var fire_clip : bool = false

func test_for_fire_pit(ground_pos):
	var fire_pit_pos = GameInfo.fire_pit.global_transform.origin
	var distance = ground_pos.distance_to(fire_pit_pos)
	if distance < 3:
		drag_clip_position = fire_pit_pos
		fire_clip = true
		GameInfo.main_cam.set_arrow_color(Color.orange)
	else:
		drag_clip_position = null
		fire_clip = false
		GameInfo.main_cam.set_arrow_color(Color.white)
				
func follow_hand_target_position():
	translation = lerp(translation, hand_target_position, .1)

func _physics_process(delta):
	if dragMode:
		drag()
	else:
		follow_hand_target_position()

func play_action_input():
	GameInfo.main_cam.clear_arrow()
	if GameInfo.is_mouse_on_hand():
		return_to_hand()
		return
		
	if fire_clip:
		GameInfo.main_cam.remove_from_hand(self)
		burn()
			
	else:
		if is_play_valid():
			GameInfo.main_cam.remove_from_hand(self)
			
			play_effect()
			queue_free()
		else:
			return_to_hand()

func burn():
	burn_effect()
	GameInfo.fire_pit.burn_visual()
	queue_free()
	pass

func burn_effect(): # Override
	pass

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
