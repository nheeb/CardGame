extends Camera

class_name MainCam

export var pivot_distance := .2
export var hover_push := .05
export var hover_scale := 1.35
export var hover_lift := -.05
export var hand_size_correct_trigger := 7
export var hand_size_correct_scale_y := -.08
export var hand_size_correct_scale_z := .05

var cards := []

var drag_card : Karte = null
var hover_card : Karte = null

func generate_pivots():
	var drag_index := 0
	var hover_index := 0
	
	var count := cards.size()
	
	if drag_card != null:
		count -= 1
		drag_index = cards.find(drag_card)
		hover_card = null
	if hover_card != null:
		hover_index = cards.find(hover_card)
		
	for i in range(count):
		
		var x_pos : float = i * pivot_distance - ((count - 1) * pivot_distance * .5)
		var y_pos : float = hand_size_correct_scale_y * max(0.0, (count - hand_size_correct_trigger))
		var z_pos : float = hand_size_correct_scale_z * max(0.0, (count - hand_size_correct_trigger))
		
		var scale := 1.0
		
		if hover_card != null:
			if i < hover_index:
				x_pos -= hover_push
			if i > hover_index:
				x_pos += hover_push
			if i == hover_index:
				scale *= hover_scale
				z_pos += hover_lift
				
		if drag_card != null and i >= drag_index:
			i += 1
			
		(cards[i] as Karte).hand_pivot.origin.x = x_pos
		(cards[i] as Karte).hand_pivot.origin.y = y_pos
		(cards[i] as Karte).hand_pivot.origin.z = z_pos
		(cards[i] as Karte).hand_pivot.basis = Basis.IDENTITY.scaled(Vector3.ONE * scale)

const KARTE = preload("res://Objects/Karte.tscn")

func draw_card():
	var card := KARTE.instance() as Karte
	$Pivot.add_child(card)
	card.translation = Vector3(0,0,2)
	card.change_type(GameInfo.get_random_card_name_from_pool())
	cards.append(card)
	generate_pivots()

func remove_from_hand(card):
	cards.erase(card)
	generate_pivots()
	
var velocity := Vector3.ZERO
export var acceleration := 30.0
export var damping := .02

func _physics_process(delta):
	if Input.is_action_just_pressed("create_new_card"):
		draw_card()
	velocity += delta * acceleration * Vector3.RIGHT * (Input.get_action_strength("cam_move_right") - Input.get_action_strength("cam_move_left"))
	velocity += delta * acceleration * Vector3.FORWARD * (Input.get_action_strength("cam_move_up") - Input.get_action_strength("cam_move_down"))
	velocity *= pow(damping, delta)
	
	translation += velocity * delta
