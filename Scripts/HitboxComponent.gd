extends Area2D

class_name HitboxComponent

@export_category("Attributes")

@export var damage = 1.0

@export_subgroup("Knockback")
@export var knockback = false
@export var knockbackLevel = 1
@export var knockbackForce = 100.0

@export_subgroup("Poison")
@export var poison = false
@export var poisonLevel = 1
@export var poisonDamage = 2.0
@export var posionTime = 2.0

@export_subgroup("Stun")
@export var stun = false
@export var stunLevel = 1
@export var stunTime = 1.0
