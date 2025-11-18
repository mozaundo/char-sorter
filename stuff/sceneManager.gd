extends Node

@export var charPool : Array[Character]
var ranking : Array[Character]

@export var sorterNode : PackedScene
@export var rankingNode : PackedScene
@export var menuNode : PackedScene

signal messageSent(msg:String)

func loadSorter():
	charPool = CharacterManager.getCharPool()
	if (charPool.size() < 2):
		print("Pool too small. Did you forget to select a category?")
		messageSent.emit("Pool too small. Did you forget to select a category?")
		return
	get_tree().change_scene_to_packed(sorterNode)

func loadRanking():
	get_tree().change_scene_to_packed(rankingNode)

func loadMenu():
	#CharacterManager.resetSettings()
	get_tree().change_scene_to_packed(menuNode)
