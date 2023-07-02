extends State

var dialogue = null

func onEnter(player: MainCharacter, delta: float):
	super.onEnter(player, delta)
	var dialogues = player.dialogueFinder.get_overlapping_areas()
	if dialogues.size() > 0:
		dialogue = dialogues[0]
	
	if dialogue != null:
		dialogue.startDialogue()
	
		
func onExit(delta: float):
	# Do nothing
	return

func check():
	if !dialogue.isRunning():
		return "IdleState"
	
	return null

func apply(delta):
	# Do nothing
	return
