extends Control

@export var checkBoxScene : PackedScene
@export var originParent : Control

func _ready() -> void:
	$StartButton.pressed.connect(SceneManager.loadSorter)
	
	print(CharacterManager.origins.size())
	for origin in CharacterManager.origins:
		print("lesgo")
		var checkbox = checkBoxScene.instantiate()
		checkbox.get_node("Label").text = origin
		checkbox.origin = origin
		checkbox.boxChecked.connect(setOrigin)
		originParent.add_child(checkbox)

func setOrigin(origin : String, value : bool):
	CharacterManager.originSettings[origin] = value
