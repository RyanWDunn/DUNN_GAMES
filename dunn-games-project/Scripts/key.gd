extends Node2D

#region Export Variables
@export var red_key : bool = false
@export var blue_key : bool = false
@export var green_key : bool = false
#endregion

#region Private Variables
var _key_type
#endregion

#region Signals
#endregion

#region Godot Methods
func _ready() -> void:
	if blue_key == true:
		modulate = Color.BLUE
		_key_type = Enums.Lock.Blue
	elif red_key == true:
		modulate = Color.RED
		_key_type = Enums.Lock.Red
	elif green_key == true:
		modulate = Color.GREEN
		_key_type = Enums.Lock.Green
	print(_key_type)
#endregion

#region Public Methods
#endregion

#region Private Methods
func _on_hitbox_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		body.get_node("StatsManager").pick_up_key(_key_type)
		queue_free()
#endregion
