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
	
func evaluate(delta: float):
	var ret = activeState.check()
	if ret != null:
		transition(ret, delta)
	else:
		activeState.apply(delta)

func transition(state: String, delta: float):
	activeState.onExit(delta, state)
	activeState = states[state]
	activeStateName = state
	activeState.onEnter(chara, delta)
	activeState.apply(delta)
	
