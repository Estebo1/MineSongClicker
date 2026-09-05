extends Node2D

enum TypeGiver{
	MINERAL, 
	PICO,
	VIDA
}

@export var cost: float = 1
@onready var cost_label: Label = $Button/Label
@onready var mineral_label: Label = $"../Minerals"
@onready var add_button: Button = $Button

@export var typeGiver: TypeGiver

var upgradesArray: Array[Sprite2D] = []

func _ready() -> void:
	for i in range(1, 10):
		upgradesArray.append(get_node(str(i)))
		
	if typeGiver == TypeGiver.MINERAL: 
		cost = Global.mineral_cost
		turn_mineral()
		pass
	if typeGiver == TypeGiver.PICO:
		cost = Global.picos_cost
		turn_pico()
		pass
	if typeGiver == TypeGiver.VIDA:
		cost = Global.vidas_cost
		turn_vida()
		pass
	
func turn_pico():
	cost_label.text = "Minerals: " + str(Global.picos_cost)
	for i in range(1, 10):
		if Global.picos_Upgrade >= i:
			upgradesArray[i -1].self_modulate = Color(255,255,255,255)
func turn_vida():
	cost_label.text = "Minerals: " + str(Global.vidas_cost)
	for i in range(1, 10):
		if Global.vidas_Upgrade >= i:
			upgradesArray[i -1].self_modulate = Color(255,255,255,255)
func turn_mineral():
	cost_label.text = "Minerals: " + str(Global.mineral_cost)
	for i in range(1, 10):
		if Global.mineral_Upgrade >= i:
			upgradesArray[i -1].self_modulate = Color(255,255,255,255)

func button_add():
	if add_button and Global.minerales >= cost:
		Global.minerales -= cost
		
		if typeGiver == TypeGiver.MINERAL: 
			Global.mineral_cost *= 2 
			cost = Global.mineral_cost
			Global.mineral_Upgrade += 1
			Global.mineral_multiplier += .02
			Global.resetear_estadisticas()
			turn_mineral()
			
		if typeGiver == TypeGiver.PICO:
			Global.picos_cost *= 2 
			cost = Global.picos_cost
			Global.picos_Upgrade += 1
			Global.resetear_estadisticas()
			turn_pico()
		
		if typeGiver == TypeGiver.VIDA:
			Global.vidas_cost *= 2 
			cost = Global.vidas_cost
			Global.vidas_Upgrade += 1
			Global.resetear_estadisticas()
			turn_vida()
		mineral_label.text = "Minerals: " + str(Global.minerales)
		
		
		
		
		
		
	
