extends State

class_name RunState

func onEnter(player: MainCharacter, delta: float):
	super.onEnter(player, delta)
	chara.hasDoubleJumped = false
	
func onExit(delta: float):
	pass

func check():
	if not Input.is_action_pressed("left") and not Input.is_action_pressed("right"):
		return "IdleState"
	if Input.is_action_just_pressed("Jump"):
		return "JumpState"
	if not chara.is_on_floor():
		if chara.velocity.y <= 0:
			return "FallState"
		else:
			return "FlyState"
	return null

func apply(delta):
	chara.applyHorizMovement(delta)
