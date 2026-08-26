extends Node2D

var perfect = false
var good = false
var okay = false
var current_note = null

@export var input_action: String = ""

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed(input_action):
		if current_note != null:
			if perfect:
				print("Perfecta")
			elif good:
				print("Bien")
			elif okay:
				print("Okay")
			
			current_note.DeactivateNote()
			_reset()

func _on_perfect_area_area_entered(area: Area2D) -> void:
	perfect = true

func _on_perfect_area_area_exited(area: Area2D) -> void:
	perfect = false

func _on_good_area_area_entered(area: Area2D) -> void:
	good = true

func _on_good_area_area_exited(area: Area2D) -> void:
	good = false

func _on_okay_area_area_entered(area: Area2D) -> void:
	okay = true
	current_note = area

func _on_okay_area_area_exited(area: Area2D) -> void:
	okay = false
	if current_note == area:
		aplicar_fail()
		current_note.DeactivateNote()
		_reset()

func aplicar_fail() -> void:
	print("Fail")

func _reset() -> void:
	current_note = null
	perfect = false
	good = false
	okay = false
