extends Node2D

@export var note_scene : PackedScene
@export var pool_size : int = 10

var pool : Array = []

func _ready() -> void:
	for i in range(pool_size):
		var note_instance = note_scene.instantiate()
		add_child(note_instance)
		pool.append(note_instance)

func spawn_note(lane: int):
	# Buscamos una nota apagada y la prendemos
	for note in pool:
		if not note.isActive:
			note.ActivateNote(lane)
			return note
			
	# Si todas están ocupadas, creamos una nueva
	var new_note = note_scene.instantiate()
	add_child(new_note)
	pool.append(new_note) 
	
	new_note.ActivateNote(lane)
	return new_note
