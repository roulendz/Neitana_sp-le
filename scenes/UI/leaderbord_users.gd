extends PanelContainer

var _name = "Name"
var _coins = 0
var _enemies = 0
var _time = "00:00:00"
@onready var username = $MarginContainer/GridContainer/Username
@onready var coins = $MarginContainer/GridContainer/GridContainer2/Coins
@onready var enemies = $MarginContainer/GridContainer/GridContainer/Enemies
@onready var time = $MarginContainer/GridContainer/GridContainer3/Time

# Called when the node enters the scene tree for the first time.
func _ready():
	modulate.a = 0
	var t = create_tween().set_trans(Tween.TRANS_QUAD)
	t.tween_property(self, "modulate:a",1,0.25)
	# Update UI elements
	update_ui()

func update_ui():
	username.text = _name
	coins.text = str(_coins)  # Convert to string
	enemies.text = str(_enemies) # Convert to string
	time.text = _time 

