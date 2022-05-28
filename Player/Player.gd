extends KinematicBody2D
const ACCELERATION = 600
const FRICTION = 600
const MAX_SPEED = 150
var velocity = Vector2.ZERO

onready var animationPlayer = $AnimationPlayer

#func _ready(): esse equivale ao onready acima
#	animationPlayer = $AnimationPlayer

func _physics_process(delta):
	var result = Vector2(0,0)
	result.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	result.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	result = result.normalized()
	if result != Vector2.ZERO:
		animationPlayer.play("runRight")
		velocity = velocity.move_toward(result * MAX_SPEED,ACCELERATION * delta)
#		velocity += result * ACCELERATION * delta
#		velocity = velocity.clamped(MAX_SPEED) #clamped é limitador de velocidade
	else:
		animationPlayer.play("idleRight")
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
	velocity = move_and_slide(velocity)

