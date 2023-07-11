extends Node
class_name BirdState

var chara: Bird = null

func onEnter(player: Bird, _delta: float):
	chara = player
	
func onExit(_delta: float, _transitionTo: String):
	pass

func check():
	pass

func apply(_delta):
	pass
