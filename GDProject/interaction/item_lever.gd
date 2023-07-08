extends Node3D

@export var activation: Node3D

@export var scaleAmount: float = 1
@export var scaleDelay: float = 0.1
@export var scaleCurve: Curve
@export var animationSpeed: float = 1

var interactedMaterial: BaseMaterial3D = preload("res://Materials/Items/items_interacted_v1.tres")

func getPunched():
	interactAnimation()
	$"item-levermachine_v1/LeverMachine".set_surface_override_material(0, interactedMaterial)
	$"item-leversteam_v1/LeverSteam".set_surface_override_material(0, interactedMaterial)
	$"item-lever_v1/Lever".set_surface_override_material(0, interactedMaterial)
	await get_tree().create_timer((1 / animationSpeed) * 3).timeout
	if activation != null and activation.has_method("activate"):
		activation.activate()

func interactAnimation():
	var count = 0
	while count < scaleDelay + 2:
		var sizeCount = max(0, count - scaleDelay)
		$"item-lever_v1".rotation.x = lerp_angle(deg_to_rad(45), deg_to_rad(-45), min(1, count))
		$"item-leversteam_v1".rotation.x = lerp(0.0, deg_to_rad(360), min(1, count))
		scale = scaleCurve.sample(sizeCount / 2) * scaleAmount * Vector3.ONE
		count += get_process_delta_time() * animationSpeed
		await get_tree().process_frame
