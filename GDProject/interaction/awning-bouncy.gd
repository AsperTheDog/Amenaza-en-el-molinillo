extends Node3D

@export var bounceForce: float = 30

func _ready():
	$Area3D.body_entered.connect(bounce)

func bounce(body: Node3D):
	if body.has_method("setVertForce"):
		body.hasDoubleJumped = false
		body.forceState("AirState")
		body.setVertForce(bounceForce)
		if bounceForce > 20:
			$Audio/bounceStrong.play()
		else:
			$Audio/bounce.play()
