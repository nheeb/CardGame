extends Spatial

var target : Spatial 
var state : String = "idle"
var v :float= 1
var stop_radius :float= 0.5

func _ready():
	GameInfo.unitListe.append(self)

func seek_enemy():
	if GameInfo.enemyListe.empty(): 
		target = null
		return
	Functions.bezugsobjekt = self
	GameInfo.enemyListe.sort_custom(Functions, "distance_compare")
	target = GameInfo.enemyListe[0]
	
	#start_move_to_enemy(GameInfo.enemyListe[0])



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
	GameInfo.enemyListe.erase(target)
	if is_instance_valid(target):
		target.queue_free()	
	

#
#
#var target : Spatial
#var v :float= 1
#var stop_radius :float= 0.5
#
##func _on_Tree_tree_exiting():
#	#GameInfo.treeListe.erase(self)
#
#func attack():
#	target.queue_free()
#
#func _physics_process(delta):
#	if target != null:
#		if not is_instance_valid(target): 
#			seek_enemy()
#			return
#		if distance_to_enemy(target) >= stop_radius:
#			self.global_transform.origin += delta * v * self.global_transform.origin.direction_to(target.global_transform.origin) 
#		else:
#			fight(target)
#			target = null
#
#func fight(enemy):
#	yield(get_tree().create_timer(1),"timeout")
#	#GameInfo.holz_count += GameInfo.holz_amount
#	$AnimationPlayer.play("AngriffFighter")
#	#seek_enemy()
#
#func seek_enemy():
#	if GameInfo.enemyListe.empty(): 
#		self.queue_free()
#		return
#	GameInfo.unitListe.sort_custom(self, "enemy_cmpr")
#	start_move_to_enemy(GameInfo.enemyListe[0])
#
#func enemy_cmpr(enemy1, enemy2):
#	return distance_to_enemy(enemy1) <= distance_to_enemy(enemy2)
#
#func distance_to_enemy(enemy):
#	return enemy.global_transform.origin.distance_to(self.global_transform.origin)
#
#func start_move_to_enemy(enemy):
#	#GameInfo.treeListe.erase(tree)
#	target = enemy
#	var dir :Vector3= self.global_transform.origin.direction_to(target.global_transform.origin)
#	dir.y = 0
#	dir = dir.normalized()
#	self.rotation.y = -dir.signed_angle_to(Vector3.BACK,Vector3.UP)
#

