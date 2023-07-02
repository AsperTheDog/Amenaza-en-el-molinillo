extends State

var dialogueRunning: bool = false
var dialogue = null

func onEnter(player: MainCharacter, delta: float):
	super.onEnter(player, delta)
	var dialogues = player.dialogueFinder.get_overlapping_areas()
	if dialogues.size() > 0:
		dialogue = dialogues[0]
	
	if dialogue != null:
		dialogue.startDialogue
		dialogueRunning = true
	
		
func onExit(delta: float):
	# Do nothing
	return

func check():
	if dialogue.isRunning():
		return "DialogueState"
	else:
		return "IdleState"

func apply(delta):
	# Do nothing
	return
