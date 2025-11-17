extends Node

@export var resources : Array[Resource]

func _ready() -> void:
	for res in resources:
		var chara : Character = res.duplicate()
		chara.resource_name = chara.name + " (Thorn Remix)"
		chara.name = chara.name + " (Thorn Remix)"
		var path : String = res.resource_path
		chara.resource_path = path.insert(path.length() - 5, " (Thorn Remix)")
		print(chara.resource_path)
		chara.origin = "The Caligula Effect"
		ResourceSaver.save(chara)
	print(resources[0].origin)
	
