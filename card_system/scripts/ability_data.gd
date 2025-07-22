extends Resource
class_name AbilityData

@export var id: int

@export_category("Debuff Settings")
@export_group("Debuff Settings")
@export var debuff_name : String
@export var debuff_time : float #sec
@export var debuff_damage : int
@export var debuff_pulse_time : float #sec
@export var debuff_color : Color
