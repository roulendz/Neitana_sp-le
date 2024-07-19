extends Node

var cik_naudinas = 0
var cik_monstri_killed = 0

func pieskaitit_pacelto_naudinu():
	cik_naudinas = cik_naudinas + 1
	return cik_naudinas
	
	
func saskaitit_killed_monstrus():
	cik_monstri_killed = cik_monstri_killed + 1
	print("Pretinieki saplacināti: " + str(cik_monstri_killed)) 
	
