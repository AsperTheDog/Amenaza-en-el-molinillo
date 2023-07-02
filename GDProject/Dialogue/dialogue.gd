extends Area3D

const Balloon = preload("res://dialogue/balloon.tscn")

@export var dialogue_resource: DialogueResource
@export var dialogue_start: String = "mailbox"
var balloon: Node = null

func startDialog() -> void:
	balloon = Balloon.instantiate()
	get_tree().current_scene.add_child(balloon)
	balloon.start(dialogue_resource, dialogue_start)
 
func isRunning() -> bool:
	return balloon != null && balloon.dialogue_line == null
