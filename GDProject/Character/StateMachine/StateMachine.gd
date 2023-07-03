extends Node

class_name StateMachine

@export var initialState = "IdleState"
var states = {}
var chara: MainCharacter = null

var activeState: State = null
var activeStateName = ""

func setup(player: MainCharacter):
	chara = player
	for st in self.get_children():
		states[st.name] = st
	activeState = states[initialState]
	activeState.onEnter(chara, 1)
	
func evaluate(delta):
	var ret = activeState.check()
	if ret != null:
		activeState.onExit(delta, ret)
		activeState = states[ret]
		activeStateName = ret
		activeState.onEnter(chara, delta)
	else:
		activeState.apply(delta)
