extends State

class_name JumpState

var count = 0
var jumped = false

func onEnter(player: MainCharacter, delta: float):
	super.onEnter(player, delta)
	jumped = false
	count = 0
	chara.animationPlayer.play("Jump Ro", chara.blendTime, 1)
	
func onExit(delta: float):
	if chara.velocity.y > 0:
		chara.gravity *= chara.jumpCutGravityMult

func check():
	if jumped:
		if chara.velocity.y <= 0:
			return "FallState"
		if not Input.is_action_pressed("Jump"):
			return "AirState"
	return null

func apply(delta):
	count += delta
	if jumped:
		chara.applyForce(chara.gravity * delta * Vector3.DOWN)
		chara.applyHorizMovementAir(delta)
	else:
		if count > 0.1:
			jumped = true
			chara.setVertForce((chara.jumpSpeed * Vector3.UP).y)
		else:
			chara.applyHorizMovement(delta)
