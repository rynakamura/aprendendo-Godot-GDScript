extends KinematicBody2D
const ACCELERATION = 600
const FRICTION = 600
const MAX_SPEED = 150

enum {
	MOVE,
	ROLL,
	ATTACK
}

var state = MOVE
var velocity = Vector2.ZERO

onready var animationPlayer = $AnimationPlayer
onready var animationTree = $AnimationTree
onready var animationState = animationTree.get('parameters/playback')

#func _ready(): esse equivale ao onready acima
#	animationPlayer = $AnimationPlayer

func _physics_process(delta):
	match state:
		MOVE:
			move_state(delta)
		ROLL:
			pass
		ATTACK:
			atk_state(delta)

func move_state(delta):
	var result = Vector2(0,0)
	result.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	result.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	result = result.normalized()
	if result != Vector2.ZERO:
#		animationPlayer.play("runRight")
		animationTree.set('parameters/idle/blend_position',result) #o parametro é o indicado ao apoiar o mouse no atributo a esquerda
		animationTree.set('parameters/run/blend_position',result)
		animationTree.set('parameters/atk/blend_position',result)
		animationState.travel("run")
		velocity = velocity.move_toward(result * MAX_SPEED,ACCELERATION * delta)
#		velocity += result * ACCELERATION * delta
#		velocity = velocity.clamped(MAX_SPEED) #clamped é limitador de velocidade
	else:
#		animationPlayer.play("idleRight")
		animationState.travel('idle')
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
	velocity = move_and_slide(velocity)
	if Input.is_action_just_pressed("attack"):
		state = ATTACK

func atk_state(delta):
	velocity = Vector2.ZERO
	animationState.travel('atk')
	
func on_atk_end():
	state = MOVE
