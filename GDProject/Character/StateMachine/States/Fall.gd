extends State

class_name FallState

func onEnter(player: MainCharacter, delta: float):
	super.onEnter(player, delta)
	chara.gravity = chara.defaultGravity
	if chara.animationPlayer.assigned_animation != "FallingJump":
		if chara.animationPlayer.assigned_animation == "JumpCorner":
			chara.queueAnimation("Jump")
		else:
			chara.executeAnimation("Jump")
	chara.gravity = chara.defaultGravity * chara.fallGravityMult
	chara.lastTopFallingSpeed = 0
	if Input.is_action_just_pressed("Jump"):
		chara.isBunnyHopTimerActive = true
	
func onExit(_delta: float, transitionTo: String):
	chara.gravity = chara.defaultGravity
	if transitionTo == "RunState":
		if chara.lastTopFallingSpeed >= chara.lightFallThreshold * chara.maxFallSpeed * Vector3.DOWN.y:
			if abs(chara.velocity.x) < 0.1:
				chara.executeAnimation("FallingFloorNear")
			else:
				chara.executeAnimation("FallingFloorNearRun")
		else:
			if abs(chara.velocity.x) < 0.1:
				chara.executeAnimation("FallingFloor")
			else:
				chara.executeAnimation("FallingFloorRun")
	elif transitionTo == "JumpInstantState" or transitionTo == "JumpState":
		chara.isBunnyHopTimerActive = false
		chara.hasDoubleJumped = true
	elif transitionTo == "VaultState":
		chara.isBunnyHopTimerActive = false

func check():
	if chara.is_on_floor():
		if chara.lastTopFallingSpeed <= chara.strongFallThreshold * chara.maxFallSpeed * Vector3.DOWN.y:
			return "StrongLandState"
		else:
			return "RunState"
	if chara.execJumpAction  and not chara.hasDoubleJumped:
		if chara.isJumpInstant:
			return "JumpInstantState"
		else:
			return "JumpState"
	if chara.getVaultingDirection() != 0 and chara.vaultingDir == Input.get_axis("Left", "Right"):
		return "VaultState"
	return null

func apply(delta):
	chara.lastTopFallingSpeed = min(chara.velocity.y, chara.lastTopFallingSpeed)
	var fallingLongThreshold = (chara.maxFallSpeed * 0.8 * Vector3.DOWN).y
	if chara.animationPlayer.assigned_animation != "FallingJumpLong" and chara.velocity.y <= fallingLongThreshold:
		chara.executeAnimation("FallingJumpLong", -1, 2)
	if Input.is_action_just_pressed("Jump"):
		chara.isBunnyHopTimerActive = true
	chara.applyForce(chara.gravity * delta * Vector3.DOWN)
	var newForce = chara.velocity
	newForce.y = max(newForce.y, -chara.maxFallSpeed)
	chara.setForce(newForce)
	var moveDir = Input.get_axis("Left", "Right")
	chara.applyHorizMovementAir(delta, moveDir)
