extends Node2D

###### DEBUG CODE ############################
func _process(_delta: float) -> void:
	if Input.is_key_pressed(KEY_R):
		get_tree().reload_current_scene()
	if Input.is_key_pressed(KEY_M):
		get_node("UI").visible = true
	if Input.is_key_pressed(KEY_N):
			get_node("UI").visible = false
###### END DEBUG CODE ########################
