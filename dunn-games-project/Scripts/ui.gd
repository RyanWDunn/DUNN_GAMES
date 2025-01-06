extends CanvasLayer

# Manages the UI

#region Export Variables
#endregion

#region Private Variables
var _player : CharacterBody2D

###### DEBUG CODE ############################
var _hp_label_debug : Label
var _mp_label_debug : Label
var _st_label_debug : Label
var _sp_label_debug : Label
var _key_label_debug : Label
###### END DEBUG CODE ########################
#endregion

#region Signals
#endregion

#region Godot Methods
func _ready() -> void:
	# Player is the only node in the "Player" group
	_player = get_tree().get_nodes_in_group("Player")[0]
	
	# Connect to the signal for updating stats
	if _player != null:
		_player.get_node("StatsManager").connect("stats_changed", _stats_updated)
		_player.get_node("StatsManager").connect("spell_switched", _spell_switched)
		_player.get_node("StatsManager").connect("key_changed", _key_changed)
	else:
		print("ERROR: PLAYER NOT FOUND (UI.GD)")
	
	###### DEBUG CODE ############################
	_hp_label_debug = get_node("StatsVBox_DEBUG/HP_Label_DEBUG")
	_mp_label_debug = get_node("StatsVBox_DEBUG/MP_Label_DEBUG")
	_st_label_debug = get_node("StatsVBox_DEBUG/ST_Label_DEBUG")
	_sp_label_debug = get_node("StatsVBox_DEBUG/ACTIVE_SPELL_Label_DEBUG")
	_key_label_debug = get_node("StatsVBox_DEBUG/HAS_LEY_Label_DEBUG")
	###### END DEBUG CODE ########################
#endregion

#region Public Methods
#endregion

#region Private Methods
func _stats_updated(currentHP : int, currentMP : int, currentST : int) -> void:
	_hp_label_debug.text = "HP = %d" % currentHP
	_mp_label_debug.text = "MP = %d" % currentMP
	_st_label_debug.text = "ST = %d" % currentST
	
func _spell_switched(active_spell : Enums.Spell) -> void:
	match active_spell:
		Enums.Spell.Shield:
			_sp_label_debug.text = "Current Spell: Shield"
		Enums.Spell.Fire:
			_sp_label_debug.text = "Current Spell: Fire"
		Enums.Spell.Heal:
			_sp_label_debug.text = "Current Spell: Heal"
		Enums.Spell.FlipBlock:
			_sp_label_debug.text = "Current Spell: FlipBlock"

func _key_changed(has_key : bool) -> void:
	if has_key == true:
		_key_label_debug.text = "Has Key: YES"
	else:
		_key_label_debug.text = "Has Key: NO"

		
#endregion
