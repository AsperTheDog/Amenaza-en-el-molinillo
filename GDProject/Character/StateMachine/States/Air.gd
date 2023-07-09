extends State

class_name AirState

func onEnter(player: MainCharacter, delta: float):
	super.onEnter(player, delta)
	if chara.animationPlayer.assigned_animation != "Jump":
		chara.executeAnimation("Jump")
	
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
	if chara.getVaultingDirection() != 0 and chara.vaultingDir == chara.getMovingDir():
		return "VaultState"
	return null

func apply(delta):
	if chara.justJumped():
		chara.isBunnyHopTimerActive = true
	chara.applyForce(chara.gravity * delta * Vector3.DOWN)
	var moveDir = chara.getMovingDir()
	chara.applyHorizMovementAir(delta, moveDir)
