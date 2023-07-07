extends State

class_name ThinkState

func onEnter(player: MainCharacter, delta: float):
	super.onEnter(player, delta)
	chara.executeAnimation("Think")
	chara.bubbleHidden = false
	
func onExit(delta: float, transitionTo: String):
	pass

func check():
	if chara.bubbleHidden:
		return "IdleState"

func apply(delta):
	chara.applyHorizMovement(delta, 0)
	chara.turnFront(delta)
	if not chara.isThinking():
		chara.stoppedThinking.emit()
	if chara.justThought():
		chara.startedThinking.emit()
	
