extends Camera

class_name MainCam

export var pivot_distance_between := .2
export var hover_push_x := .035
export var hover_push_z := -0.022
export var hover_scale := .15
export var hand_size_correct_trigger := 7
export var hand_size_correct_scale_y := -.08
export var hand_size_correct_scale_z := .05
export var hand_size_correct_hover_scale := .04

var cards := []

var drag_card : Karte = null
var hover_card : Karte = null

var target_return_destination: int

func generate_target_positions():
	if drag_card != null:
		if drag_card in cards:
			target_return_destination = cards.find(drag_card)
			cards.erase(drag_card)
		hover_card = null
		drag_card.hand_target_position = $Pivot/PlayPosition.translation
	
	var count := cards.size()
	var hand_size_excess := max(0.0, (count - hand_size_correct_trigger))
	$Pivot/MouseDetectionLayer.translation.y = hand_size_correct_scale_y * hand_size_excess + 0.02
	
	for i in range(count):
		var current_card := cards[i] as Karte
		
		# Karten gleichmäßig mittig verteilen
		var x_pos : float = i * pivot_distance_between - ((count - 1) * pivot_distance_between * .5)
		# Bei 7 oder mehr Karten die Karten mehr nach hinten und unten bewegen, damit sie alle auf den Bildschirm passen
		var y_pos : float = hand_size_correct_scale_y * hand_size_excess
		var z_pos : float = hand_size_correct_scale_z * hand_size_excess
		
		# Positionen ändern, wenn eine Karte gehovert wird
		if hover_card != null:
			var hovered_card_index := cards.find(hover_card)
			if i < hovered_card_index:
				x_pos -= hover_push_x
			elif i == hovered_card_index:
				var direction_to_camera = $Pivot.to_global(Vector3(x_pos, y_pos, z_pos)).direction_to(global_transform.origin)
				var hover_distance_vector = $Pivot.global_transform.basis.inverse() * ((hover_scale + hand_size_excess * hand_size_correct_hover_scale) * direction_to_camera)
				x_pos += hover_distance_vector.x
				y_pos += hover_distance_vector.y
				z_pos += hover_distance_vector.z + hover_push_z
			elif i > hovered_card_index:
				x_pos += hover_push_x
		
		if drag_card != null:
			if i < target_return_destination:
				x_pos -= hover_push_x * .7
			elif i >= target_return_destination:
				x_pos += hover_push_x * .7
		
		# Target Position auf Karte schreiben
		current_card.hand_target_position.x = x_pos
		current_card.hand_target_position.y = y_pos
		current_card.hand_target_position.z = z_pos

func return_to_hand(card: Karte) -> void:
	cards.insert(target_return_destination, card)
	generate_target_positions()

func drag_card_between_the_others(pos: Vector3) -> void:
	var local_pos_x = $Pivot.to_local(pos).x
	var x_positions := []
	for c in cards:
		x_positions.append(c.hand_target_position.x)
	x_positions.append(local_pos_x)
	x_positions.sort()
	target_return_destination = x_positions.find(local_pos_x)
	generate_target_positions()

const KARTE = preload("res://Objects/Karte.tscn")

func draw_card():
	var card := KARTE.instance() as Karte
	$Pivot.add_child(card)
	card.translation = $Pivot/CardSpawnPoint.translation
	card.change_type(GameInfo.get_random_card_name_from_pool())
	cards.append(card)
	generate_target_positions()

func remove_from_hand(card):
	cards.erase(card)
	generate_target_positions()
	
var velocity := Vector3.ZERO
export var acceleration := 30.0
export var damping := .02

func _physics_process(delta):
	if Input.is_action_just_pressed("create_new_card"):
		if GameInfo.faith_count > 0:
			GameInfo.set_faith(GameInfo.faith_count-GameInfo.faith_amount)

			draw_card()
	velocity += delta * acceleration * Vector3.RIGHT * (Input.get_action_strength("cam_move_right") - Input.get_action_strength("cam_move_left"))
	velocity += delta * acceleration * Vector3.FORWARD * (Input.get_action_strength("cam_move_up") - Input.get_action_strength("cam_move_down"))
	velocity *= pow(damping, delta)
	
	translation += velocity * delta
