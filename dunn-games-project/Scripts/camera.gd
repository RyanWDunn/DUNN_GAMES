extends Camera2D

# Sets the boundaries of the camera and then
# moves the global position of the camera to be 
# equal to the global position of the player
# also includes a debug camera mode that can
# be toggled on and off in the inspector

#region Export Variables
@export var _debug_camera : bool = false
#endregion

#region Private Variables
var _player : CharacterBody2D
var _topLeftBoundary : Marker2D
var _bottomRightBoundary : Marker2D
#endregion

#region Signals
#endregion

#region Godot Methods
func _ready() -> void:
	if _debug_camera == true:
		zoom = Vector2(2, 2)
		return
	
	# Player is the only node in the "Player" group
	_player = get_tree().get_nodes_in_group("Player")[0]
	
	# Get the two boundary children of the camera
	_topLeftBoundary = get_node("TopLeftBoundary")
	_bottomRightBoundary = get_node("BottomRightBoundary")
	
	# Set the bounds of the camera
	_set_bounding_box()
	
func _process(_delta: float) -> void:
	if _debug_camera == true: 
		var camera_movement = Input.get_vector("debug_camera_left","debug_camera_right","debug_camera_up", "debug_camera_down")
		global_position += camera_movement * 2
		if Input.is_action_pressed("debug_camera_zoom_in"):
			zoom += Vector2(0.02, 0.02)
			if zoom.x > 5.0: zoom = Vector2(5, 5)
		if Input.is_action_pressed("debug_camera_zoom_out"):
			zoom -= Vector2(0.02, 0.02)
			if zoom.x < 1.0: zoom = Vector2(1, 1)
		return
	
	if _player != null:
		global_position = _player.global_position
	else: print("ERROR: PLAYER NOT FOUND (CAMERA.GD)")
#endregion

#region Public Methods
#endregion

#region Private Methods
func _set_bounding_box() -> void:
	if _topLeftBoundary != null and _bottomRightBoundary != null:
		limit_left = int(_topLeftBoundary.global_position.x)
		limit_top = int(_topLeftBoundary.global_position.y)
		limit_right = int(_bottomRightBoundary.global_position.x)
		limit_bottom = int(_bottomRightBoundary.global_position.y)
	else:
		print("ERROR: BOUNDARIES NOT FOUND (CAMERA.GD)")
#endregion
