extends Node3D

var interactedMaterial: BaseMaterial3D = preload("res://Materials/Items/items_interacted_v1.tres")

func getPunched():
	$RigidBody3D.apply_impulse(Vector3(0, 10, 0), Vector3(-0.1, 0, 0.2))
	$"RigidBody3D/modelo/cubo Basura tapa".set_surface_override_material(0, interactedMaterial)
	$"../cubo Basura".set_surface_override_material(0, interactedMaterial)
	await get_tree().create_timer(0.2).timeout
	$"item-cheeseburger".show()
	$"item-cheeseburger".spawn()
