class_name Pin
extends StaticBody2D

## Уровень пина — множитель при попадании сферы (формула в Sphere.apply_multiplier).
@export var level: int = 1

func _ready() -> void:
	assert(level > 0, "Уровень пина должен быть положительным")
	var hit_area := get_node_or_null(^"HitArea") as Area2D
	if hit_area == null:
		push_error("Pin: добавьте дочерний узел Area2D с именем HitArea для регистрации попаданий сферы.")
		return
	hit_area.body_entered.connect(_on_hit_area_body_entered)


func _on_hit_area_body_entered(body: Node) -> void:
	if not (body is Sphere):
		return
	var sphere := body as Sphere
	sphere.apply_multiplier(level)
