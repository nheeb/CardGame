tool
extends Spatial

export var card_type : int = 0 setget set_card_type

func set_card_type(ct):
	card_type = ct
	set_texture_by_number(ct)

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

func get_texture_path_by_number(number: int) -> String:
	var all_files = list_files_in_directory("res://KartenTexturen/")
	for filename in all_files:
		if filename.begins_with(str(number)):
			return "res://KartenTexturen/" + filename
	return "ERROR"

func get_texture_by_number(number: int):
	var path = get_texture_path_by_number(number)
	if path == "ERROR":
		return null
	return load(path)

#func _ready():
#	var number :int=  get_parent().karten_stapel[0]
#	set_texture_by_number(number)
	
func set_texture_by_number(number: int):
	var texture = get_texture_by_number(number)
	if texture == null:
		return
	$"card size".get("material/0").albedo_texture = texture
