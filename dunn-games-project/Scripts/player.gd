extends CharacterBody2D

# Handles player input and movement of character

#region Export Variables
@export var movement_speed = 100
#endregion

#region Private Variables
var _sprite : Sprite2D
var _weapon_box : Area2D
var _stats_manager : Node
var _spell_cast_point_left : Marker2D
var _spell_cast_point_right : Marker2D
var _is_light_attacking : bool = false
var _is_heavy_attacking : bool = false
var _is_damaged : bool = false
var _is_casting_spell : bool = false
var _shield_spell_active : bool = false
var _fire_spell : PackedScene = preload("res://Scenes/Spells/spell_fire.tscn")
var _monster_trap : PackedScene = preload("res://Scenes/monster_trap.tscn")
#endregion

#region Signals
#endregion

#region Godot Methods
func _ready() -> void:
	_sprite = get_node("Sprite")
	_weapon_box = get_node("WeaponBox")
	_stats_manager = get_node("StatsManager")
	_spell_cast_point_left = get_node("SpellCastPoints/SpellCastLeft")
	_spell_cast_point_right = get_node("SpellCastPoints/SpellCastRight")

func _physics_process(_delta: float) -> void:
	# No movement while casting a spell
	if _is_casting_spell: return
	
	# Get the directional input and move the player
	var movement = Input.get_vector("left", "right", "up", "down")
	movement = movement.normalized()
	velocity = movement * movement_speed
	move_and_slide()
	
	# Get the attack input and set the flag
	if Input.is_action_just_pressed("light_attack"):
		_do_light_attack()
	if Input.is_action_just_pressed("heavy_attack"):
		_do_heavy_attack()
	if Input.is_action_just_pressed("cast_spell"):
		_do_cast_spell()
	if Input.is_action_just_pressed("switch_spell"):
		_do_switch_spell()
	if Input.is_action_just_pressed("use_item"):
		_do_use_item()
	
	# Flip the sprite horizontally if necessary
	_check_sprite_facing()
#endregion

#region Public Methods
func damage(amount : int) -> void:
	# If the shield spell is active, deactivate and
	# take no damage from the attack
	if _shield_spell_active:
		_deactive_spell_shield()
		return
	
	# Change the HP and set the damage flag
	_stats_manager.change_HP(amount)
	_is_damaged = true
#endregion

#region Private Methods
func _check_sprite_facing() -> void:
	# Change the facing of the sprite based on its velocity
	if _sprite != null:
		if velocity.x < 0: _sprite.flip_h = true
		if velocity.x > 0: _sprite.flip_h = false
	else:
		print("ERROR: SPRITE NOT FOUND (PLAYER.GD)")

func _reset_animation_flags() -> void:
	# Resets animation parameters, 
	# (called automatically at end of animation)
	_is_light_attacking = false
	_is_heavy_attacking = false
	_is_casting_spell = false
	_is_damaged = false

func _do_light_attack() -> void:
	# Set the flags, remove stamina
	_is_light_attacking = true
	_stats_manager.change_ST(-1)
	
	# Look for a monster, damage it
	var object = _check_for_monster()
	if object == null: return
	if object.is_in_group("Monster"):
		if object.is_in_group("ImmuneToPlayerAttack"): pass
		else: object.damage(-1)

func _do_heavy_attack() -> void:
	# Set the flags, remove stamina
	_is_heavy_attacking = true
	_stats_manager.change_ST(-2)
	
	# Look for a monster, damage it
	var object = _check_for_monster()
	if object == null: return
	if object.is_in_group("Monster"):
		object.damage(-3)

func _do_cast_spell() -> void:
	# Cast whichever spell is active and set the flag
	match _stats_manager.get_active_spell():
		Enums.Spell.Shield:
			_cast_spell_shield()
		Enums.Spell.Fire:
			_cast_spell_fire()
		Enums.Spell.Heal:
			_cast_spell_heal()
		Enums.Spell.FlipBlock:
			_cast_spell_flipblock()
	_is_casting_spell = true

func _do_switch_spell() -> void:
	match _stats_manager.get_active_spell():
		Enums.Spell.Shield: _stats_manager.change_active_spell(Enums.Spell.Fire)
		Enums.Spell.Fire: _stats_manager.change_active_spell(Enums.Spell.Heal)
		Enums.Spell.Heal: _stats_manager.change_active_spell(Enums.Spell.FlipBlock)
		Enums.Spell.FlipBlock: _stats_manager.change_active_spell(Enums.Spell.Shield)
		
func _do_use_item() -> void:
	match _stats_manager.get_active_item():
		Enums.Item.MonsterTrap:
			_use_monster_trap()

func _cast_spell_shield() -> void:
	# Change the color of the player and set shield to active
	_shield_spell_active = true
	_sprite.modulate = Color.BLUE
	_stats_manager.change_MP(-1)

func _deactive_spell_shield() -> void:
	# Deactivate shield and change color back
	_shield_spell_active = false
	_sprite.modulate = Color.WHITE

func _cast_spell_fire() -> void:
	# Load the fire spell scene, set it to the correct
	var fire_spell = _fire_spell.instantiate()
	if _sprite.flip_h == true:
		fire_spell.position = _spell_cast_point_left.position
	if _sprite.flip_h != true:
		fire_spell.position = _spell_cast_point_right.position
	add_child(fire_spell)
	_stats_manager.change_MP(-2)

func _cast_spell_heal() -> void:
	_stats_manager.change_MP(-3)
	_stats_manager.change_HP(1)

func _cast_spell_flipblock() -> void:
	_stats_manager.change_MP(-1)
	_stats_manager.flip_blocks()

func _use_monster_trap() -> void:
	var monster_trap = _monster_trap.instantiate()
	monster_trap.global_position = global_position
	get_tree().root.add_child(monster_trap)

func _check_for_monster() -> CharacterBody2D:
	# Returns the first overlapping body of the weapon_box
	var object
	if _weapon_box != null:
		if _weapon_box.get_overlapping_bodies().size() != 0:
			object = _weapon_box.get_overlapping_bodies()[0]
	else:
		print("ERROR: WEAPONBOX NOT FOUND (PLAYER.GD)")
	return object
#endregion
