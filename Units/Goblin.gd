extends Spatial

func _ready():
	$GoblinModel.transition_to("idle", 0)

var target : Spatial 
var v :float= 1
var stop_radius :float= 0.5

func seek_enemy():
	target = Functions.get_nearest_object_to_target(self, GameInfo.get_object_list("units"))

func state_frame(state, delta):
	match(state):
		"idle":
			seek_enemy()
			if target != null:
				$StateMachine.state = "walk"
		"walk":
			seek_enemy()
			if target == null:
				$StateMachine.state = "idle"
				return
			if Functions.distance_between(self, target) >= stop_radius:
				self.global_transform.origin += delta * v * \
				self.global_transform.origin.direction_to(target.global_transform.origin)
				turn_to_target()
			else:
				$StateMachine.state = "attack"
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

func state_start(state):
	match(state):
		"idle":
			$GoblinModel.transition_to("idle",.25)
		"walk":
			if Functions.distance_between(self, target) >= stop_radius:
				$GoblinModel.transition_to("walk",.5)
		"attack":
			$GoblinModel.transition_to("idle",.25)
			$GoblinModel.play_attack_animation()
			yield(get_tree().create_timer(.9),"timeout")
			attack()
			yield(get_tree().create_timer(.7),"timeout")
			$StateMachine.state = "idle"

func attack():
	if is_instance_valid(target):
		for area in $HitBox.get_overlapping_areas():
			var unit = area.get_parent()
			HealthPoints.deal_damage_to(unit, 10)
