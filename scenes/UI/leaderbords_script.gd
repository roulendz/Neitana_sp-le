extends Control
@onready var scroll_container = $PanelContainer/MarginContainer/ScrollContainer

var user_panel = preload("res://scenes/UI/leaderbord_users.tscn")
var client = HTTPClient.new()
const url_submit = "https://docs.google.com/forms/u/0/d/e/1FAIpQLSfyks0tzrG5NVp2s25sPukDLJ1PLRBVoQRVV4TKSqV7SEmWHA/formResponse"
const url_data = "https://docs.google.com/spreadsheets/d/1JB4XM-UhPzvHj1qv43uJy-umZAW5XBCaG4yf5MT466I/gviz/tq"
const headers = ["Content-Type: application/x-www-form-urlencoded"]



var first_occurance = []

func http_done(_result, _response_code, headers, _body, http):
	$ButtonPanel/GridContainer/Button_Add.modulate.a = 1
	http.queue_free()
	if !_result:
		first_occurance = []
		get_tree().call_group("user", "queue_free")
		var data = _body.get_string_from_utf8()
		data = data.substr(data.find("rows\":")+6)
		data = data.substr(0,data.find(",\"parsedNumHeaders\""))
		var json = JSON.parse(data).result
		for n in json:
			var _name =n["c"][1]["v"]
			if !first_occurance.has(_name):
				first_occurance.append(_name)
				var new_user = user_panel.instance()
				new_user._name = _name
				new_user._coins = str(n["c"][2]["v"])
				new_user._enemies = str(n["c"][3]["v"])
				new_user._time = str(n["c"][4]["v"])
				$PanelContainer/MarginContainer/ScrollContainer/GridContainer.add_child(new_user)
func press_update():
	var http = HTTPRequest.new()
	http.connect("request_compleated", Callable(self, "http_done"))
	add_child(http)
	
	var err = http.request(url_data,headers,HTTPClient.METHOD_GET)
	if err:
		$ButtonPanel/GridContainer/Button_Update.modulate.a = 1
		http.queue_free()
	else:
		print("Goood data loaded!")
	pass
					
func _ready():
	pass




	pass
func http_submit(_result, _response_code, _headers, _body, http):
	http.queue_free()
	pass
	
func press_add():
	var http = HTTPRequest.new()
	http.connect("request_compleated", Callable(self, "http_submit"))

	add_child(http)
	var user_data = client.query_string_from_dict({
		"entry.780827909": "Rolands",
		"entry.1249995732": "10",
		"entry.1198867739": "9",
		"entry.189500855": "01:03:24"
	})
	var err = http.request(url_submit,headers,HTTPClient.METHOD_POST,user_data)
	if err:
		http.queue_free()
	else:
		print("Goood submited!")
	pass
	
#entry.780827909: Rockbabee
#entry.1249995732: 21
#entry.1198867739: 92
#entry.189500855: 01:23:21
# Called when the node enters the scene tree for the first time.
