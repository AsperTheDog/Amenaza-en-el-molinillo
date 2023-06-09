extends State

class_name FallState

func onEnter(player: MainCharacter, delta: float):
	super.onEnter(player, delta)
	chara.gravity = chara.defaultGravity
	if chara.animationPlayer.assigned_animation != "FallingJump":
		if chara.animationPlayer.assigned_animation == "JumpCorner":
			chara.queueAnimation("Jump")
		elif chara.animationPlayer.assigned_animation != "Jump":
			chara.executeAnimation("Jump")
	chara.gravity = chara.defaultGravity * chara.fallGravityMult
	chara.lastTopFallingSpeed = 0
	if Input.is_action_just_pressed("Jump"):
		chara.isBunnyHopTimerActive = true
	
func onExit(_delta: float, transitionTo: String):
	chara.gravity = chara.defaultGravity
	if transitionTo == "RunState":
		chara.fallParticles.restart()
		chara.fallParticles.emitting = true
		if chara.lastTopFallingSpeed >= chara.lightFallThreshold * chara.maxFallSpeed * Vector3.DOWN.y:
			chara.executeAnimation("FallingFloorNear" if abs(chara.velocity.x) < 3 else "FallingFloorNearRun")
		else:
			chara.executeAnimation("FallingFloor" if abs(chara.velocity.x) < 3 else "FallingFloorRun")
	elif transitionTo == "JumpInstantState" or transitionTo == "JumpState":
		chara.isBunnyHopTimerActive = false
		if chara.lastOnGround >= chara.coyoteTime:
			chara.hasDoubleJumped = true
	elif transitionTo == "VaultState":
		chara.isBunnyHopTimerActive = false
	elif transitionTo == "StrongLandState":
		chara.fallParticles.restart()
		chara.fallParticles.emitting = true
		
func check():
	if chara.is_on_floor():
		var strongFallSpeed = chara.strongFallThreshold * chara.maxFallSpeed * Vector3.DOWN.y
		return "StrongLandState" if chara.lastTopFallingSpeed <= strongFallSpeed else "RunState"
	if chara.execJumpAction and not chara.hasDoubleJumped:
		return "JumpInstantState" if chara.isJumpInstant else "JumpState"
	if chara.getVaultingDirection() != 0 and chara.vaultingDir == chara.getMovingDir():
		return "VaultState"
	return null

func apply(delta):
	chara.lastTopFallingSpeed = min(chara.velocity.y, chara.lastTopFallingSpeed)
	var fallingLongThreshold = (chara.maxFallSpeed * 0.8 * Vector3.DOWN).y
	if chara.animationPlayer.assigned_animation != "FallingJumpLong" and chara.velocity.y <= fallingLongThreshold:
		chara.executeAnimation("FallingJumpLong", -1, 3)
	if chara.justJumped():
		chara.isBunnyHopTimerActive = true
	if chara.execJumpAction and not chara.canDoubleJump:
		chara.isBunnyHopTimerActive = false
	chara.applyForce(chara.gravity * delta * Vector3.DOWN)
	var newForce = chara.velocity
	newForce.y = max(newForce.y, -chara.maxFallSpeed)
	chara.setForce(newForce)
	var moveDir = chara.getMovingDir()
	chara.applyHorizMovementAir(delta, moveDir)
