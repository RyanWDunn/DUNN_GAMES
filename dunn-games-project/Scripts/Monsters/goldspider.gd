extends CharacterBody2D

#region Export Variables
@export var enemyMaxHP : int = 1
@export var move_speed : int = 45
@export var patrol_point_a : Marker2D
@export var patrol_point_b : Marker2D
#endregion

#region Private Variables
var _currentHP : int
var _is_damaged : bool = false
var _is_trapped : bool = false
var _current_patrol_point : Marker2D
var _sprite : Sprite2D
var _trap_timer : Timer
#endregion

#region Signals
#endregion

#region Godot Methods
# Assign the current hp to max hp on initialization
func _ready() -> void:
	_currentHP = enemyMaxHP
	_current_patrol_point = patrol_point_a
	_sprite = get_node("Sprite")
	_trap_timer = get_node("TrapTimer")

func _process(_delta: float) -> void:
	# If trapped, do nothing
	if _is_trapped: return
	
	# Check if we need to reverse direction.
	if abs((_current_patrol_point.global_position - global_position).length()) < 0.5:
		if _current_patrol_point == patrol_point_a:
			_current_patrol_point = patrol_point_b
		else:
			_current_patrol_point = patrol_point_a
	
	# Set the move target
	var move_target = _current_patrol_point.global_position
	var move_direction = move_target - global_position
	velocity = move_direction.normalized() * move_speed
	move_and_slide()
	_check_sprite_facing()
#endregion

#region Public Methods
# Damage the spider, if health below zero kill it
func damage(amount : int) -> void:
	_currentHP += amount
	_is_damaged = true
	if _currentHP <= 0: die()

# Free the spider from the scene
func die() -> void:
	queue_free()
#endregion

func trap() -> void:
	_is_trapped = true
	_sprite.modulate = Color.YELLOW
	_trap_timer.start()

#region Private Methods
func _check_sprite_facing() -> void:
	# Change the facing of the sprite based on its velocity
	if _sprite != null:
		if velocity.x < 0: _sprite.flip_h = true
		if velocity.x > 0: _sprite.flip_h = false
	else:
		print("ERROR: SPRITE NOT FOUND (GOLDSPIDER.GD)")
		
func _reset_animation_flags() -> void:
	# Resets animation parameters, 
	# (called automatically at end of animation)
	_is_damaged = false

func _on_trap_timer_timeout() -> void:
	_is_trapped = false
	_sprite.modulate = Color.WHITE
#endregion
