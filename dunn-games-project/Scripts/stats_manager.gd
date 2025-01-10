extends Node

# Manages the HP, MP, and Stamina of the Player

#region Export Variables
#endregion

#region Private Variables
var _currentHealth : int
var _maxHealth : int
var _currentMana : int
var _maxMana : int
var _currentStamina : int
var _maxStamina : int
var _active_spell : Enums.Spell = Enums.Spell.Shield
var _active_item : Enums.Item = Enums.Item.MonsterTrap
var _has_red_key : bool = false
var _has_blue_key : bool = false
var _has_green_key : bool = false
var _has_key : int = 0
#endregion

#region Signals
signal stats_changed
signal spell_switched
signal flip_block_switch
signal key_changed
#endregion

#region Godot Methods
func _ready() -> void:
	###### DEBUG CODE ############################
	_maxHealth = 10
	_maxStamina = 10
	_maxMana = 10
	_currentHealth = _maxHealth
	_currentStamina = _maxStamina
	_currentMana = _maxMana
	stats_changed.emit(_currentHealth, _currentMana, _currentStamina)
	spell_switched.emit(_active_spell)
	key_changed.emit(_has_key)
	###### END DEBUG CODE ########################
#endregion

#region Public Methods
func change_HP(amount : int) -> void:
	_currentHealth += amount
	stats_changed.emit(_currentHealth, _currentMana, _currentStamina)

func change_MP(amount : int) -> void:
	_currentMana += amount
	stats_changed.emit(_currentHealth, _currentMana, _currentStamina)

func change_ST(amount : int) -> void:
	_currentStamina += amount
	stats_changed.emit(_currentHealth, _currentMana, _currentStamina)

func change_active_spell(active_spell : Enums.Spell) -> void:
	_active_spell = active_spell
	spell_switched.emit(_active_spell)

func get_active_spell() -> Enums.Spell:
	return _active_spell

func get_active_item() -> Enums.Item:
	return _active_item

func flip_blocks() -> void:
	flip_block_switch.emit()

func pick_up_key(key_type : Enums.Lock) -> void:
	print (key_type)
	if key_type == Enums.Lock.Red:
		_has_red_key = true
	elif key_type == Enums.Lock.Blue:
		_has_blue_key = true
	elif key_type == Enums.Lock.Green:
		_has_green_key = true
	_has_key += 1
	key_changed.emit(_has_key, key_type)

func use_key(key_type : Enums.Lock) -> void:
	_has_key -= 1
	if key_type == Enums.Lock.Red:
		_has_red_key = false
	if key_type == Enums.Lock.Green:
		_has_green_key = false
	if key_type == Enums.Lock.Blue:
		_has_blue_key = false
	key_changed.emit(_has_key)

func check_for_key(door_type : Enums.Lock) -> bool:
	if door_type == Enums.Lock.Red:
		if _has_red_key == true: return true
		else: return false
	if door_type == Enums.Lock.Blue:
		if _has_blue_key == true: return true
		else: return false
	if door_type == Enums.Lock.Green:
		if _has_green_key == true: return true
		else: return false
	
	return false
#endregion

#region Private Methods
#endregion
