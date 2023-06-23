extends State

class_name JumpState

var count = 0
var jumped = false

func onEnter(player: MainCharacter, delta: float):
	super.onEnter(player, delta)
	jumped = false
	count = 0
	chara.animationPlayer.play("Jump Ro")
	
func onExit(delta: float):
	if chara.velocity.y < 0:
		chara.gravity *= chara.jumpCutGravityMult

func check():
	if jumped:
		if chara.velocity.y <= 0:
			return "FallState"
		if not Input.is_action_pressed("Jump"):
			chara.setVertForce(chara.velocity.y * chara.jumpCutGravityMult)
			return "AirState"
	else:
		if not chara.is_on_floor():
			return "FallState"
	return null

func apply(delta):
	count += delta
	if jumped:
		chara.applyForce(chara.gravity * delta * Vector3.DOWN)
		chara.applyHorizMovementAir(delta)
	else:
		if count > 0.3:
			jumped = true
			chara.setVertForce((chara.jumpSpeed * Vector3.UP).y)
		else:
			chara.applyHorizMovement(delta)
