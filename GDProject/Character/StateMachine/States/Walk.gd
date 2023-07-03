extends State

class_name WalkState

func onEnter(player: MainCharacter, delta: float):
	super.onEnter(player, delta)
	if chara.animationPlayer.assigned_animation in chara.landingAnimations:
		chara.queueAnimation("Walk")
	else:
		if chara.animationPlayer.assigned_animation in chara.movingAnimations:
			chara.executeAnimation("Walk", chara.slowBlendTime)
		else:
			chara.executeAnimation("Walk")
	
func onExit(delta: float, transitionTo: String):
	chara.animationPlayer.set_speed_scale(chara.animationSpeed)
	if transitionTo == "JumpState" or transitionTo == "JumpInstantState":
		chara.isBunnyHopTimerActive = false
		

func check():
	if chara.isBunnyHopTimerActive or Input.is_action_just_pressed("Jump"):
		if chara.isJumpInstant:
			return "JumpInstantState"
		else:
			return "JumpState"
	if abs(chara.velocity.x) < 1:
		return "IdleState"
	if abs(Input.get_axis("Left", "Right")) >= chara.walkingThreshold:
		return "RunState"
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
		var speedDiff = 1 - ((chara.walkingThreshold * chara.runMaxSpeed) - abs(chara.velocity.x)) / (chara.walkingThreshold * chara.runMaxSpeed)
		chara.animationPlayer.set_speed_scale(lerp(0.0, chara.animationSpeed, speedDiff))
