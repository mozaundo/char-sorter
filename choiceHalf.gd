class_name ChoiceHalf
extends Control

@export var isRight : bool

@export var button : Button

@export var image : TextureRect
@export var charName : Label
@export var originName : Label

signal choiceMade(isRight:bool)

func _ready() -> void:
	button.button_down.connect(onButtonPress)

func setupCharacter(chara:Character):
	image.texture = chara.image
	charName.text = chara.name
	originName.text = chara.origin
	pass

func onButtonPress():
	choiceMade.emit(isRight)
