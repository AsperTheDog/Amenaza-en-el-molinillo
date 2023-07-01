extends State

class_name AirState

func onEnter(player: MainCharacter, delta: float):
	super.onEnter(player, delta)
	
func onExit(delta: float):
	pass

func check():
	if chara.velocity.y <= 0:
		return "FallState"
	if chara.is_on_floor():
		return "RunState"
	if chara.execJumpAction and not chara.hasDoubleJumped:
		chara.isBunnyHopTimerActive = false
		chara.hasDoubleJumped = true
		if chara.isJumpInstant:
			return "JumpInstantState"
		else:
			return "JumpState"
	if chara.getVaultingDirection() != 0 and chara.vaultingDir == Input.get_axis("Left", "Right"):
		chara.isBunnyHopTimerActive = false
		return "VaultState"
	return null

func apply(delta):
	if Input.is_action_just_pressed("Jump"):
		chara.isBunnyHopTimerActive = true
	chara.applyForce(chara.gravity * delta * Vector3.DOWN)
	var moveDir = Input.get_axis("Left", "Right")
	chara.applyHorizMovementAir(delta, moveDir)
