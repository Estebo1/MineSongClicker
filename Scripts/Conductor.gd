extends AudioStreamPlayer

@export var bpm := 100
@export var measures := 4
@export var note_pool: Node2D

var song_position = 0.0
var song_position_in_beats = 1
var sec_per_beat = 60.0 / bpm
var last_reported_beat = 0
var beats_before_start = 0
var measure_count = 1 

# Determining how close to the beat an event is
var closest = 0
var time_off_beat = 0.0

# Señales actualizadas
signal beat(position)
signal measure(position)

func _ready():
	sec_per_beat = 60.0 / bpm
	beat.connect(_on_conductor_beat)

func _physics_process(_delta):
	if playing:
		song_position = get_playback_position() + AudioServer.get_time_since_last_mix()
		song_position -= AudioServer.get_output_latency()
		song_position_in_beats = int(floor(song_position / sec_per_beat)) + beats_before_start
		_report_beat()

func _report_beat():
	if last_reported_beat < song_position_in_beats:
		if measure_count > measures:
			measure_count = 1
		beat.emit(song_position_in_beats)
		measure.emit(measure_count)
		last_reported_beat = song_position_in_beats
		measure_count += 1

func play_with_beat_offset(num):
	beats_before_start = num
	$StartTimer.wait_time = sec_per_beat
	$StartTimer.start()

func closest_beat(nth):
	closest = int(round((song_position / sec_per_beat) / nth) * nth)
	time_off_beat = abs(closest * sec_per_beat - song_position)
	return Vector2(closest, time_off_beat)

func play_from_beat(beat_num, offset):
	play()
	seek(beat_num * sec_per_beat)
	beats_before_start = offset
	measure_count = beat_num % measures

func _on_start_timer_timeout():
	song_position_in_beats += 1
	if song_position_in_beats < beats_before_start - 1:
		$StartTimer.start()
	elif song_position_in_beats == beats_before_start - 1:
		$StartTimer.wait_time = $StartTimer.wait_time - (AudioServer.get_time_to_next_mix() + AudioServer.get_output_latency())
		$StartTimer.start()
	else:
		play()
		$StartTimer.stop()
	_report_beat()

func _on_conductor_beat(posicion_beat: int) -> void:
	# Lanzamos una nota en un carril aleatorio (0, 1 o 2) para probar
	var carril_aleatorio = randi() % 3 
	note_pool.spawn_note(carril_aleatorio)

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		# Al hacer clic, lanza una nota en el carril de en medio (1)
		note_pool.spawn_note(1)
