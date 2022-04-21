extends Camera

class_name MainCam

export var pivot_distance := .2

var cards := []

var drag_card : Karte = null
var hover_card : Karte = null

func _physics_process(delta):
	if Input.is_action_just_pressed("create_new_card"):
		draw_card()

func generate_pivots():
	var drag_index := 0
	var hover_index := 0
	
	var count := cards.size()
	if drag_card != null:
		count -= 1
		drag_index = cards.find(drag_card)
	for i in range(count):
		var x_pos = i * pivot_distance - ((count - 1) * pivot_distance * .5)
		if drag_card != null and i >= drag_index:
			i += 1
		(cards[i] as Karte).hand_pivot.origin.x = x_pos

const KARTE = preload("res://Objects/Karte.tscn")

func draw_card():
	var card := KARTE.instance() as Karte
	$Pivot.add_child(card)
	card.translation = Vector3(0,0,2)
	card.change_type([2, 5][randi()%2])
	cards.append(card)
	generate_pivots()

func remove_from_hand(card):
	cards.erase(card)
	generate_pivots()
