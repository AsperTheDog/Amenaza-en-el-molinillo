extends State

class_name PunchGroundRoState

var preTime: float = 0.2
var endTime: float = 0.4
var timer: float = 0
var animationTime: float = 0
var inPrePunch: bool = true

func onEnter(player: MainCharacter, delta: float):
	super.onEnter(player, delta)
	chara.executeAnimation("PunchGround1")
	animationTime = chara.animationPlayer.current_animation_length - 0.4
	timer = 0
	inPrePunch = true
	
func onExit(_delta: float, _transitionTo: String):
	chara.punchCollider.monitoring = false

func check():
	if timer >= animationTime:
		return "FallState"

func apply(delta):
	timer += delta
	if timer >= preTime:
		if inPrePunch:
			chara.setVertForce(chara.upwardsForce)
			inPrePunch = false
		chara.punchCollider.monitoring = true
	elif timer >= endTime:
		chara.punchCollider.monitoring = false
	chara.applyForce(chara.gravity * delta * Vector3.DOWN)
	chara.applyHorizMovement(delta, 0)
