extends State

class_name ThinkState

func onEnter(player: MainCharacter, delta: float):
	super.onEnter(player, delta)
	chara.executeAnimation("Think")
	chara.startedThinking.emit()
	
func onExit(delta: float, transitionTo: String):
	chara.stoppedThinking.emit()

func check():
	if not chara.isThinking():
		return "IdleState"

func apply(delta):
	chara.applyHorizMovement(delta, 0)
	chara.turnFront(delta)
