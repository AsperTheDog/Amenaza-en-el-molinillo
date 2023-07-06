extends State

class_name JumpInstantRoState

func onEnter(player: MainCharacter, delta: float):
	super.onEnter(player, delta)
	chara.gravity = chara.defaultGravity
	if chara.hasDoubleJumped and chara.canDoubleJump:
		chara.executeAnimation("JumpDouble")
		chara.queueAnimation("Jump", false)
	else:
		chara.executeAnimation("Jump")
		chara.jumpParticles.restart()
		chara.jumpParticles.emitting = true
	chara.setVertForce((chara.jumpSpeed * Vector3.UP).y)
	
func onExit(_delta: float, transitionTo: String):
	if transitionTo == "AirState":
		chara.gravity *= chara.jumpCutGravityMult

func check():
	if chara.velocity.y <= 0:
		return "FallState"
	if not chara.isJumping():
		return "AirState"
	if chara.getVaultingDirection() != 0 and chara.vaultingDir == chara.getMovingDir():
		return "VaultState"
	return null

func apply(delta):
	var moveDir = chara.getMovingDir()
	chara.applyForce(chara.gravity * delta * Vector3.DOWN)
	chara.applyHorizMovement(delta, moveDir)
