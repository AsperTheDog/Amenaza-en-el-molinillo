extends BirdState
class_name FlyBirdState

func onEnter(player: Bird, delta: float):
	super.onEnter(player, delta)
	chara.animationPlayer.play("Run")
	
func onExit(delta: float, transitionTo: String):
	if transitionTo == "IdleState":
		chara.velocity = Vector3.ZERO
		chara.transform.origin = chara.initialPos

func check():
	if chara.canBirdRespawn():
		return "IdleState"

func apply(delta):
	if chara.get_node("LocalRespawnNotifier").is_on_screen():
		var finalSpeed = chara.flyDirection
		finalSpeed.x += chara.global_transform.basis.z.x
		finalSpeed *= chara.flyAcceleration * delta
		chara.velocity += finalSpeed
		chara.move_and_slide()
