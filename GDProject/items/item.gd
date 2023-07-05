extends CharacterBody3D
class_name Item

@export_group("Animation")
@export var strength: float = 0.3
@export var speed: float = 2
@export var rotationSpeed: float = 120
@export_group("Spawn")
@export var impulse: float = 4
@export var sizeSpeed: float = 1
@export var gravity: float = 0.98

var touchedFloor: bool = false

var counter = 0.0
var initialPos: Vector3
var initialSize: Vector3
var spawnProcess: float = 0
var hasSpawned: float = false
var spawnFinished: bool = true

# Called when the node enters the scene tree for the first time.
func _ready():
	$interact.body_entered.connect(_on_interact_body_entered)
	$floorTouch.body_entered.connect(_on_floorTouch_body_entered)
	initialPos = $modelo.transform.origin
	initialSize = $modelo.scale
	
	
func spawn():
	velocity.y = impulse * Vector3.UP.y
	velocity.x = impulse
	spawnProcess = 0
	spawnFinished = false
	hasSpawned = true
	$modelo.scale = Vector3(0, 0, 0)
	move_and_slide()


func _process(delta):
	if not hasSpawned:
		return
	animate(delta)
	if not spawnFinished:
		spawnProcess += delta * speed
		$modelo.scale = lerp(Vector3(0, 0, 0), initialSize, ease(clamp(spawnProcess, 0, 1), 0.4))
		if spawnProcess > 1:
			spawnFinished = true
	if not touchedFloor:
		velocity.y += gravity * delta * Vector3.DOWN.y
	else:
		velocity.y = 0
		velocity.x = 0
	move_and_slide()

func animate(delta):
	counter += delta
	var height = sin(counter * speed) * strength + initialPos.y
	var newPos = initialPos
	newPos.y = height
	$modelo.transform.origin = newPos
	$modelo.rotate(Vector3(0, 1, 0), deg_to_rad(rotationSpeed) * delta)


func _on_interact_body_entered(body):
	if body.get_class() == "MainCharacter":
		print("Player!!")


func _on_floorTouch_body_entered(body):
	if hasSpawned:
		touchedFloor = true
