extends Spatial

var target : Spatial 
var v :float= 1
var stop_radius :float= 0.5

func seek_enemy():
	target = Functions.get_nearest_object_to_target(self, GameInfo.get_object_list("enemies"))

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
			else:
				$StateMachine.state = "attack"

func state_start(state):
	match(state):
		"attack":
			$AnimationPlayer.play("AngriffFighter")

func attack():
	if is_instance_valid(target):
		HealthPoints.deal_damage_to(target, 5)
