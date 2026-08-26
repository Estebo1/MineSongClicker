extends Node2D

@onready var conductor = $AudioStreamPlayer 
@onready var note_pool = $NoteObjectPool
@onready var boton_play = $ButtonPlay            

func _ready() -> void:
	conductor.beat.connect(_on_conductor_beat)
func _on_button_pressed() -> void:
	boton_play.hide()
	conductor.play_with_beat_offset(0)

func _on_conductor_beat(posicion_beat: int) -> void:
	print("Beat: ", posicion_beat)
	
	var carril_aleatorio = randi() % 3
	var nota_lanzada = note_pool.spawn_note(carril_aleatorio)
