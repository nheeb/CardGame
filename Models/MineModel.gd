extends Spatial

export(String, "none", "build", "hover") var build_state := "none" setget set_build_state

const HOVER_MAT = preload("res://MaterialShader/HoverMaterial.tres")

var all_mesh_instances := []

func add_to_all_mesh_instances(c):
	if c is MeshInstance: 
		all_mesh_instances.append(c)
	if c.get_child_count() != 0: 
		for cc in c.get_children(): 
			add_to_all_mesh_instances(cc)

func _ready():
	add_to_all_mesh_instances(self)

func set_build_state(x):
	build_state = x
	match(build_state):
		"none":
			$Big.visible = true
			for c in all_mesh_instances:
				if c != $Big: c.visible = false
				c.material_override = null
		"build":
			for c in all_mesh_instances:
				c.visible = true
				c.material_override = null
		"hover":
			$Big.visible = true
			#var hover_mat = HOVER_MAT.instance()
			for c in all_mesh_instances:
				c.visible = true
				if c != $Big:
					(c as MeshInstance).material_override = HOVER_MAT
