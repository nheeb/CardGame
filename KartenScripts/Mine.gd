extends Karte

var hover_radius : float = 3
var hover_rock = null

func play_effect():
	hover_rock.set_build_state("build")
	GameInfo.objectDictionary["rocks"].erase(hover_rock)
	GameInfo.holz_count = GameInfo.holz_count - 25

func is_play_valid():
	return (hover_rock != null) and (GameInfo.holz_count >= 25)

func on_ground_hover(position: Vector3):
	var min_distance : float
	var min_rock = null
	for rock in GameInfo.objectDictionary["rocks"]:
		var distance := position.distance_to(rock.global_transform.origin)
		if (min_rock == null) or (min_distance > distance):
			min_distance = distance
			min_rock = rock
	if min_distance < hover_radius:
		if min_rock != hover_rock:
			if hover_rock != null:
				hover_rock.set_build_state("none")
			min_rock.set_build_state("hover")
			hover_rock = min_rock
	else:
		if hover_rock != null:
			hover_rock.set_build_state("none")
			hover_rock = null

func on_return_to_hand():
	if hover_rock != null:
		hover_rock.set_build_state("none")
		hover_rock = null
