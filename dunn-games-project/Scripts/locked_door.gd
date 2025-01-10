extends Node2D

#region Export Variables
@export var red_door : bool = false
@export var blue_door : bool = false
@export var green_door : bool = false
#endregion

#region Private Variables
var _door_type = null
#endregion

#region Signals
#endregion

#region Godot Methods
func _ready() -> void:
	if blue_door == true:
		modulate = Color.BLUE
		_door_type = Enums.Lock.Blue
	elif red_door == true:
		modulate = Color.RED
		_door_type = Enums.Lock.Red
	elif green_door == true:
		modulate = Color.GREEN
		_door_type = Enums.Lock.Green
#endregion

#region Public Methods
#endregion

#region Private Methods
func _on_collisionbox_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		print (_door_type)
		if body.get_node("StatsManager").check_for_key(_door_type) == true:
			body.get_node("StatsManager").use_key(_door_type)
			queue_free()
#endregion
