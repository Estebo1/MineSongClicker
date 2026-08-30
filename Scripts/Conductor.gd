extends AudioStreamPlayer

@export var bpm := 100
@export var measures := 4

var song_position = 0.0
var song_position_in_beats = 1
var sec_per_beat = 60.0 / bpm
var last_reported_beat = 0
var beats_before_start = 0
var measure = 1

signal beat(position)
signal measure_changed(current_measure)

func _ready():
	sec_per_beat = 60.0 / bpm

func _physics_process(_delta):
	if playing:
		song_position = get_playback_position() + AudioServer.get_time_since_last_mix()
		song_position -= AudioServer.get_output_latency()
		song_position_in_beats = int(floor(song_position / sec_per_beat)) + beats_before_start
		_report_beat()

func _report_beat():
	if last_reported_beat < song_position_in_beats:
		if measure > measures:
			measure = 1
		beat.emit(song_position_in_beats)
		measure_changed.emit(measure) 
		last_reported_beat = song_position_in_beats
		measure += 1

func play_with_beat_offset(num):
	song_position = 0.0
	song_position_in_beats = 1
	last_reported_beat = 0
	measure = 1
	sec_per_beat = 60.0 / bpm
	beats_before_start = num
	$StartTimer.wait_time = sec_per_beat
	$StartTimer.start()

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
