class_name SpherePool
extends Node

## Чувствительность оси ручки к вводу ui_left/ui_right; масштабирует отклонение перед clamp.
@export var crank_sensitivity: float = 1.0
## Ссылка на доску в сцене; задаётся в инспекторе, без поиска узлов по путям.
@export var board: PachinkoBoard

var pool_count: int = 0

var _crank_held: bool = false
## Текущее отклонение «ручки» после clamp (−1.0…1.0), влияет на угол и силу запуска.
var _crank_value: float = 0.0


func _process(_delta: float) -> void:
	var axis_input: float = Input.get_axis("ui_left", "ui_right") * crank_sensitivity
	_crank_value = clampf(axis_input, -1.0, 1.0)

	if Input.is_action_pressed("ui_accept"):
		_crank_held = true

	if Input.is_action_just_released("ui_accept") and _crank_held:
		_fire()


func add_spheres(amount: int) -> void:
	assert(amount > 0, "Количество добавляемых сфер должно быть положительным")
	pool_count += amount
	SignalBus.pool_sphere_count_changed.emit(pool_count)


func consume_sphere() -> bool:
	if pool_count <= 0:
		return false
	pool_count -= 1
	SignalBus.pool_sphere_count_changed.emit(pool_count)
	return true


func _fire() -> void:
	if board == null:
		push_error("SpherePool: назначь board (PachinkoBoard) в инспекторе")
		_crank_held = false
		return
	if not consume_sphere():
		_crank_held = false
		return

	var angle: float = deg_to_rad(90.0) + _crank_value * deg_to_rad(30.0)
	angle += randf_range(-0.15, 0.15)
	var force: float = 300.0 + abs(_crank_value) * 300.0

	SignalBus.sphere_launched.emit(1)
	board.launch_sphere(force, angle)
	_crank_held = false

func _ready() -> void:
	add_spheres(50)