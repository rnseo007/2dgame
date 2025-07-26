extends Resource
class_name Debuff

@export_category("Debuff Settings")
@export_group("Debuff Settings")
@export var name : String
@export var damage : int
@export var type := DebuffType.type.DAMAGE
@export var duration : float #sec
@export var pulse_time : float #sec
@export var color : Color = Color(1,1,1)
