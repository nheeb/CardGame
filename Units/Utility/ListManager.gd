extends Spatial
class_name ListManager

static func trigger_hp_zero(target):
	if target.has_node("ListManager"):
		target.get_node("ListManager").call("on_parent_hp_zero")
	else:
		print("NoListManager")

export var list_name := "XXX"
export var erase_on_hp_zero := true

func _ready():
	if not GameInfo.objectDictionary.has(list_name):
		GameInfo.objectDictionary[list_name] = []
	(GameInfo.objectDictionary[list_name] as Array).append(get_parent())

func erase_self():
	GameInfo.get_object_list(list_name).erase(get_parent())

func on_parent_hp_zero():
	if erase_on_hp_zero:
		erase_self()
