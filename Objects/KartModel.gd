extends Spatial

export var card_name := "" setget set_card_name

func set_card_name(cn):
	card_name = cn
	set_texture_by_name(cn)

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

func get_texture_path_by_name(name: String) -> String:
	var all_files = list_files_in_directory("res://KartenTexturen/")
	for filename in all_files:
		if filename == name + ".png":
			return "res://KartenTexturen/" + filename
	return "ERROR"

func set_texture_by_name(name: String) -> void:
	var path = get_texture_path_by_name(name)
	if path == "ERROR":
		return
	var texture = load(path)
	$"card size".get("material/0").albedo_texture = texture
