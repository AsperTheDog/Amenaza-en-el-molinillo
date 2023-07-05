extends Node3D


func getPunched():
	$RigidBody3D.apply_impulse(Vector3(0, 10, 0), Vector3(-0.1, 0, 0.2))
	await get_tree().create_timer(0.2).timeout
	$"item-cheeseburger".show()
	$"item-cheeseburger".spawn()
