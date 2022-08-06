extends KinematicBody2D

enum {
	IDLE,
	WANDER,
	CHASE
}

var knockback = Vector2.ZERO
var BatDeathEffect = preload("res://Effects/BatDeath.tscn")
onready var Health = $Health
onready var stats = IDLE

func _physics_process(delta):
	knockback = knockback.move_toward(Vector2.ZERO,200* delta)
	knockback = move_and_slide(knockback)

func _on_HurtBox_area_entered(area):
	Health.health -= area.damage
	knockback = area.knockback_vector *120
	#queue_free()


func _on_Node_zero_health():
	var batDeath = BatDeathEffect.instance()
	get_parent().add_child(batDeath)
	batDeath.global_position = global_position
	queue_free()
