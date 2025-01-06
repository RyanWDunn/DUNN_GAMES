extends CharacterBody2D

#region Export Variables
@export var enemyMaxHP : int = 1
#endregion

#region Private Variables
var _currentHP : int
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
	if _currentHP <= 0: die()

# Free the slime from the scene
func die() -> void:
	queue_free()
#endregion

#region Private Methods
#endregion
