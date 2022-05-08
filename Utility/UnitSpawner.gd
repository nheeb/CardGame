extends Spatial

const GOBLIN = preload("res://Units/Goblin.tscn")

var target_unit_resource : Resource

var x_range := 1.0
var z_range := 1.0
export var spawn_time := 10.0
export var spawn_on_ready := false
export var preview_visible := true

func _ready():
	target_unit_resource = GOBLIN
	
	x_range = self.scale.x
	z_range = self.scale.z
	
	$Preview.visible = preview_visible
	$Timer.wait_time = spawn_time
	if spawn_on_ready: _on_Timer_timeout()
	$Timer.start()
	

func _on_Timer_timeout():
	var new_unit = target_unit_resource.instance()
	get_tree().current_scene.add_child(new_unit)
	var random_position_offsets := Vector3((1.0 - 2.0 * randf()) * x_range, 0.0, (1.0 - 2.0 * randf()) * z_range)
	new_unit.global_transform.origin = self.global_transform.origin + random_position_offsets

