extends Spatial

export var wave_count : int = 50
export var wave_wait_duration : float = .5
export var arrow_count : int = 10
export var radius : float = 2

const ARROW = preload("res://Projectiles/Arrow.tscn")

func _ready():
	$Area.scale.x *= radius
	$Area.scale.z *= radius
	for i in range (wave_count):
		shoot_wave()
		yield(get_tree().create_timer(wave_wait_duration),"timeout")
	yield(get_tree().create_timer(4),"timeout")
	self.queue_free()
		
func shoot_wave():
	for i in range(arrow_count):
		create_arrow()

func deal_damage():
	for area in $Area.get_overlapping_areas():
			var unit = area.get_parent()
			HealthPoints.deal_damage_to(unit, 1)	

func create_arrow():
	var new_arrow = ARROW.instance()
	self.add_child(new_arrow)
	new_arrow.translation.y = 4
	
	new_arrow.translation.x = radius * (randf() * 2 - 1)
	new_arrow.translation.z = 0
	new_arrow.translation = new_arrow.translation.rotated(Vector3.UP, randf() * TAU)
	
	new_arrow.connect("arrow_landed",self, "deal_damage")
