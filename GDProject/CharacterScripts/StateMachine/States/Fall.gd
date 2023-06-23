extends State

class_name FallState

func onEnter(player: MainCharacter, delta: float):
	super.onEnter(player, delta)
	
func onExit(delta: float):
	pass

func check():
	if chara.is_on_floor():
		return "RunState"
	if Input.is_action_just_pressed("Jump") and not chara.hasDoubleJumped:
		chara.hasDoubleJumped = true
		return "JumpState"
	return null

func apply(delta):
	chara.applyForce(chara.gravity * chara.fallGravityMult * delta * Vector3.DOWN)
	var newForce = chara.velocity
	newForce.y = min(newForce.y, -chara.maxFallSpeed)
	chara.setForce(newForce)
	chara.applyHorizMovementAir(delta)
