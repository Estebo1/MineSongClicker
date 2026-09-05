extends Node2D

@onready var mineral_label : Label = $Minerals

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	UpdateMineral()
	pass # Replace with function body.

func UpdateMineral():
	mineral_label.text = "Minerals: " + str(Global.minerales)

func return_button():
	get_tree().change_scene_to_file("res://Scenes/Game.tscn")
