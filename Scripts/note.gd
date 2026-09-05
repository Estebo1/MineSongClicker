extends Area2D

@export var target_x : float = -279.0  
@export var spawn_x : float = -300.0  
@export var top_lane_y : float = 113.0 
@export var bottom_lane_y : float = 227.0 
@export var beats_en_pantalla : float = 4.0 

var speed = 0.0
var isActive = false
var hit = false
var direction = -1.0 

func _ready():
	DeactivateNote()

func _physics_process(delta):
	if not isActive: return 
	
	if not hit:
		global_position.x += direction * speed * delta
		
		var paso_de_largo = false
		if direction == -1.0 and global_position.x < target_x - 100:
			paso_de_largo = true
		elif direction == 1.0 and global_position.x > target_x + 100:
			paso_de_largo = true
			
		if paso_de_largo:
			var game = get_tree().current_scene 
			if game.has_method("reset_combo"):
				game.reset_combo() 
			DeactivateNote() 
	else:
		if has_node("Node2D"):
			$Node2D.position.y -= 100 * delta

func ActivateNote(lane: int):
	if has_node("Timer"): 
		$Timer.stop() 
	if has_node("CPUParticles2D"):
		$CPUParticles2D.emitting = false 
		
	hit = false
	isActive = true
	show()
	
	if has_node("Sprite2D"): 
		$Sprite2D.visible = true
	if has_node("CollisionShape2D"): 
		$CollisionShape2D.set_deferred("disabled", false)
	if has_node("Node2D/Label"): 
		$Node2D/Label.text = ""
	if has_node("Node2D"): 
		$Node2D.position = Vector2.ZERO 
		
	if lane == 0: 
		global_position = Vector2(spawn_x, top_lane_y)
	elif lane == 1: 
		global_position = Vector2(spawn_x, bottom_lane_y)
		
	var game = get_tree().current_scene
	var current_bpm = 100.0
	if game.has_node("Conductor"):
		current_bpm = game.conductor.bpm
		
	var sec_per_beat = 60.0 / current_bpm
	var time_to_reach = sec_per_beat * beats_en_pantalla
	
	speed = abs(target_x - spawn_x) / time_to_reach
	direction = 1.0 if target_x > spawn_x else -1.0

func destroy(score: int):
	hit = true
	if has_node("Sprite2D"): $Sprite2D.visible = false
	if has_node("CollisionShape2D"): $CollisionShape2D.set_deferred("disabled", true)
	if has_node("CPUParticles2D"):
		$CPUParticles2D.emitting = true
		$CPUParticles2D.restart() 
	if has_node("Node2D/Label"):
		if score == 3:
			$Node2D/Label.text = "Perfect"
			$Node2D/Label.modulate = Color("gold")
		elif score == 2:
			$Node2D/Label.text = "GOOD"
			$Node2D/Label.modulate = Color("green")
		elif score == 1:
			$Node2D/Label.text = "OKAY"
			$Node2D/Label.modulate = Color("blue")
		else:
			$Node2D/Label.text = "Failes"
			$Node2D/Label.modulate = Color("red")
	if has_node("Timer"): $Timer.start()

func _on_Timer_timeout():
	DeactivateNote()

func DeactivateNote():
	isActive = false
	hide()
	if has_node("CollisionShape2D"): $CollisionShape2D.set_deferred("disabled", true)
