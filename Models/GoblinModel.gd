extends Spatial

func transition_to(animation_name : String, duration : float) -> void:
	var target_blend
	match(animation_name):
		"idle":
			target_blend = 0
		"walk":
			target_blend = 1
	$TransitionTween.interpolate_property($AnimationTree, "parameters/BlendWalk/blend_amount", $AnimationTree.get("parameters/BlendWalk/blend_amount"), target_blend, duration)
	$TransitionTween.start()
