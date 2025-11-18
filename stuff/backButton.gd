extends Button

func _ready() -> void:
	button_down.connect(SceneManager.loadMenu)
