extends Label

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	self.text = str(GameManager.cik_naudinas)
