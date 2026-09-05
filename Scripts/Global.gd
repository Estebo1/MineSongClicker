extends Node2D

var minerales : float = 0 
var combo = 0
var max_combo = 0
var vidas = 3
var vidas_maximas = 3

func resetear_estadisticas():
	combo = 0
	max_combo = 0
	vidas = vidas_maximas
