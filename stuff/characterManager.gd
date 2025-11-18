extends Node

@export var characters : Array[Character]

var originSettings : Dictionary[String, bool]
var origins : Array[String]

var currentCategory : String = "Character"
var genderSettings : Dictionary[String, bool]

var tagsSettings : Dictionary[String, bool]

func _ready() -> void:
	generateOrigins()
	
	tagsSettings["Male"] = true
	tagsSettings["Female"] = true
	tagsSettings["Neither"] = true

func generateOrigins():
	origins.clear()
	for chara in characters:
		if (chara.category != currentCategory):
			continue
		var origin = chara.origin
		if (!origins.has(origin)):
			origins.append(origin)
		if (!originSettings.has(origin)):
			originSettings[origin] = false

func changeCategory(category:String):
	currentCategory = category
	generateOrigins()

func resetSettings():
	for key in originSettings.keys():
		originSettings[key] = true

func getCharPool() -> Array[Character]:
	var arr : Array[Character]
	for chara in characters:
		if (chara.category != currentCategory):
			continue
		if (!originSettings[chara.origin]):
			continue
		if (!tagsSettings[chara.gender]):
			continue
		arr.append(chara)
	return arr
