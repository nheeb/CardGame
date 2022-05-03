extends Spatial

export var list_name := "XXX"

func _ready():
	if not GameInfo.objectDictionary.has(list_name):
		GameInfo.objectDictionary[list_name] = []
	(GameInfo.objectDictionary[list_name] as Array).append(get_parent())
