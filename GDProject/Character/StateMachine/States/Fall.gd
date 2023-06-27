extends State

class_name FallState

func onEnter(player: MainCharacter, delta: float):
	super.onEnter(player, delta)
	chara.gravity = chara.defaultGravity
	if chara.animationPlayer.assigned_animation != "FallingJump Ro":
		chara.animationPlayer.play("FallingJump Ro")
	
func onExit(delta: float):
	pass

func check():
	if chara.is_on_floor():
		chara.animationPlayer.play("FallingFloor Ro")
		return "RunState"
	if Input.is_action_just_pressed("Jump") and not chara.hasDoubleJumped:
		chara.hasDoubleJumped = true
		return "JumpState"
	return null

func apply(delta):
	chara.applyForce(chara.gravity * chara.fallGravityMult * delta * Vector3.DOWN)
	var newForce = chara.velocity
	newForce.y = max(newForce.y, -chara.maxFallSpeed)
	chara.setForce(newForce)
	chara.applyHorizMovementAir(delta)
