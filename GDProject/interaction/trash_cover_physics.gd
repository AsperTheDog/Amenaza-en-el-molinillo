extends Node3D

var interactedMaterial: BaseMaterial3D = preload("res://Materials/Items/items_interacted_v1.tres")

var interacted: bool = false

func getPunched():
	if interacted:
		return
	$RigidBody3D.apply_impulse(Vector3(0, 10.5, 0), Vector3(-0.2, 0, 0.1))
	$"RigidBody3D/modelo/cubo Basura tapa".set_surface_override_material(0, interactedMaterial)
	$"../cubo Basura".set_surface_override_material(0, interactedMaterial)
	interacted = true
	await get_tree().create_timer(0.2).timeout
	$"item-cheeseburger".show()
	$"item-cheeseburger".spawn()
