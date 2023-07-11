extends Node3D

@export var interactionObject: CollisionObject3D
@export var isPunch: bool = false

enum DEVICES {
	PS,
	XBOX,
	PC
}

var lastDevice: DEVICES = DEVICES.PC

# Called when the node enters the scene tree for the first time.
func _ready():
	$label.text = "Press         to interact" if not isPunch else "Punch to activate"
	if isPunch:
		$ControlButtonXBOX.hide()
		$ControlButtonPS.hide()
		$ControlButtonPC.hide()
	
	interactionObject.body_entered.connect(onEnter)
	interactionObject.body_exited.connect(onExit)


func onEnter(body: Node3D):
	if body.has_method("getName") and body.getName == "MainCharacter":
		show()

func onExit(body: Node3D):
	if body.has_method("getName") and body.getName == "MainCharacter":
		hide()
	
	
