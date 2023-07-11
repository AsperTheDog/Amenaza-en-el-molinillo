extends CharacterBody3D
class_name Bird

@export var maximumHeight: float = 1000
@export var minimumIdleTime: float = 2
@export var idleActionChance: float = 0.2
@export var flyAcceleration: float = 20

var flyDirection: Vector3 = Vector3(0, 1, 1).normalized()

var shouldFly: bool = false

@onready var initialPos: Vector3 = transform.origin
@onready var animationPlayer: AnimationPlayer = $AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready():
	$StateMachine.setup(self)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$StateMachine.evaluate(delta)

func _on_flee_area_body_entered(body):
	if body.has_method("getName") and body.getName() == "MainCharacter":
		shouldFly = true

func getName():
	return "Bird"
	
func canBirdRespawn():
	$RespawnNotifier.global_position = initialPos
	return not $LocalRespawnNotifier.is_on_screen() and not $RespawnNotifier.is_on_screen()
