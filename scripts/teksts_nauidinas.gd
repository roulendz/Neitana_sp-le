extends Label

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	self.text = "Naudiņas: " + str(GameManager.cik_naudinas)
