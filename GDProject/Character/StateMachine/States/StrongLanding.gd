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
	chara.hasDoubleJumped = false
	
func onExit(_delta: float, transitionTo: String):
	if transitionTo == "IdleState":
		chara.executeAnimation("FallingFloorLongUp")
	elif transitionTo == "RunState":
		chara.executeAnimation("FallingFloorLongUp", chara.blendTime / 2, 1.5)

func check():
	if animationLength <= timer:
		return "IdleState"
	if chara.strongFallRecoveryTime <= timer and abs(chara.velocity.x) > 1 :
		return "RunState"
	if chara.justJumped():
		return "JumpInstantState" if chara.isJumpInstant else "JumpState"

func apply(delta):
	timer += delta
	if chara.strongFallRecoveryTime <= timer:
		var moveDir = chara.getMovingDir()
		chara.applyHorizMovement(delta, moveDir)
	else:
		chara.applyHorizMovement(delta, 0)
