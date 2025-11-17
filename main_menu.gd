extends Control

@export var checkBoxScene : PackedScene
@export var originParent : Control

@export var errorLabel : Label
@export var genderPanel : Control

@export var charaButton : Button
@export var songsButton : Button

@export var allButton : Button
@export var noneButton : Button

@export var maleButton : Control
@export var femaleButton : Control

func _ready() -> void:
	$StartButton.button_down.connect(SceneManager.loadSorter)
	SceneManager.messageSent.connect(setError)
	
	charaButton.button_down.connect(setCategory.bind("Character"))
	songsButton.button_down.connect(setCategory.bind("Song"))
	
	var isChara = CharacterManager.currentCategory == "Character"
	if (isChara):
		charaButton.modulate = Color(charaButton.modulate, 1)
		songsButton.modulate = Color(songsButton.modulate, 0.8)
	else:
		charaButton.modulate = Color(charaButton.modulate, 0.8)
		songsButton.modulate = Color(songsButton.modulate, 1)
	
	allButton.button_down.connect(setAll.bind(true))
	noneButton.button_down.connect(setAll.bind(false))
	
	maleButton.get_node("CheckBox").button_pressed = CharacterManager.tagsSettings["Male"]
	femaleButton.get_node("CheckBox").button_pressed = CharacterManager.tagsSettings["Female"]
	femaleButton.boxChecked.connect(setTag)
	maleButton.boxChecked.connect(setTag)
	
	print(CharacterManager.origins.size())
	generateCategories()

func generateCategories():
	for child in originParent.get_children():
		child.queue_free()
	
	for origin in CharacterManager.origins:
		print("lesgo")
		var checkbox = checkBoxScene.instantiate()
		checkbox.get_node("Label").text = origin
		checkbox.text = origin
		checkbox.boxChecked.connect(setOrigin)
		checkbox.name = origin
		print(origin)
		if (CharacterManager.originSettings.has(origin)):
			print("it DOES have it "+ str(CharacterManager.originSettings[origin]))
			checkbox.get_node("CheckBox").button_pressed = CharacterManager.originSettings[origin]
		originParent.add_child(checkbox, true)

func setCategory(category:String):
	var isChara = category == "Character"
	if (isChara):
		charaButton.modulate = Color(charaButton.modulate, 1)
		songsButton.modulate = Color(songsButton.modulate, 0.8)
	else:
		charaButton.modulate = Color(charaButton.modulate, 0.8)
		songsButton.modulate = Color(songsButton.modulate, 1)
	
	genderPanel.visible = isChara
	
	CharacterManager.changeCategory(category)
	generateCategories()

func setOrigin(origin : String, value : bool):
	print("set origin call")
	CharacterManager.originSettings[origin] = value
	print(CharacterManager.originSettings)

func setTag(tag : String, value : bool):
	CharacterManager.tagsSettings[tag] = value

func setAll(value:bool):
	var i = 0
	for origin in CharacterManager.origins:
		#setOrigin(origin, value)
		var node = originParent.get_child(i)
		if (node != null):
			node.get_node("CheckBox").button_pressed = value
		i += 1

func setError(msg:String):
	errorLabel.text = msg
