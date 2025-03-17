extends Node


var globalScore: int = 0  # Persistent score variable

func add_score(amount: int):
	globalScore += amount
	print("Score: ", globalScore)  # Debugging

func reset_score():
	if globalScore > Saveload.highest_record:
		Saveload.highest_record = globalScore
	Saveload.save_score()
	globalScore = 0
