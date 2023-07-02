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
	
func onExit(delta: float):
	chara.animationPlayer.set_speed_scale(chara.animationSpeed)

func check():
	if chara.isBunnyHopTimerActive or Input.is_action_just_pressed("Jump"):
		chara.isBunnyHopTimerActive = false
		if chara.isJumpInstant:
			return "JumpInstantState"
		else:
			return "JumpState"
	if abs(chara.velocity.x) < 1:
		return "IdleState"
	if Input.get_axis("Left", "Right") != 0 and abs(Input.get_axis("Left", "Right")) < chara.walkingThreshold:
		return "WalkState"
	if not chara.is_on_floor():
		if chara.velocity.y <= 0:
			return "FallState"
		else:
			return "AirState"
	return null

func apply(delta):
	var moveDir = Input.get_axis("Left", "Right")
	chara.applyHorizMovement(delta, moveDir)
	if chara.animationPlayer.assigned_animation not in chara.landingAnimations:
		var speedDiff = 1 - (chara.runMaxSpeed - abs(chara.velocity.x)) / chara.runMaxSpeed
		chara.animationPlayer.set_speed_scale(lerp(0.0, chara.animationSpeed, speedDiff))
