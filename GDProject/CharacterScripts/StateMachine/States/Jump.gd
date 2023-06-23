extends State

class_name JumpState

func onEnter(player: MainCharacter, delta: float):
	super.onEnter(player, delta)
	chara.setVertForce((chara.jumpSpeed * Vector3.UP).y)
	
func onExit(delta: float):
	if chara.velocity.y < 0:
		chara.gravity *= chara.jumpCutGravityMult

func check():
	if chara.velocity.y >= 0:
		return "FallState"
	if Input.is_action_just_released("Jump"):
		return "AirState"
	return null

func apply(delta):
	chara.applyForce(chara.gravity * delta * Vector3.DOWN)
	chara.applyHorizMovementAir(delta)
