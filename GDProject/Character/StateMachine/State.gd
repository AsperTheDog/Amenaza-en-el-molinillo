extends Node

class_name State

var chara: MainCharacter = null

func onEnter(player: MainCharacter, _delta: float):
	chara = player
	
func onExit(_delta: float, _transitionTo: String):
	pass

func check():
	pass

func apply(_delta):
	pass


