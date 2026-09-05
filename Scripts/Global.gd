extends Node2D

var minerales : float = 0 
var picos : int = 1 
var combo = 0
var max_combo = 0
var vidas = 1
var vidas_maximas = 1
var mineral_multiplier = 1

var vidas_Upgrade : int = 0
var mineral_Upgrade : int = 0
var picos_Upgrade : int = 0

var vidas_cost : float = 1
var picos_cost : float = 1
var mineral_cost : float = 1

func resetear_estadisticas():
	combo = 0
	mineral_multiplier = 1 + mineral_Upgrade
	picos = 1 + picos_Upgrade
	vidas_maximas = 1 + vidas_Upgrade
	vidas = vidas_maximas
	
