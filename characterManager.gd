extends Node

@export var characters : Array[Character]

var originSettings : Dictionary[String, bool]
var origins : Array[String]

func _ready() -> void:
	generateOrigins()

func generateOrigins():
	for chara in characters:
		var origin = chara.origin
		if (origins.find(origin) == -1):
			origins.append(origin)
			originSettings[origin] = true

func resetSettings():
	for key in originSettings.keys():
		originSettings[key] = true

func getCharPool() -> Array[Character]:
	var arr : Array[Character]
	for chara in characters:
		if (!originSettings[chara.origin]):
			continue
		arr.append(chara)
	return arr
