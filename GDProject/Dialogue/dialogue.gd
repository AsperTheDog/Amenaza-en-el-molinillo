extends Area3D

var Balloon = preload("res://dialogue/balloon.tscn")

@export var dialogue_resource: DialogueResource
@export var dialogue_start: String = "mailbox"
var balloon: Node = null

func startDialogue() -> void:
	balloon = Balloon.instantiate()
	get_tree().current_scene.add_child(balloon)
	balloon.start(dialogue_resource, dialogue_start)
 
func stoppedDialogue() -> bool:
	return balloon == null || balloon.dialogueFinished
