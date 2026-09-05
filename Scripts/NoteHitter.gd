extends Area2D 

var current_note = null
@export var input_action: String = ""

@export var perfect_dist: float = 5.0
@export var good_dist: float = 30.0
@export var okay_dist: float = 50.0

@onready var game = get_tree().current_scene 
@onready var animation_player: AnimationPlayer = $AnimationNote

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed(input_action):
		
		if current_note != null:
			if not is_instance_valid(current_note) or not current_note.isActive:
				current_note = null
				game.increment_score(0)
				return
				
			var dist = abs(current_note.global_position.x - global_position.x)
			
			if dist <= perfect_dist:
				print("Resultado: PERFECT")
				game.increment_score(3)
				current_note.destroy(3)
				play_note_animation("PerfectNote")
			elif dist <= good_dist:
				print("Resultado: GOOD")
				game.increment_score(2)
				current_note.destroy(2)
				play_note_animation("PerfectNote")

			elif dist <= okay_dist:
				print("Resultado: OKAY")
				game.increment_score(1)
				current_note.destroy(1)
				play_note_animation("PerfectNote")

			else:
				print("Resultado: FAIL - Distancia muy grande")
				play_note_animation("FailedNote")
				game.increment_score(0)
				
			current_note = null
		else:
			print("Fallo: La tecla se presionó pero 'current_note' está vacío (nulo).")
			game.increment_score(0)
			play_note_animation("FailedNote")
func _on_okay_area_entered(area: Area2D) -> void:
	if area.is_in_group("note"):
		current_note = area
		print("La nota entro del Hitter")


func _on_okay_area_exited(area: Area2D) -> void:
	if area.is_in_group("note") and current_note == area:
		print("La nota salio del Hitter")
		current_note = null

func play_note_animation(animation_name: String) -> void:
	animation_player.play(animation_name)
	await animation_player.animation_finished
	animation_player.play("RESET")
