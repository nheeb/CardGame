extends Spatial

var bezugsobjekt : Spatial

func distance_compare(obj1, obj2):
	return distance_to_object(obj1) <= distance_to_object(obj2)

func distance_to_object(obj):

	return obj.global_transform.origin.distance_to(bezugsobjekt.global_transform.origin)	
#func _physics_process(delta):
