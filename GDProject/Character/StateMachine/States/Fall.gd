extends State

class_name FallState

func onEnter(player: MainCharacter, delta: float):
	super.onEnter(player, delta)
	chara.gravity = chara.defaultGravity
	if chara.animationPlayer.assigned_animation != "FallingJump Ro":
		if chara.animationPlayer.assigned_animation == "Jump Corner Ro":
			chara.animationPlayer.clear_queue()
			chara.animationPlayer.queue("FallingJump Ro")
		else:
			chara.animationPlayer.play("FallingJump Ro")
	
	
func onExit(delta: float):
	pass

func check():
	if chara.is_on_floor():
		chara.animationPlayer.play("FallingFloor Ro")
		return "RunState"
	if Input.is_action_just_pressed("Jump") and not chara.hasDoubleJumped:
		chara.hasDoubleJumped = true
		return "JumpState"
	if chara.getVaultingDirection() != 0:
		if chara.vaultingDir == 1 and Input.is_action_pressed("Right"):
			return "VaultState"
		if chara.vaultingDir == -1 and Input.is_action_pressed("Left"):
			return "VaultState"
	return null

func apply(delta):
	chara.applyForce(chara.gravity * chara.fallGravityMult * delta * Vector3.DOWN)
	var newForce = chara.velocity
	newForce.y = max(newForce.y, -chara.maxFallSpeed)
	chara.setForce(newForce)
	chara.applyHorizMovementAir(delta)
