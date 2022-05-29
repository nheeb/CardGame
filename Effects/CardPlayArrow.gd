extends Spatial

export(float, EASE) var shape: float = 1.0
export(int) var segment_count: int = 10
export(int) var resolution: int = 6
export(float) var width_start: float = .1
export(float) var width_end: float = .1
export(float) var build_up_duration := .75
export(float) var alpha_factor := .7

var mat: Material
var mat_for_background: Material
var alpha := 0.0

func set_alpha(a):
	alpha = a * alpha_factor
	$CardBackground.visible = alpha != 0.0
	$ImmediateGeometry.visible = alpha != 0.0
	var color = mat.get("shader_param/albedo")
	color.a = alpha
	mat.set("shader_param/albedo", color)
	mat_for_background.set("shader_param/albedo", color)

func _ready():
	mat = load("res://MaterialShader/CardPlayArrow.tres")
	mat.set("shader_param/more_transparent", 0.0)
	
	mat_for_background = load("res://MaterialShader/CardPlayArrow.tres").duplicate(true)
	mat_for_background.set("shader_param/more_transparent", 1.0)
	$CardBackground.material_override = mat_for_background
	
	set_alpha(.0)

func clear_arrow():
	$ImmediateGeometry.clear()
	$AlphaTween.stop_all()
	$AlphaTween.remove_all()
	set_alpha(0.0)

func build_arrow_to_global_point(end_global: Vector3) -> void:
	build_arrow(to_local(self.global_transform.origin), to_local(end_global))

func build_arrow(start: Vector3, end: Vector3) -> void: 
	var start_to_end := end - start
	var segments := []
	for i in range(segment_count):
		segments.append(float(i)/(segment_count-1))
	var segment_points := []
	for s in segments:
		var p : Vector3 = start + s * start_to_end
		p.y = start.y + ease(s, shape) * start_to_end.y
		segment_points.append(p)
	
	var segment_verts := []
	
	for i in range(segment_count - 1):
		var a : Vector3 = segment_points[i]
		var b : Vector3 = segment_points[i+1]
		var width : float = lerp(width_start, width_end, float(i)/(segment_count-1))
		segment_verts.append(get_directed_circle_points(a, b-a, resolution, width))
		if i == segment_count - 2: # for the last segment
			segment_verts.append(get_directed_circle_points(b, b-a, resolution, width_end))
	
	$ImmediateGeometry.clear()
	$ImmediateGeometry.begin(Mesh.PRIMITIVE_TRIANGLES)
	
	for i in range(segment_count - 1):
		var verts_a : Array = segment_verts[i]
		var verts_b : Array = segment_verts[i+1]
		for j in range(resolution):
			var left := j
			var right := (j + 1) % resolution
			
			$ImmediateGeometry.set_uv(Vector2(float(i)/(segment_count-1), 0))
			$ImmediateGeometry.add_vertex(verts_a[left])
			$ImmediateGeometry.set_uv(Vector2(float(i+1)/(segment_count-1), 0))
			$ImmediateGeometry.add_vertex(verts_b[left])
			$ImmediateGeometry.set_uv(Vector2(float(i)/(segment_count-1), 1))
			$ImmediateGeometry.add_vertex(verts_a[right])
			
			$ImmediateGeometry.set_uv(Vector2(float(i+1)/(segment_count-1), 0))
			$ImmediateGeometry.add_vertex(verts_b[left])
			$ImmediateGeometry.set_uv(Vector2(float(i+1)/(segment_count-1), 1))
			$ImmediateGeometry.add_vertex(verts_b[right])
			$ImmediateGeometry.set_uv(Vector2(float(i)/(segment_count-1), 1))
			$ImmediateGeometry.add_vertex(verts_a[right])

	$ImmediateGeometry.end()
	$ImmediateGeometry.material_override = mat
	#$ImmediateGeometry.material_override.set("shader_param/more_transparent", 0.0)
	
	if alpha == 0.0:
		$AlphaTween.interpolate_method(self, "set_alpha", 0.01, 1.0, build_up_duration, Tween.TRANS_QUAD, Tween.EASE_IN)
		$AlphaTween.start()

func get_directed_circle_points(origin: Vector3, direction: Vector3, res: int, wid: float) -> Array:
	direction = direction.normalized()
	var start_point := Vector3.UP.cross(direction).cross(direction).normalized() * wid
	var circle_points := []
	for i in range(res):
		circle_points.append(origin + start_point.rotated(direction, 2.0*PI*float(i)/res))
	return circle_points
