class_name Character
extends Resource

@export var name : String
@export var image : Texture2D
@export var origin : String
@export_enum("Character", "Song") var category : String = "Character"
@export_enum("Male", "Female", "Neither") var gender : String
