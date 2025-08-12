extends CharacterBody2D

@onready var hit_anim = $HitAnimationPlayer
@onready var grab_area = $GrabArea/CollisionShape2D
@onready var indicator = $Indicator
var indicator_rotation_offset_degrees : float = 0.0

@export var movement_speed : float = 300
@export var grab_radius : float = 200

#레벨업 시그널 (횟수)
signal levelup(count : int)

var hp = 10
var cur_xp : int = 0
var max_xp : int = 10

#level
var level : int = 1
var level_up_count : int = 0

func _ready() -> void:
	grab_area_set()

func _physics_process(_delta):
	movement()

func movement():
	#set direction to input
	var direction := Vector2(Input.get_axis("move_left","move_right"), Input.get_axis("move_up","move_down"))
	
	if direction:
		velocity = direction.normalized() * movement_speed
		$AnimationTree.get("parameters/playback").travel("Walk")
		$AnimationTree.set("parameters/Idle/blend_position", velocity.x)
		$AnimationTree.set("parameters/Walk/blend_position", velocity.x)
		move_and_slide()
	else:
		$AnimationTree.get("parameters/playback").travel("Idle")

func _on_get_damage(dmg : int) -> void:
	hp -= dmg
	hit_anim.stop()
	hit_anim.play("Hit")

#아이템 끌어오는 에어리어 범위 감지
func _on_grab_area_area_entered(area: Area2D) -> void:
	if area.is_in_group("Loot"):
		area.target = self

#아이템 먹는 에어리어 범위 감지
func _on_collect_area_area_entered(area: Area2D) -> void:
	if area.is_in_group("Loot"):
		var gxp = area.collect()
		calculate_experience(gxp)

func calculate_experience(gotxp : int):
	cur_xp += gotxp
	#레벨업
	while cur_xp >= max_xp:
		level_up()
	#레벨업 시그널 + 횟수
	if level_up_count > 0:
		levelup.emit(level_up_count)
		level_up_count = 0

func level_up():
	cur_xp -= max_xp
	level += 1
	max_xp += level**2 - level*2
	level_up_count += 1 #레벨업 횟수 증가

#아이템 수집 범위 설정
func grab_area_set():
	grab_area.shape.radius = grab_radius

#공격 인디케이터 로테이션
func rotate_indicator(target_pos : Vector2):
	var dir := target_pos - global_position
	indicator.rotation = dir.angle() + deg_to_rad(indicator_rotation_offset_degrees)
