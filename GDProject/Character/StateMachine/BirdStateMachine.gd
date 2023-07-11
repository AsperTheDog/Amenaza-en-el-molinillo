extends Node

class_name BirdStateMachine

@export var initialState = "IdleState"
var states = {}
var chara: Bird = null

var activeState: BirdState = null
var activeStateName = ""
var frozen = false

func setup(player: Bird):
	chara = player
	for st in self.get_children():
		states[st.name] = st
	activeState = states[initialState]
	activeState.onEnter(chara, 1)
	
func evaluate(delta: float):
	if frozen:
		return
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
	
func freeze():
	frozen = true
