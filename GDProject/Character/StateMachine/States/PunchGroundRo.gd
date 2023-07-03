extends State

class_name PunchGroundRoState

var preTime: float = 0.2
var endTime: float = 0.4
var timer: float = 0
var animationTime: float = 0

func onEnter(player: MainCharacter, delta: float):
	super.onEnter(player, delta)
	chara.executeAnimation("PunchGround1")
	animationTime = chara.animationPlayer.current_animation_length - 0.4
	timer = 0
	
func onExit(_delta: float, _transitionTo: String):
	chara.punchCollider.monitoring = false

func check():
	if timer >= animationTime:
		return "RunState"

func apply(delta):
	timer += delta
	if timer >= preTime:
		chara.punchCollider.monitoring = true
	elif timer >= endTime:
		chara.punchCollider.monitoring = false
	chara.applyHorizMovement(delta, 0)
