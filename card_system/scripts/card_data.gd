extends Resource
class_name CardData

@export_group("Base Settings")
@export var id : String
@export var display_name : String
@export var description : String
@export var icon : Texture2D
@export_group("Bullet Property")
@export var knock_amount : float
@export var attack_size : float
@export var speed : float
@export var damage : int
@export var material : Material
@export var pacticles : Array[PackedScene]
@export var abilities: Array[AbilityData]
