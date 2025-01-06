extends Node2D

#region Export Variables
@export var _initial_state_active : bool
#endregion

#region Private Variables
var _player : CharacterBody2D
var _hitbox : CollisionShape2D
var _sprite : Sprite2D
var _flip_state : int
#endregion

#region Signals
#endregion

#region Godot Methods
func _ready() -> void:
	_player = get_tree().get_nodes_in_group("Player")[0]
	_hitbox = get_node("HitBox/CollisionShape2D")
	_sprite = get_node("Sprite")
	_player.get_node("StatsManager").connect("flip_block_switch", _flip_block_switch)
	if _initial_state_active == true: _flip_state = 1
	if _initial_state_active == false: _flip_state = -1
	
	if _flip_state == 1:
		_hitbox.disabled = false
		_sprite.modulate = Color.WHITE
	if _flip_state == -1:
		_hitbox.disabled = true
		_sprite.modulate.a = 0.25
#endregion

#region Public Methods
#endregion

#region Private Methods
func _flip_block_switch() -> void:
	_flip_state = _flip_state * -1
	
	if _flip_state == 1:
		_hitbox.disabled = false
		_sprite.modulate.a = 1.00
	if _flip_state == -1:
		_hitbox.disabled = true
		_sprite.modulate.a = 0.25
#endregion
