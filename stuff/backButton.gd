extends Button

@onready var popup = $"../ExitPopup"

func _ready() -> void:
	button_down.connect(openPopup.bind(true))
	$"../ExitPopup/Panel/yes".button_down.connect(SceneManager.loadMenu)
	$"../ExitPopup/Panel/no".button_down.connect(openPopup.bind(false))

func openPopup(value = true):
	popup.visible = value
