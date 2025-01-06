extends Area2D

#region Export Variables
@export var x_position : int = 12
@export var y_position : int = -6
#endregion

#region Private Variables
var _player : CharacterBody2D
var _is_flipped : bool = false
#endregion

#region Signals
#endregion

#region Godot Methods
func _ready() -> void:
	# Player is the only node in the "Player" group
	_player = get_tree().get_nodes_in_group("Player")[0]
	
	# Set the hit box to initial location
	position.x = x_position
	position.y = y_position

func _process(_delta: float) -> void:
	# Flips the box to the appropriate side of the player
	if(_is_flipped == false):	
		if _player.velocity.x < 0: position.x = -x_position
		if _player.velocity.x > 0: position.x = x_position
	if(_is_flipped == true):
		if _player.velocity.x < 0: position.x = x_position
		if _player.velocity.x > 0: position.x = -x_position
		position.y = y_position
#endregion

#region Public Methods
func set_flipped_flag(flag : bool) -> void:
	_is_flipped = flag
#endregion

#region Private Methods
#endregion
