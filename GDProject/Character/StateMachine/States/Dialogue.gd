extends State

class_name DialogueState

var closest = null

func onEnter(player: MainCharacter, delta: float):
	super.onEnter(player, delta)
	var dialogues = player.dialogueFinder.get_overlapping_areas()
	var charaPos = chara.global_position
	for dialogue in dialogues:
		if closest == null:
			closest = dialogue
			continue
		var closestPos = closest.global_position
		var diagPos = dialogue.global_position
		if charaPos.distance_squared_to(closestPos) > charaPos.distance_squared_to(diagPos):
			closest = dialogue
	closest.startDialogue()
	
func onExit(_delta: float, _transitionTo: String):
	pass

func check():
	if closest.stoppedDialogue():
		return "IdleState"
	return null

func apply(delta):
	chara.applyHorizMovement(delta, 0)
	return
