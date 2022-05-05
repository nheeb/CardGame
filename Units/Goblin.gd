extends Spatial

var hp :int= 100
var max_hp :int= 100

func _ready():
	hp_change(max_hp)
	$GoblinModel.transition_to("idle", 0)
	
#func _physics_process(delta):
#	match(state):
#		pass
#	pass
	
func hp_change(new_hp):
	hp = new_hp
	if hp <= 0:
		self.queue_free()
		GameInfo.get_object_list("enemies").erase(self)
	$ProgressBar.progress = hp/float(max_hp)
	
var target : Spatial 
var state : String = "idle"
var v :float= 1
var stop_radius :float= 0.5

#func _ready():
#	GameInfo.unitListe.append(self)

func seek_enemy():
	if GameInfo.get_object_list("units").empty():
		target = null
		return
	Functions.bezugsobjekt = self
	GameInfo.get_object_list("units").sort_custom(Functions, "distance_compare")
	target = GameInfo.get_object_list("units")[0]

func _physics_process(delta):
	match(state):
		"idle":
			seek_enemy()
			if target != null:
				change_state("walk")
		"walk":
			seek_enemy()
			if target == null:
				change_state("idle")
				return
			if distance_to(target) >= stop_radius:
				
				self.global_transform.origin += delta * v * \
				self.global_transform.origin.direction_to(target.global_transform.origin)
				turn_to_target()
				
			else:
				change_state("attack")
				
			
		"attack":
			turn_to_target()
			
	var soft_collision_speed := .3
	for other_area in $SoftCollision.get_overlapping_areas():
		var other_goblin := other_area.get_parent() as Spatial
		self.global_transform.origin += delta * soft_collision_speed * other_goblin.global_transform.origin.direction_to(self.global_transform.origin)

func turn_to_target():
	if is_instance_valid(target):
		var dir : Vector3 = self.global_transform.origin.direction_to(target.global_transform.origin)
		dir.y = 0
		dir = dir.normalized()
		self.rotation.y = -dir.signed_angle_to(Vector3.BACK,Vector3.UP)

func change_state(new_state):
	state = new_state
	match(state):
		"idle":
			$GoblinModel.transition_to("idle",.25)
		"walk":
			if distance_to(target) >= stop_radius:
				$GoblinModel.transition_to("walk",.5)
		"attack":
			$GoblinModel.transition_to("idle",.25)
			$GoblinModel.play_attack_animation()
			yield(get_tree().create_timer(.9),"timeout")
			attack()
			yield(get_tree().create_timer(.7),"timeout")
			change_state("idle")

func distance_to(obj):
	Functions.bezugsobjekt = self
	return Functions.distance_to_object(obj)
	
func attack():
	#GameInfo.get_object_list("units").erase(target)
	if is_instance_valid(target):
		target.hp_change(target.hp - 10)

