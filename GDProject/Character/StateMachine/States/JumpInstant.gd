extends State

class_name JumpInstantState

func onEnter(player: MainCharacter, delta: float):
	super.onEnter(player, delta)
	chara.gravity = chara.defaultGravity
	if chara.hasDoubleJumped or not chara.canDoubleJump:
		chara.animationPlayer.play("JumpDouble", chara.blendTime, 1)
	chara.animationPlayer.play("Jump", chara.blendTime)
	chara.setVertForce((chara.jumpSpeed * Vector3.UP).y)
	
func onExit(delta: float):
	if chara.velocity.y > 0:
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
