extends Spatial
class_name StateMachine

var state : String setget _change_state
export var starting_state := "idle"
export var refresh_state_on_reset := false

func _ready():
	_change_state(starting_state)

func _physics_process(delta):
	if get_parent().has_method("state_frame"):
		get_parent().call("state_frame", state, delta)

func _change_state(new_state: String) -> void:
	if state == new_state:
		if not refresh_state_on_reset:
			return
	state = new_state
	if get_parent().has_method("state_start"):
		get_parent().call("state_start", state)
