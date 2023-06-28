extends State

class_name AirState

func onEnter(player: MainCharacter, delta: float):
	super.onEnter(player, delta)
	chara.animationPlayer.play("FallingJump Ro")
	
func onExit(delta: float):
	pass

func check():
	if chara.velocity.y <= 0:
		return "FallState"
	if chara.is_on_floor():
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
	chara.applyForce(chara.gravity * delta * Vector3.DOWN)
	chara.applyHorizMovementAir(delta)
	chara.getVaultingDirection()
