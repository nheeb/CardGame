tool
extends Spatial

export var progress := 0.0 setget set_progress

func set_progress(x):
	progress = clamp(x, 0.0, 1.0)
	visible = progress != 0.0
	$MeshInstance.get("material/0").set("shader_param/completeness", progress)
