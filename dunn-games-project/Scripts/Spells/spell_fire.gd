extends Node2D

#region Export Variables
#endregion

#region Private Variables
var _hitbox : Area2D
#endregion

#region Signals
#endregion

#region Godot Methods
#endregion

#region Public Methods
#endregion

#region Private Methods
func _do_fire_damage() -> void:
	# Get the hitbox
	_hitbox = get_node("HitBox")
	var target
	
	# If there are any monsters in the cast area do damage to them
	# target.size() - 1 is because this function gets called every time
	# a new body enters the area, and we want to damage the latest enemy
	# that has entered the box
	if _hitbox != null:
		target = _hitbox.get_overlapping_bodies()
		var current_target = target[target.size() - 1]
		if current_target.is_in_group("Monster"):
			current_target.damage(-2)
	else:
		print("ERROR: HITBOX NOT FOUND (SPELL_FIRE.GD)")
#endregion

func _on_hit_box_body_entered(_body: Node2D) -> void:
	_do_fire_damage()
