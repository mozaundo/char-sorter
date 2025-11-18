extends Control

@export var slotNode : PackedScene 
@export var slotParent : Control

@export var winnerHeight : int
@export var winnerColors : Array[Color]

@export var compactParent : Control

func _ready() -> void:
	$HomeButton.button_down.connect(SceneManager.loadMenu)
	$ViewButton.button_down.connect(toggleView)
	
	SceneManager.ranking.reverse()
	var i = 0
	for chara in SceneManager.ranking:
		i += 1
		var slot : Panel = slotNode.instantiate()
		slot.get_node("Image").texture = chara.image
		slot.get_node("Name").text = chara.name
		slot.get_node("Origin").text = chara.origin
		slot.get_node("Ranking").text = "#" + str(i)
		if (i <= 3):
			if (i == 1):
				slot.custom_minimum_size.y = winnerHeight
			#var style:StyleBoxFlat = StyleBoxFlat.new()
			#style.bg_color = 
			slot.get_theme_stylebox("panel").bg_color = winnerColors[i-1]
		slotParent.add_child(slot)
	
	i = 0
	var childSize = compactParent.get_children().size()
	for chara in SceneManager.ranking:
		i += 1
		if (i > childSize):
			break
		var slot : Control = compactParent.get_child(i - 1)
		slot.get_node("TextureRect").texture = chara.image
		slot.get_node("Rank").text = "#" + str(i)
		slot.get_node("Name").text = chara.name

func toggleView():
	var parent = slotParent.get_parent()
	parent.visible = !parent.visible
	compactParent.visible = !compactParent.visible
