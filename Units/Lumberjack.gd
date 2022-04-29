extends Spatial

var target : Spatial
var v :float= 1
var stop_radius :float= 0.5
var duration :float= 5

func _ready():
	yield(get_tree(),"idle_frame")
	seek_tree()
	
func _physics_process(delta):
	if target != null:
		if not is_instance_valid(target): 
			seek_tree()
			return
		if distance_to_tree(target) >= stop_radius:
			self.global_transform.origin += delta * v * self.global_transform.origin.direction_to(target.global_transform.origin) 
		else:
			chop(target)
			target = null

const RoundProgressBar = preload("res://Effects/RoundProgressBar.tscn")
const ParticleExplosion = preload("res://Effects/ParticleExplosion.tscn")
			
func chop(tree):
	var new_rpb = RoundProgressBar.instance()
	tree.add_child(new_rpb)
	new_rpb.translation = Vector3(0,0.2,0)
	new_rpb.scale = Vector3(0.5,0.5,0.5)
	
	$ProgressTween.interpolate_property(new_rpb, "progress", 0, 1, duration)
	$ProgressTween.start()
	
	#yield(get_tree().create_timer(duration),"timeout") #yield bedeutet, dass er auf ein bistimmtes signal warten soll
	yield($ProgressTween, "tween_all_completed")
	
	GameInfo.holz_count += GameInfo.holz_amount
	
	var new_prcl = ParticleExplosion.instance()
	get_tree().current_scene.add_child(new_prcl)
	new_prcl.scale = 0.2 * Vector3.ONE
	new_prcl.translation = tree.global_transform.origin
	
	if is_instance_valid(tree):
		tree.queue_free()
	seek_tree()

func seek_tree():
	if GameInfo.treeListe.empty(): 
		self.queue_free()
		return
	GameInfo.treeListe.sort_custom(self, "tree_cmpr")
	start_move_to_tree(GameInfo.treeListe[0])

func tree_cmpr(tree1, tree2):
	return distance_to_tree(tree1) <= distance_to_tree(tree2)

func distance_to_tree(tree):
	return tree.global_transform.origin.distance_to(self.global_transform.origin)

func start_move_to_tree(tree):
	GameInfo.treeListe.erase(tree)
	target = tree
	var dir :Vector3= self.global_transform.origin.direction_to(target.global_transform.origin)
	dir.y = 0
	dir = dir.normalized()
	self.rotation.y = -dir.signed_angle_to(Vector3.BACK,Vector3.UP)
