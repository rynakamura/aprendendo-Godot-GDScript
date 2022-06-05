extends KinematicBody2D
const ACCELERATION = 500
const FRICTION = 500
const MAX_SPEED = 100

enum {
	MOVE,
	ROLL,
	ATTACK
}

var state = MOVE
var velocity = Vector2.ZERO
var roll_vector = Vector2.LEFT

onready var animationPlayer = $AnimationPlayer
onready var animationTree = $AnimationTree
onready var animationState = animationTree.get('parameters/playback')
onready var swordHitBox = $HitboxPivot/SwordHitBox


func _ready(): 
	animationTree.active = true
	swordHitBox.knockback_vector = Vector2.LEFT

func _physics_process(delta):
	match state:
		MOVE:
			move_state(delta)
		ROLL:
			roll_state(delta)
		ATTACK:
			atk_state(delta)

func move_state(delta):
	var result = Vector2(0,0)
	result.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	result.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	result = result.normalized()
	if result != Vector2.ZERO:
#		animationPlayer.play("runRight")
		roll_vector = result
		swordHitBox.knockback_vector = result
		animationTree.set('parameters/idle/blend_position',result) #o parametro é o indicado ao apoiar o mouse no atributo a esquerda
		animationTree.set('parameters/run/blend_position',result)
		animationTree.set('parameters/atk/blend_position',result)
		animationTree.set('parameters/roll/blend_position',result)
		animationState.travel("run")
		velocity = velocity.move_toward(result * MAX_SPEED,ACCELERATION * delta)
		move()
#		velocity += result * ACCELERATION * delta
#		velocity = velocity.clamped(MAX_SPEED) #clamped é limitador de velocidade
	else:
#		animationPlayer.play("idleRight")
		animationState.travel('idle')
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
	if Input.is_action_just_pressed("attack"):
		state = ATTACK
	if Input.is_action_just_pressed("roll"):
		state = ROLL

func atk_state(delta):
	velocity = Vector2.ZERO
	animationState.travel('atk')
	
func on_atk_end():
	state = MOVE
	
func roll_state(delta):
	velocity = (roll_vector * MAX_SPEED )/1.2
	animationState.travel('roll')
	move()
	
func on_roll_end():
	state = MOVE
	
func move():
	velocity = move_and_slide(velocity)
	
