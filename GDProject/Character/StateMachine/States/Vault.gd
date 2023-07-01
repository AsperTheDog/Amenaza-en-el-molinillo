extends State

class_name VaultState

var timer: float = 0
var initialPos: float
var snapFinished: bool = false

var snapTime = 0.02
var timeUntilLift = 0.1
var liftDuration = 0.2

func onEnter(player: MainCharacter, delta: float):
	super.onEnter(player, delta)
	timer = 0
	initialPos = chara.global_transform.origin.y
	snapFinished = false
	chara.get_node("modelo").rotation.y = deg_to_rad(chara.vaultingDir * 89)
	chara.animationPlayer.play("JumpCorner", -1)
	chara.animationPlayer.seek(0)
	
func onExit(delta: float):
	pass

func check():
	if timer >= liftDuration:
		return "FallState"

func apply(delta):
	timer += delta
	if timer < snapTime:
		chara.global_transform.origin.y = lerp(initialPos, chara.vaultingPos.y - 1.6, timer / snapTime)
	elif not snapFinished:
		snapFinished = true
		chara.global_transform.origin.y = chara.vaultingPos.y - 1.6
	if (timer > timeUntilLift):
		chara.setVertForce(9)
	else:
		chara.velocity.y = 0
	chara.move_and_slide()
