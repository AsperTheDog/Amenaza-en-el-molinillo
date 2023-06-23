extends CharacterBody3D

class_name MainCharacter

@export var stateMachine: StateMachine = null

@export_group("Jump")
@export_subgroup("Basic")
@export var fallGravityMult: float = 1.2
@export var jumpSpeed: float = 1000
@export var jumpCutGravityMult: float = 2
@export var maxFallSpeed: float = 1000
@export var defaultGravity: float = 9.8
@export_subgroup("Acceleration")
@export var accelInAirMult: float = 1.0
@export var deccelInAirMult: float = 1.0
@export_subgroup("Hang time")
@export var jumpHangTimeThreshold: float = 0.02
@export var jumpHangAccelMult: float = 1.2
@export var jumpHangMaxSpeedMult: float = 1.2

@export_group("Run")
@export var runAccelAmount: float = 5
@export var runDeccelAmount: float = 5
@export var runMaxSpeed: float = 20
@export var doConserveMomentum = true
var gravity = defaultGravity
var hasDoubleJumped: bool = false

func _ready():
	stateMachine.setup(self)

func _physics_process(delta):
	stateMachine.evaluate(delta)
	move_and_slide()

func setForce(force: Vector3):
	velocity += force

func applyForce(force: Vector3):
	velocity += force

func setVertForce(force: float):
	velocity.y = force

func setHorizForce(force: float):
	velocity.x = force

func applyHorizMovement(delta: float):
	var moveDir = Input.get_action_strength("right") - Input.get_action_strength("left")
	var targetSpeed = moveDir * runMaxSpeed
	var accelRate = runDeccelAmount
	if abs(targetSpeed) > 0.01:
		accelRate = runAccelAmount
	
	var movement = (targetSpeed - velocity.x) * accelRate * delta;
	applyForce(movement * Vector3.RIGHT)

func applyHorizMovementAir(delta: float):
	var moveDir = Input.get_action_strength("right") - Input.get_action_strength("left")
	var targetSpeed = moveDir * runMaxSpeed
	var accelRate = runDeccelAmount * deccelInAirMult

	if abs(targetSpeed) > 0.01:
		accelRate = runAccelAmount * accelInAirMult
	if abs(velocity.y) < jumpHangTimeThreshold:
		accelRate *= jumpHangAccelMult
		targetSpeed *= jumpHangMaxSpeedMult
	if doConserveMomentum and abs(velocity.x) > abs(targetSpeed) and sign(velocity.x) == sign(targetSpeed) and abs(targetSpeed) > 0.01:
		accelRate = 0

	var movement = (targetSpeed - velocity.x) * accelRate * delta;
	applyForce(movement * Vector3.RIGHT)
