extends State

class_name DeccelState

func onEnter(player: MainCharacter, delta: float):
	super.onEnter(player, delta)
	
func onExit(delta: float):
	pass

func check():
	if not Input.is_action_pressed("left") and not Input.is_action_pressed("right"):
		return "IdleState"
	if Input.is_action_pressed("Jump"):
		return "JumpState"
	if not chara.is_on_floor():
		if chara.velocity.y <= 0:
			return "FallState"
		else:
			return "FlyState"
		
	return null

func apply(delta):
	var moveDir = Input.get_action_strength("right") - Input.get_action_strength("left")
	chara.velocity.x = moveDir * chara.moveSpeed * delta
