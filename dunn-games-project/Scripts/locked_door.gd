extends Node2D

#region Export Variables
#endregion

#region Private Variables
#endregion

#region Signals
#endregion

#region Godot Methods
#endregion

#region Public Methods
#endregion

#region Private Methods

#endregion

func _on_collisionbox_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		if body.get_node("StatsManager").check_for_key() == true:
			body.get_node("StatsManager").use_key()
			queue_free()
