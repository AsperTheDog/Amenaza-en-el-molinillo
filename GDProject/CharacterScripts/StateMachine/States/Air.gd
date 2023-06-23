extends State

class_name AirState

func onEnter(player: MainCharacter, delta: float):
	super.onEnter(player, delta)
	
func onExit(delta: float):
	chara.gravity = chara.defaultGravity

func check():
	if chara.velocity.y >= 0:
		return "FallState"
	if chara.is_on_floor():
		return "RunState"
	if Input.is_action_just_pressed("Jump") and not chara.hasDoubleJumped:
		chara.hasDoubleJumped = true
		return "JumpState"
	return null

func apply(delta):
	chara.applyForce(chara.gravity * delta * Vector3.DOWN)
	chara.applyHorizMovementAir(delta)
