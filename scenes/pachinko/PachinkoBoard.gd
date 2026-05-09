class_name PachinkoBoard
extends Node2D

const SPHERE_SCENE_PATH: String = "res://scenes/pachinko/Sphere.tscn"

## Сцена сферы; если пусто, выполняется load(SPHERE_SCENE_PATH) при первом запуске.
@export var sphere_scene: PackedScene
## Смещение точки появления сферы относительно позиции доски.
@export var launch_offset: Vector2 = Vector2.ZERO

var _active_spheres: Array[Sphere] = []
var _settled_emitted: bool = false


func _process(_delta: float) -> void:
	_compact_dead_spheres()
	if _active_spheres.is_empty():
		return
	var all_settled := true
	for sphere in _active_spheres:
		if not is_instance_valid(sphere):
			continue
		if not sphere.is_kinematic_settled():
			all_settled = false
			break
	if all_settled and not _settled_emitted:
		_settled_emitted = true
		SignalBus.all_spheres_settled.emit()


func launch_sphere(force: float, angle: float) -> void:
	assert(force >= 0.0, "Сила запуска не может быть отрицательной")
	var packed: PackedScene = sphere_scene
	if packed == null:
		packed = load(SPHERE_SCENE_PATH) as PackedScene
	if packed == null:
		push_error("Не удалось загрузить сцену сферы: назначь sphere_scene или создай %s" % SPHERE_SCENE_PATH)
		return
	var instance := packed.instantiate()
	if not (instance is Sphere):
		push_error("sphere_scene должна указывать на сцену с корнем Sphere")
		instance.queue_free()
		return
	var sphere := instance as Sphere
	add_child(sphere)
	sphere.global_position = global_position + launch_offset
	var direction := Vector2.from_angle(angle)
	sphere.apply_central_impulse(direction * force)
	_active_spheres.append(sphere)
	_settled_emitted = false
	sphere.tree_exiting.connect(_on_sphere_tree_exiting.bind(sphere))


func _on_sphere_tree_exiting(sphere: Sphere) -> void:
	_active_spheres.erase(sphere)


func _compact_dead_spheres() -> void:
	var alive: Array[Sphere] = []
	for sphere in _active_spheres:
		if is_instance_valid(sphere):
			alive.append(sphere)
	_active_spheres = alive
