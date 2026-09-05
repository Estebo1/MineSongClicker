extends Node2D

@export var rock_scenes : Array[PackedScene]
@export var visible_rocks : int = 5 
@export var distance_between_rocks : float = 100.0 
@export var start_pos : Vector2 = Vector2.ZERO

var pools : Array = [] # Será un arreglo de arreglos (un pool por cada mineral)
var active_queue : Array = [] 

var minerals_data = [
	{"name": "MineralComun", "value": 1, "weight": 60, "scene_index": 0}, # 60%
	{"name": "MineralRaro",  "value": 2, "weight": 25, "scene_index": 1}, # 25%
	{"name": "MineralEpico", "value": 3, "weight": 10, "scene_index": 2}, # 10%
	{"name": "MineralPro","value": 5, "weight": 5,  "scene_index": 3}  # 5%
]
var total_weight = 100

func _ready() -> void:
	for i in range(rock_scenes.size()):
		pools.append([]) 
		
		for j in range(visible_rocks + 2):
			if rock_scenes[i] != null:
				var rock_instance = rock_scenes[i].instantiate()
				add_child(rock_instance)
				rock_instance.setup_mineral(minerals_data[i]["value"]) 
				pools[i].append(rock_instance)
	
	for i in range(visible_rocks):
		spawn_rock_at_end(i)

func get_random_mineral_index() -> int:
	var rand = randi() % total_weight
	var current_weight = 0
	
	for data in minerals_data:
		current_weight += data["weight"]
		if rand < current_weight:
			return data["scene_index"]
			
	return 0 

func spawn_rock_at_end(queue_index: int):
	var mineral_index = get_random_mineral_index()
	var selected_pool = pools[mineral_index] 
	var new_rock = null
	
	for rock in selected_pool:
		if not rock.isActive:
			new_rock = rock
			break
			
	if new_rock:
		var target_position = start_pos + Vector2(queue_index * distance_between_rocks, 0)
		new_rock.position = target_position
		new_rock.activate_rock()
		active_queue.append(new_rock)

func mine_first_rock():
	if active_queue.is_empty(): return
	
	var front_rock = active_queue.pop_front()
	var valor_obtenido = front_rock.mineral_value
	front_rock.destroy()
	shift_queue_left()
	spawn_rock_at_end(visible_rocks - 1)
	
	return valor_obtenido 

func shift_queue_left():
	for i in range(active_queue.size()):
		var rock = active_queue[i]
		var new_target_pos = start_pos + Vector2(i * distance_between_rocks, 0)
		rock.move_to(new_target_pos)
