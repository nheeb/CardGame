extends Spatial

var target : Spatial
var v :float= 1
var stop_radius :float= 0.5

func _ready():
	seek_tree()
	
func _physics_process(delta):
	if target != null:
		if distance_to_tree(target)>= stop_radius:
			self.rotation_degrees.y = rad2deg(self.global_transform.origin.direction_to(target.global_transform.origin).angle_to(Vector3.FORWARD))
			self.global_transform.origin += delta * v * self.global_transform.origin.direction_to(target.global_transform.origin) 
		
	
func seek_tree():
	GameInfo.treeListe.sort_custom(self, "tree_cmpr")
	start_move_to_tree(GameInfo.treeListe[0])
	
func tree_cmpr(tree1, tree2):
	return distance_to_tree(tree1) < distance_to_tree(tree2)
	
func distance_to_tree(tree):
	return tree.global_transform.origin.distance_to(self.global_transform.origin)
	
func start_move_to_tree(tree):
	target = tree

		
