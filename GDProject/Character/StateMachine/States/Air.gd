extends State

class_name AirState

func onEnter(player: MainCharacter, delta: float):
	super.onEnter(player, delta)
	
func onExit(_delta: float, transitionTo: String):
	if transitionTo == "JumpInstantState" or transitionTo == "JumpState":
		chara.isBunnyHopTimerActive = false
		chara.hasDoubleJumped = true
	elif transitionTo == "VaultState":
		chara.isBunnyHopTimerActive = false
		
func check():
	if chara.velocity.y <= 0:
		return "FallState"
	if chara.is_on_floor():
		return "RunState"
	if chara.execJumpAction and not chara.hasDoubleJumped:
		return "JumpInstantState" if chara.isJumpInstant else "JumpState"
	if chara.getVaultingDirection() != 0 and chara.vaultingDir == Input.get_axis("Left", "Right"):
		return "VaultState"
	return null

func apply(delta):
	if Input.is_action_just_pressed("Jump"):
		chara.isBunnyHopTimerActive = true
	chara.applyForce(chara.gravity * delta * Vector3.DOWN)
	var moveDir = Input.get_axis("Left", "Right")
	chara.applyHorizMovementAir(delta, moveDir)
