extends Spatial

var v : float = 0
var acceleration : float = 5.5
signal arrow_landed 
var not_landed : bool = true

func _physics_process(delta):
	v += acceleration * delta
	if translation.y > 0: translation.y -= v * delta
	else: 
		if not_landed: 
			emit_signal("arrow_landed")
			not_landed = false

