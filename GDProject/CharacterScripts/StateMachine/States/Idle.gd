extends State

class_name IdleState

func onEnter(player: MainCharacter, delta: float):
	super.onEnter(player, delta)
	
func onExit(delta: float):
	pass

func check():
	if Input.is_action_pressed("left") or Input.is_action_pressed("right"):
		return "RunState"
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
