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
				var dir : Vector3 = self.global_transform.origin.direction_to(target.global_transform.origin)
				dir.y = 0
				dir = dir.normalized()
				self.rotation.y = -dir.signed_angle_to(Vector3.BACK,Vector3.UP)
				
			else:
				change_state("attack")
				
			
		"attack":
			pass

func change_state(new_state):
	state = new_state
	match(state):
		"idle":
			pass
		"walk":
			$GoblinModel.transition_to("walk",.5)
		"attack":
			pass
			$GoblinModel.transition_to("idle",.25)

func distance_to(obj):
	Functions.bezugsobjekt = self
	return Functions.distance_to_object(obj)
	
func attack():
	GameInfo.get_object_list("units").erase(target)
	if is_instance_valid(target):
		target.queue_free()

