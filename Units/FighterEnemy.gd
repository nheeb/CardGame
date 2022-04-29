extends Spatial


var hp :int= 100
var max_hp :int= 100

func _ready():
	GameInfo.enemyListe.append(self)
	hp_change(max_hp)
	
func hp_change(new_hp):
	hp = new_hp
	if hp <= 0:
		GameInfo.enemyListe.erase(self)
		self.queue_free()
	$ProgressBar.progress = hp/float(max_hp)


