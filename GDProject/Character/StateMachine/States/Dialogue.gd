extends State

class_name DialogueState

var dialogue = null

func onEnter(player: MainCharacter, delta: float):
	super.onEnter(player, delta)
	var dialogues = player.dialogueFinder.get_overlapping_areas()
	if dialogues.size() > 0:
		dialogue = dialogues[0]
	
	if dialogue != null:
		dialogue.startDialogue()
	
func onExit(_delta: float, _transitionTo: String):
	
	return

func check():
	if dialogue.stoppedDialogue():
		return "IdleState"
	return null

func apply(delta):
	chara.applyHorizMovement(delta, 0)
	return
