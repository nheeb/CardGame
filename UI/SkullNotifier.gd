extends TextureRect
class_name SkullNotifier

export var fade_wait_duration := 2.5
export var fade_out_duration := 1.5

var target : Spatial

func _ready():
	self.modulate = Color.white
	self.visible = true
	start_fade_out()

func _physics_process(delta):
	if is_instance_valid(target):
		update_position()

func update_position():
	GameInfo.ui.update_notifier_position(self, target.global_transform.origin)

func start_fade_out():
	yield(get_tree().create_timer(fade_wait_duration), "timeout")
	$FadeOutTween.interpolate_property(self, "modulate:a", 1.0 , 0.0, fade_out_duration)
	$FadeOutTween.start()

func _on_FadeOutTween_tween_all_completed():
	queue_free()

var arrow_rotation : float setget set_arrow_rotation

func set_arrow_rotation(r:float) -> void:
	arrow_rotation = r
	$Control/Arrow.rotation = r
