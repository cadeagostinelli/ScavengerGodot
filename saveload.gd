extends Node

const SAVEFILE = "user://savefile.save"

var highest_record = 0

func _ready():
	load_score()# Called when the node enters the scene tree for the first time.
	
func save_score():
	var file = FileAccess.open(SAVEFILE, FileAccess.WRITE_READ)
	file.store_32(highest_record)
	
func load_score():
	var file = FileAccess.open(SAVEFILE, FileAccess.READ)
	if FileAccess.file_exists(SAVEFILE):
		highest_record = file.get_32()
