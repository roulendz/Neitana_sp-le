extends Node

var game_start_time = Time.get_ticks_msec()
var elapsed_time = 0

var cik_naudinas = 0
var cik_monstri_killed = 0
func pieskaitit_pacelto_naudinu():
	cik_naudinas = cik_naudinas + 1
	return cik_naudinas
	
	
func saskaitit_killed_monstrus():
	cik_monstri_killed = cik_monstri_killed + 1
	
func getTime():
	var elapsed_time = Time.get_ticks_msec() - game_start_time

	# Calculate minutes as an integer
	var minutes = int(elapsed_time / 60000) 

	# Calculate seconds as an integer
	var seconds = int((elapsed_time % 60000) / 1000)

	# Calculate deciseconds as an integer (tenths of a second)
	var deciseconds = int((elapsed_time % 1000) / 100)

	# Formatting with leading zeros
	var formatted_minutes = "0" + str(minutes) if minutes < 10 else str(minutes)
	var formatted_seconds = "0" + str(seconds) if seconds < 10 else str(seconds)
	var formatted_deciseconds = "0" + str(deciseconds) if deciseconds < 10 else str(deciseconds)

	return formatted_minutes + ":" + formatted_seconds + ":" + formatted_deciseconds



