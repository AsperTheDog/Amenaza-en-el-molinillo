extends Node

class_name State

var chara: MainCharacter = null

func onEnter(player: MainCharacter, delta: float):
	chara = player
	
func onExit(delta: float):
	pass

func check():
	pass

func apply(delta):
	pass


