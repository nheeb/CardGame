extends ImmediateGeometry

export var segment_count := 10
export var seg_max_dist := .2
export var resolution := 5
export(float, 0, 1) var spring_force := 3.0
export var radius := .2
export(float, EASE) var shape := 1.0
export var material : Material
export var render_min_dist := .08

var aabb: AABB
var seg_global_points := []
var rendered_indexes := []

#var last_global_pos : Vector3
#var velocity_direction : Vector3

func _ready():
	for i in range(segment_count):
		seg_global_points.append(global_transform.origin)
	material_override = material
#	last_global_pos = global_transform.origin

func _process(delta):
#	if global_transform.origin != last_global_pos:
#		velocity_direction = (global_transform.origin - last_global_pos).normalized()
#		last_global_pos = global_transform.origin
	update(delta)
	render()

func update(delta: float):
	seg_global_points[0] = global_transform.origin
	for i in range(1, segment_count):
		var current_point : Vector3 = seg_global_points[i]
		var last_point : Vector3 = seg_global_points[i-1]
		var dist_to_last: float = current_point.distance_to(last_point)
		current_point = current_point + delta * i * spring_force * dist_to_last * current_point.direction_to(last_point)
		dist_to_last = current_point.distance_to(last_point)
		if dist_to_last > seg_max_dist:
			current_point = last_point + seg_max_dist * last_point.direction_to(current_point)
		seg_global_points[i] = current_point
	rendered_indexes = [0]
	for i in range(1, segment_count-1):
		if seg_global_points[i].distance_to(seg_global_points[rendered_indexes[-1]]) > render_min_dist:
			rendered_indexes.append(i)
	if rendered_indexes.size() != 1 or seg_global_points[0].distance_to(seg_global_points[segment_count-1]) > render_min_dist:
		rendered_indexes.append(segment_count-1)
	

func render():
	var rings := []
	for i in rendered_indexes:
		var local_position : Vector3 = seg_global_points[i] - global_transform.origin
		var direction : Vector3
		if i != segment_count-1:
			direction = seg_global_points[i].direction_to(seg_global_points[i+1])
		else:
			direction = seg_global_points[i-1].direction_to(seg_global_points[i])
		if direction.length() == 0:
			direction = Vector3.LEFT
		var current_radius := radius * ease(1.0 - (float(i) / (segment_count-1)), shape)
		var v := Vector3.DOWN.cross(direction).cross(direction) * current_radius
		var verts := []
		for j in range(resolution):
			var v_pos := local_position + v.rotated(direction, TAU * float(j) / resolution)
			verts.append(v_pos)
		rings.append(verts)

	clear()
	begin(Mesh.PRIMITIVE_TRIANGLES)
	for i in range(1, rings.size()):
		var seg_verts_a = rings[i-1]
		var seg_verts_b = rings[i]
		for j in range(resolution):
			var index_left := j
			var index_right := (j+1)%resolution

			add_vertex(seg_verts_a[index_left])
			add_vertex(seg_verts_b[index_left])
			add_vertex(seg_verts_b[index_right])

			add_vertex(seg_verts_b[index_right])
			add_vertex(seg_verts_a[index_right])
			add_vertex(seg_verts_a[index_left])
	#add_sphere(8, 8, radius)
	end()
