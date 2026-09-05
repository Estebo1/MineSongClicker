extends Node2D

@onready var conductor = $Conductor
@onready var note_pool = $NoteObjectPool 
@onready var buttons = $Buttons 
@onready var minigame = $Minigame 

@onready var label_minerales = $MineralLabel
@onready var label_combo = $ComboLabel
@onready var label_vidas = $Minigame/VidasLabel 
@onready var rockPool = $RockObjectPool
@onready var pickaxe = $PlayerPickaxe

var playlist = [
	{"audio": preload("res://Music/Cancion1.wav"), "bpm": 135},
	{"audio": preload("res://Music/Cancion2.wav"), "bpm": 127},
	{"audio": preload("res://Music/Cancion3.wav"), "bpm": 140},
	{"audio": preload("res://Music/Cancion4.wav"), "bpm": 124},
	{"audio": preload("res://Music/Cancion5.wav"), "bpm": 130},
	{"audio": preload("res://Music/Cancion6.wav"), "bpm": 142},
	{"audio": preload("res://Music/Cancion7.wav"), "bpm": 128},
	{"audio": preload("res://Music/Cancion8.wav"), "bpm": 140},
	{"audio": preload("res://Music/Cancion9.wav"), "bpm": 124}
]
func _ready():
	conductor.finished.connect(_on_conductor_finished)
	actualizar_ui()
	if minigame:
		minigame.hide()

func _input(event):
	if event.is_action_pressed("escape"):
		get_tree().change_scene_to_file("res://Scenes/Menu.tscn")

func _on_button_play_pressed() -> void:
	if buttons:
		buttons.hide() 
	if minigame:
		minigame.show()
		
	Global.resetear_estadisticas() 
	actualizar_ui()
	preparar_cancion_al_azar()
	conductor.play_with_beat_offset(0)
	
func preparar_cancion_al_azar():
	var cancion_elegida = playlist.pick_random()
	conductor.bpm = cancion_elegida["bpm"]
	conductor.stream = cancion_elegida["audio"]

func _on_conductor_finished():
	preparar_cancion_al_azar()
	conductor.play_with_beat_offset(0)

func _on_conductor_measure(position):
	if not conductor.stream: return
	var total_length = conductor.stream.get_length()
	if total_length == 0: return
	
	var progress = conductor.song_position / total_length
	var probabilidad = randi() % 100
	var notas_a_crear = 0
	
	if progress < 0.10 or progress > 0.90:
		if probabilidad < 50: notas_a_crear = 0
		else: notas_a_crear = 1
	elif progress >= 0.10 and progress < 0.60:
		if probabilidad < 30: notas_a_crear = 0
		elif probabilidad < 60: notas_a_crear = 1
		else: notas_a_crear = 2
	else:
		if probabilidad < 10: notas_a_crear = 0
		elif probabilidad < 50: notas_a_crear = 1
		else: notas_a_crear = 2
			
	_spawn_notes(notas_a_crear)

func _on_conductor_beat(position):
	pass
	
func _spawn_notes(to_spawn: int):
	if to_spawn == 1:
		note_pool.spawn_note(randi() % 2)
	elif to_spawn >= 2:
		note_pool.spawn_note(0)
		note_pool.spawn_note(1)

func increment_score(by: int):
	pickaxe.mine()
	if by > 0: 
		Global.combo += 1
		
		var valor_roca = rockPool.mine_first_rock()
		Global.minerales += (by * valor_roca)
		if Global.combo > Global.max_combo:
			Global.max_combo = Global.combo
	else:
		fallar_nota()
		
	actualizar_ui()

func reset_combo():
	fallar_nota()
	actualizar_ui()

func fallar_nota():
	Global.combo = 0
	Global.vidas -= 1
	
	if Global.vidas <= 0:
		game_over()

func game_over():
	conductor.stop()
	for note in note_pool.get_children():
		if note.has_method("DeactivateNote"):
			note.DeactivateNote()
			
	if buttons:
		buttons.show()
	if minigame:
		minigame.hide()

func actualizar_ui():
	if label_minerales:
		label_minerales.text = "Minerales: " + str(Global.minerales)
		
	if label_vidas:
		label_vidas.text = "Vidas: " + str(Global.vidas)
		
	if label_combo:
		if Global.combo > 0:
			label_combo.text = str(Global.combo) + " combo!"
		else:
			label_combo.text = ""

func shop_button():
	get_tree().change_scene_to_file("res://Scenes/Shop.tscn")

func menu_button():
	get_tree().change_scene_to_file("res://Scenes/Menu.tscn")
