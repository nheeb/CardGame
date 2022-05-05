extends Spatial

var target : Spatial 
var state : String = "idle"
var v :float= 1
var stop_radius :float= 0.5

func _ready():
	$ProgressBar.set_color(Color.darkgreen)
	hp_change(max_hp)

var hp :int= 100
var max_hp :int= 100

func hp_change(new_hp):
	hp = new_hp
	if hp <= 0:
		self.queue_free()
		GameInfo.get_object_list("units").erase(self)
	$ProgressBar.progress = hp/float(max_hp)

func seek_enemy():
	if GameInfo.get_object_list("enemies").empty(): 
		target = null
		return
	Functions.bezugsobjekt = self
	GameInfo.get_object_list("enemies").sort_custom(Functions, "distance_compare")
	target = GameInfo.get_object_list("enemies")[0]

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
			pass
		"attack":
			$AnimationPlayer.play("AngriffFighter")

func distance_to(obj):
	Functions.bezugsobjekt = self
	return Functions.distance_to_object(obj)
	
func attack():
	#GameInfo.get_object_list("enemies").erase(target)
	if is_instance_valid(target):
		target.hp_change(target.hp-20)
