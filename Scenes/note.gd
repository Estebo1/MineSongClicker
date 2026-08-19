extends Area2D

@export var speed : float = 1.0
@export var collisionShape : CollisionShape2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	DeactivateNote()
	pass	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position.y -= speed * delta
	
	if(position.y > 800):
		DeactivateNote()
	pass

func ActivateNote():
	show()
	set_process(true)
	
	collisionShape.set_deferred_thread_group("disabled", false)
	monitoring = true
	monitorable = true
	
func DeactivateNote():
	hide()
	set_process(false)
	
	collisionShape.set_deferred_thread_group("disabled",true)
	monitoring = false
	monitorable = false
	
