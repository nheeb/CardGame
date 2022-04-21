extends Spatial

func _ready():
	GameInfo.treeListe.append(self)


func _on_Tree_tree_exiting():
	GameInfo.treeListe.erase(self)
