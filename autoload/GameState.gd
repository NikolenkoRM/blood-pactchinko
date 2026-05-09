extends Node
## Глобальное состояние раунда и фазы игры; UI не мутирует напрямую — только через сеттеры и сигналы.

enum GamePhase {
	SHOP,
	BOARD_SETUP,
	PACHINKO,
	PAYOUT,
}

var _current_round: int = 1
var _current_quota: int = 50
var _phase: GamePhase = GamePhase.BOARD_SETUP

var player: PlayerData = PlayerData.new()

var current_round: int:
	get:
		return _current_round
	set(value):
		assert(value > 0, "Номер раунда должен быть положительным")
		if _current_round == value:
			return
		_current_round = value
		SignalBus.round_changed.emit(_current_round)

var current_quota: int:
	get:
		return _current_quota
	set(value):
		assert(value >= 0, "Квота не может быть отрицательной")
		if _current_quota == value:
			return
		_current_quota = value
		SignalBus.game_quota_changed.emit(_current_quota)

var phase: GamePhase:
	get:
		return _phase
	set(value):
		if _phase == value:
			return
		_phase = value
		SignalBus.game_phase_changed.emit(int(_phase))


func _ready() -> void:
	# Убеждаемся что PlayerData создан с правильными дефолтами
	assert(player.hp == 20, "Неверные стартовые HP")
	assert(player.blood_spheres == 50, "Неверный стартовый запас сфер")
