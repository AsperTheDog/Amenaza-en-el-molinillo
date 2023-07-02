extends State

class_name StrongLandState

var timer = 0
var animationLength: float = 0;

func onEnter(player: MainCharacter, delta: float):
	super.onEnter(player, delta)
	chara.executeAnimation("FallingFloorLong")
	animationLength = chara.animationPlayer.current_animation_length / chara.animationSpeed
	timer = 0
	chara.isBunnyHopTimerActive = false
	
func onExit(delta: float):
	pass

func check():
	if animationLength <= timer:
		chara.executeAnimation("FallingFloorLongUp")
		return "IdleState"
	if chara.strongFallRecoveryTime <= timer and abs(chara.velocity.x) > 0.1 :
		chara.executeAnimation("FallingFloorLongUp", chara.blendTime / 2, 1.5)
		return "RunState"

func apply(delta):
	timer += delta
	if chara.strongFallRecoveryTime <= timer:
		var moveDir = Input.get_axis("Left", "Right")
		chara.applyHorizMovement(delta, moveDir)
	else:
		chara.applyHorizMovement(delta, 0)
