extends Control

signal boxChecked(origin:String, value:bool)

var origin:String

func _ready() -> void:
	$CheckBox.toggled.connect(checked)

func checked(value:bool):
	boxChecked.emit(origin, value)
