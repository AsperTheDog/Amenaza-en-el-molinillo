extends State

class_name JumpStateRo

var anticTime = 0
var afterAnticTime = 0
var jumped = false

func onEnter(player: MainCharacter, delta: float):
	super.onEnter(player, delta)
	jumped = false
	anticTime = 0
	chara.gravity = chara.defaultGravity
	var isDoubleJump = not chara.hasDoubleJumped and chara.canDoubleJump
	chara.executeAnimation("JumpDouble" if not isDoubleJump else "JumpAntic")
	chara.queueAnimation("Jump", false)
	chara.jumpParticles.emitting = true
	
func onExit(_delta: float, transitionTo: String):
	if transitionTo == "AirState":
		chara.gravity *= chara.jumpCutGravityMult

func check():
	if jumped:
		if chara.velocity.y <= 0:
			return "FallState"
		if not chara.isJumping() and afterAnticTime > 0.05:
			return "AirState"
	if chara.getVaultingDirection() != 0 and chara.vaultingDir == chara.getMovingDir():
		return "VaultState"
	return null

func apply(delta):
	anticTime += delta
	afterAnticTime += delta
	var moveDir = Input.get_axis("Left", "Right")
	if jumped:
		chara.applyForce(chara.gravity * delta * Vector3.DOWN)
		chara.applyHorizMovementAir(delta, moveDir)
	else:
		if anticTime > 0.1:
			afterAnticTime = 0
			jumped = true
			chara.setVertForce((chara.jumpSpeed * Vector3.UP).y)
		else:
			chara.applyHorizMovement(delta, moveDir)
