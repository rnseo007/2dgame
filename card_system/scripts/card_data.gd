extends Resource
class_name CardData

@export_group("Base Settings")
@export var id : String
@export var display_name : String
@export var description : String
@export var icon : Texture2D
@export_group("Bullet Property")
@export var hp : int = 1
@export var knock_amount : float
@export var attack_size : float
@export var speed : float
@export var damage : int
@export var collision_size : float = 4.0
@export var material : Material
@export var pacticle_effects : Array[PackedScene]
@export var other_effects : Array[PackedScene]
@export var debuff : Debuff
