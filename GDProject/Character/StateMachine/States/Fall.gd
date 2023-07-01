extends State

class_name FallState

func onEnter(player: MainCharacter, delta: float):
	super.onEnter(player, delta)
	chara.gravity = chara.defaultGravity
	if chara.animationPlayer.assigned_animation != "FallingJump":
		if chara.animationPlayer.assigned_animation == "JumpCorner":
			chara.animationPlayer.clear_queue()
			chara.animationPlayer.queue("Jump")
		else:
			chara.animationPlayer.play("Jump")
	chara.gravity = chara.defaultGravity * chara.fallGravityMult
	chara.lastTopFallingSpeed = 0
	if Input.is_action_just_pressed("Jump"):
		chara.isBunnyHopTimerActive = true
	
	
func onExit(delta: float):
	chara.gravity = chara.defaultGravity

func check():
	if chara.is_on_floor():
		if chara.lastTopFallingSpeed >= chara.lightFallThreshold * chara.maxFallSpeed * Vector3.DOWN.y:
			chara.animationPlayer.play("FallingFloorNear")
		elif chara.lastTopFallingSpeed > chara.strongFallThreshold * chara.maxFallSpeed * Vector3.DOWN.y:
			chara.animationPlayer.play("FallingFloor")
		else:
			return "StrongLandState"
		return "RunState"
	if chara.execJumpAction:
		chara.isBunnyHopTimerActive = false
		if not chara.hasDoubleJumped:
			chara.hasDoubleJumped = true
			return "JumpState"
	if chara.getVaultingDirection() != 0 and chara.vaultingDir == Input.get_axis("Left", "Right"):
		chara.isBunnyHopTimerActive = false
		return "VaultState"
	return null

func apply(delta):
	chara.lastTopFallingSpeed = min(chara.velocity.y, chara.lastTopFallingSpeed)
	var fallingLongThreshold = (chara.maxFallSpeed * 0.6 * Vector3.DOWN).y
	if chara.animationPlayer.assigned_animation != "FallingJumpLong" and chara.velocity.y <= fallingLongThreshold:
		chara.animationPlayer.play("FallingJumpLong", -1, 2)
	if Input.is_action_just_pressed("Jump"):
		chara.isBunnyHopTimerActive = true
	chara.applyForce(chara.gravity * delta * Vector3.DOWN)
	var newForce = chara.velocity
	newForce.y = max(newForce.y, -chara.maxFallSpeed)
	chara.setForce(newForce)
	var moveDir = Input.get_axis("Left", "Right")
	chara.applyHorizMovementAir(delta, moveDir)
