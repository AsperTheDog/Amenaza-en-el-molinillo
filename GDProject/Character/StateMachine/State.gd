extends Node

class_name State

var chara: MainCharacter = null

func onEnter(player: MainCharacter, _delta: float):
	chara = player
	
func onExit(delta: float, transitionTo: String):
	pass

func check():
	pass

func apply(delta):
	pass


