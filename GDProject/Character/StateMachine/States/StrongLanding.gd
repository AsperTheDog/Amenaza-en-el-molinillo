extends State

class_name StrongLandState

const recoveryThreshold = 1
var timer = 0
var animationLength: float = 0;

func onEnter(player: MainCharacter, delta: float):
	super.onEnter(player, delta)
	chara.animationPlayer.play("FallingFloor")
	animationLength = chara.animationPlayer.current_animation_length / chara.animationSpeed
	timer = 0
	chara.isBunnyHopTimerActive = false
	
func onExit(delta: float):
	pass

func check():
	if animationLength <= timer:
		return "IdleState"

func apply(delta):
	timer += delta
	chara.applyHorizMovement(delta, 0)
