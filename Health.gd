extends Node

export var max_health = 1
onready var health = max_health setget set_health

signal zero_health

func set_health(value):
	health = value
	print(health)
	if health <=0:
		emit_signal("zero_health")
