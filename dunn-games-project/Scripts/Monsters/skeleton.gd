extends CharacterBody2D

#region Export Variables
@export var enemyMaxHP : int = 2
@export var movement_speed : int = 100
#endregion

#region Private Variables
var _sprite : Sprite2D
var _weapon_box : Area2D
var _trap_timer : Timer
var _currentHP : int
var _is_damaged : bool = false
var _is_attacking : bool = false
var _is_trapped : bool = false
#endregion

#region Signals
#endregion

#region Godot Methods
# Assign the current hp to max hp on initialization
func _ready() -> void:
	_sprite = get_node("Sprite")
	_weapon_box = get_node("WeaponBox")
	_trap_timer = get_node("TrapTimer")
	_currentHP = enemyMaxHP
	
	if _weapon_box != null:
		_weapon_box.set_flipped_flag(true)
	else:
		print("ERROR: WEAPONBOX NOT FOUND (SKELETON.GD)")

func _process(_delta: float) -> void:
	# Do nothing if trapped
	if _is_trapped: return
	
	# Get the opposite directional input and move the player
	var movement = Input.get_vector("right", "left", "down", "up")
	movement = movement.normalized()
	velocity = movement * movement_speed
	move_and_slide()
	_check_sprite_facing()
	
	# Get the attack input and set the flag
	if Input.is_action_just_pressed("light_attack"):
		_do_attack()
	if Input.is_action_just_pressed("heavy_attack"):
		_do_attack()
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

func trap() -> void:
	_is_trapped = true
	_sprite.modulate = Color.YELLOW
	_trap_timer.start()
#endregion

#region Private Methods
func _reset_animation_flags() -> void:
	# Resets animation parameters, 
	# (called automatically at end of animation)
	_is_damaged = false
	_is_attacking = false

func _check_sprite_facing() -> void:
	# Change the facing of the sprite based on its velocity
	if _sprite != null:
		if velocity.x < 0: _sprite.flip_h = true
		if velocity.x > 0: _sprite.flip_h = false
	else:
		print("ERROR: SPRITE NOT FOUND (SKELETON.GD)")
	
func _do_attack() -> void:
	_is_attacking = true
	# Look for a monster, damage it
	var object = _check_for_monster()
	if object == null: return
	if object.is_in_group("Monster"):
		object.damage(-1)

func _check_for_monster() -> CharacterBody2D:
	# Returns the first overlapping body of the weapon_box
	var object
	if _weapon_box != null:
		if _weapon_box.get_overlapping_bodies().size() != 0:
			object = _weapon_box.get_overlapping_bodies()[0]
	else:
		print("ERROR: WEAPONBOX NOT FOUND (SKELETON.GD)")
	return object

func _on_trap_timer_timeout() -> void:
	_is_trapped = false
	_sprite.modulate = Color.WHITE
#endregion
