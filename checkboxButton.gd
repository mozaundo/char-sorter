extends Control

signal boxChecked(origin:String, value:bool)

@export var text:String

func _ready() -> void:
	$CheckBox.toggled.connect(checked)

func checked(value:bool):
	boxChecked.emit(text, value)
