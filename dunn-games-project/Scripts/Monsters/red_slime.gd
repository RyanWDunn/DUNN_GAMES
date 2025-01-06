extends CharacterBody2D

#region Export Variables
@export var enemyMaxHP : int = 3
#endregion

#region Private Variables
var _currentHP : int
var _is_damaged : bool = false
#endregion

#region Signals
#endregion

#region Godot Methods
# Assign the current hp to max hp on initialization
func _ready() -> void:
	_currentHP = enemyMaxHP
#endregion

#region Public Methods
# Damage the slime, if health below zero kill it
func damage(amount : int) -> void:
	_currentHP += amount
	_is_damaged = true
	if _currentHP <= 0: die()

# Free the slime from the scene
func die() -> void:
	queue_free()
#endregion

#region Private Methods
func _reset_animation_flags() -> void:
	# Resets animation parameters, 
	# (called automatically at end of animation)
	_is_damaged = false
#endregion
