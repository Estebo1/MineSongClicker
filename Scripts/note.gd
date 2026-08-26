extends Area2D

@export var collisionShape : CollisionShape2D
var isActive : bool = false

const TARGET_X = 600 
const SPAWN_X = -10  
const DIST_TO_TARGET = TARGET_X - SPAWN_X

const TOP_LANE_SPAWN = Vector2(SPAWN_X, 200)
const BOTTOM_LANE_SPAWN = Vector2(SPAWN_X, 500)

var speed : float = 40.0

func _ready() -> void:
	DeactivateNote()

func _process(delta: float) -> void:
	position.x -= speed * delta
	if position.x <= -600: 
		DeactivateNote() 

func ActivateNote(lane: int):
	isActive = true
	show()
	$Sprite2D.visible = true
	if lane == 0:
		position = TOP_LANE_SPAWN
	elif lane == 1:
		position = BOTTOM_LANE_SPAWN
	
	speed = DIST_TO_TARGET / 2.0
	set_process(true)
	collisionShape.set_deferred("disabled", false)
	monitoring = true
	monitorable = true

func destroy(score: int):
	if score == 3:
		print("GREAT")
	elif score == 2:
		print("GOOD")
	elif score == 1:
		print("OKAY")
	DeactivateNote()

func DeactivateNote():
	isActive = false
	hide()
	set_process(false)
	
	collisionShape.set_deferred("disabled", true)
	monitoring = false
	monitorable = false
