extends Node2D

var mineral_value : int = 0
var isActive = false
var hit = false

func _ready():
	deactivate_rock()

func setup_mineral(val: int):
	mineral_value = val

func activate_rock():
	hit = false
	isActive = true
	show()
	
	if has_node("Sprite2D"): $Sprite2D.visible = true
	if has_node("CollisionShape2D"): $CollisionShape2D.set_deferred("disabled", false)
	if has_node("Node2D"): $Node2D.position = Vector2.ZERO

func move_to(target_pos: Vector2):
	if hit: return
	var tween = create_tween()
	tween.tween_property(self, "position", target_pos, 0.2).set_trans(Tween.TRANS_SINE)

func destroy():
	hit = true
	if has_node("Sprite2D"): $Sprite2D.visible = false
	if has_node("CollisionShape2D"): $CollisionShape2D.set_deferred("disabled", true)
	
	if has_node("CPUParticles2D"):
		$CPUParticles2D.emitting = true
		$CPUParticles2D.restart()
		
	await get_tree().create_timer(1.0).timeout
	deactivate_rock()

func deactivate_rock():
	isActive = false
	hide()
	if has_node("CollisionShape2D"): $CollisionShape2D.set_deferred("disabled", true)
