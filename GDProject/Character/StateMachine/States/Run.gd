extends State

class_name RunState

func onEnter(player: MainCharacter, delta: float):
	super.onEnter(player, delta)
	if chara.canDoubleJump:
		chara.hasDoubleJumped = false
	if chara.animationPlayer.assigned_animation in chara.landingAnimations:
		chara.queueAnimation("Run")
	else:
		chara.executeAnimation("Run")
	
func onExit(_delta: float, transitionTo: String):
	chara.animationPlayer.set_speed_scale(chara.animationSpeed)
	if transitionTo == "JumpState" or transitionTo == "JumpInstantState":
		chara.isBunnyHopTimerActive = false
	chara.runParticles.emitting = false

func check():
	if chara.isBunnyHopTimerActive or chara.justJumped():
		return "JumpInstantState" if chara.isJumpInstant else "JumpState"
	if abs(chara.velocity.x) < 1:
		return "IdleState"
	if chara.getMovingDir() != 0 and abs(chara.getMovingDir()) < chara.walkingThreshold:
		return "WalkState"
	if not chara.is_on_floor():
		return "FallState" if chara.velocity.y <= 0 else "AirState"
	if Input.is_action_just_pressed("Punch"):
		return "PunchGroundState"
	if chara.isThinking():
		return "ThinkState"
	return null

func apply(delta):
	var moveDir = chara.getMovingDir()
	chara.applyHorizMovement(delta, moveDir)
	if chara.animationPlayer.assigned_animation not in chara.landingAnimations:
		var speedDiff = 1 - (chara.runMaxSpeed - abs(chara.velocity.x)) / chara.runMaxSpeed
		chara.animationPlayer.set_speed_scale(lerp(0.0, chara.animationSpeed * 1.4, speedDiff))
	if abs(chara.velocity.x) > 6:
		chara.runParticles.emitting = true
	else:
		chara.runParticles.emitting = false
