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
func _on_hitbox_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		body.get_node("StatsManager").pick_up_key()
		queue_free()
#endregion
