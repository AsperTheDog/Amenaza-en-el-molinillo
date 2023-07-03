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
	chara.setVertForce((chara.jumpSpeed * Vector3.UP).y)
	chara.jumpParticles.emitting = true
	
func onExit(_delta: float, transitionTo: String):
	if transitionTo == "AirState":
		chara.gravity *= chara.jumpCutGravityMult

func check():
	if chara.velocity.y <= 0:
		return "FallState"
	if not Input.is_action_pressed("Jump"):
		return "AirState"
	if chara.getVaultingDirection() != 0 and chara.vaultingDir == Input.get_axis("Left", "Right"):
		return "VaultState"
	return null

func apply(delta):
	var moveDir = Input.get_axis("Left", "Right")
	chara.applyForce(chara.gravity * delta * Vector3.DOWN)
	chara.applyHorizMovement(delta, moveDir)
