extends State

class_name JumpState

var anticTime = 0
var afterAnticTime = 0
var jumped = false

func onEnter(player: MainCharacter, delta: float):
	super.onEnter(player, delta)
	jumped = false
	anticTime = 0
	chara.gravity = chara.defaultGravity
	if not chara.hasDoubleJumped or not chara.canDoubleJump:
		chara.animationPlayer.play("JumpAntic", chara.blendTime, 1)
	else:
		chara.animationPlayer.play("JumpDouble", chara.blendTime, 1)
	chara.animationPlayer.queue("Jump")
	
func onExit(delta: float):
	if chara.velocity.y > 0:
		chara.gravity *= chara.jumpCutGravityMult

func check():
	if jumped:
		if chara.velocity.y <= 0:
			return "FallState"
		if not Input.is_action_pressed("Jump") and afterAnticTime > 0.05:
			return "AirState"
	if chara.getVaultingDirection() != 0 and chara.vaultingDir == Input.get_axis("Left", "Right"):
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
