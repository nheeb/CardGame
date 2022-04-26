extends Spatial

const Enemy = preload("res://Units/FighterEnemy.tscn")

func _physics_process(delta):
	var camera = $Camera
	var from = camera.project_ray_origin(get_viewport().get_mouse_position())
	var to = camera.project_ray_normal(get_viewport().get_mouse_position())
	var cursorPos = Plane(Vector3.UP, .2).intersects_ray(from, to)
	GameInfo.mouse_position = cursorPos

func _ready():
	GameInfo.ui = $UI
	GameInfo.main_cam = $Camera


func _on_Timer_timeout():
	var new_enemy = Enemy.instance()
	get_tree().current_scene.add_child(new_enemy)
	new_enemy.translation = Vector3(1,0,1)
	#new_enemy.translation.y = 0
