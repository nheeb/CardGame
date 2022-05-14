extends Spatial
class_name HealthPoints

var hp: int
export var hp_max := 100
export var delete_on_default := true

static func deal_damage_to(target: Spatial, damage: int) -> void:
	if target.has_node("HealthPoints"):
		target.get_node("HealthPoints").take_damage(damage)

func _ready():
	hp_change(hp_max)
	$ProgressBar.set_color(Color.darkgreen)

func hp_change(new_hp: int) -> void:
	hp = new_hp
	$ProgressBar.progress = hp/float(hp_max)
	if hp <= 0:
		_hp_zero()

func _hp_zero():
	ListManager.trigger_hp_zero(get_parent())
	if get_parent().has_method("on_hp_zero"):
		get_parent().call("on_hp_zero")
	else:
		if delete_on_default:
			get_parent().queue_free()

func take_damage(damage: int) -> void:
	hp_change(hp - damage)
