class_name Sphere
extends RigidBody2D

const OFF_BOARD_Y: float = 650.0

## Текущее «кровавое» значение сферы после множителей на поле.
@export var value: int = 1
## Базовый визуальный уровень (множитель масштаба вместе с value).
@export var sphere_level: int = 1

var _lost_reported: bool = false

func _ready() -> void:
	_update_scale_from_value()
	# Дочерний Area2D (ContactArea): альтернатива коллизии через пин; не дублируйте зону на пине для той же сферы.
	var contact_area := get_node_or_null(^"ContactArea") as Area2D
	if contact_area != null:
		contact_area.body_entered.connect(_on_body_entered)


func _process(_delta: float) -> void:
	if _lost_reported:
		return
	if global_position.y > OFF_BOARD_Y:
		_lost_reported = true
		SignalBus.sphere_lost_off_board.emit(value)
		queue_free()


## Универсальная формула: значение × уровень элемента; обновляет масштаб и шлёт событие на шину.
func apply_multiplier(element_level: int) -> void:
	assert(element_level > 0, "Уровень элемента должен быть положительным")
	value *= element_level
	_update_scale_from_value()
	SignalBus.sphere_hit_board_element.emit(element_level, value)


func _on_body_entered(body: Node) -> void:
	# Коллизия с пином (корень сцены — StaticBody2D с class_name Pin).
	if body is Pin:
		apply_multiplier((body as Pin).level)


func _update_scale_from_value() -> void:
	# Масштаб растёт с value, но не линейно, чтобы не раздувать спрайт на больших числах.
	var factor: float = sphere_level * (0.35 + 0.08 * sqrt(float(value)))
	factor = clampf(factor, 0.25, 4.0)
	scale = Vector2(factor, factor)


## Для PachinkoBoard: порог по ТЗ — модуль скорости меньше 10.
func is_kinematic_settled() -> bool:
	return linear_velocity.length() < 10.0
