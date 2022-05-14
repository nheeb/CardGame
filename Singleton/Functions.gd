extends Spatial

#var bezugsobjekt : Spatial

#func distance_compare(obj1, obj2):
#	return distance_to_object(obj1) <= distance_to_object(obj2)

#func distance_to_object(obj):
#	return obj.global_transform.origin.distance_to(bezugsobjekt.global_transform.origin)	

func get_nearest_object_to_target(target: Spatial, objects: Array):
	if objects.empty(): return null
	var dist := target.global_transform.origin.distance_to(objects[0].global_transform.origin)
	var nearest := objects[0] as Spatial
	for obj in objects:
		var obj_dist := target.global_transform.origin.distance_to(obj.global_transform.origin)
		if dist > obj_dist:
			dist = obj_dist
			nearest = obj
	return nearest

func distance_between(a : Spatial, b : Spatial) -> float:
	return a.global_transform.origin.distance_to(b.global_transform.origin)
