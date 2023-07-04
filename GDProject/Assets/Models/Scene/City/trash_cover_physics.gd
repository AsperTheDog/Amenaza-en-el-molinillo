extends RigidBody3D


func getPunched():
	apply_impulse(Vector3(0, 10, 0), Vector3(-0.1, 0, 0.2))
