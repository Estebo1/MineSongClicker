extends Area2D

@export var speed : float = 40
@export var collisionShape : CollisionShape2D
var isActive : bool = false

func _ready() -> void:
	DeactivateNote()

func _process(delta: float) -> void:
	position.y += speed * delta
	
	if position.y > 324:
		DeactivateNote()

func ActivateNote():
	isActive = true
	show()
	set_process(true)
	
	collisionShape.set_deferred("disabled", false)
	monitoring = true
	monitorable = true
	
func DeactivateNote():
	isActive = false
	hide()
	set_process(false)
	
	collisionShape.set_deferred("disabled", true)
	monitoring = false
	monitorable = false
	
