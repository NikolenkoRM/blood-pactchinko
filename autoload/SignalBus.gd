@warning_ignore("unused_signal")
extends Node
## Центральная шина сигналов: только объявления, без логики.
## Вся межсистемная коммуникация идёт через эти сигналы.

# --- Пачинко: сферы, доска, сессия, выигрыш ---
signal sphere_launched(sphere_value: int)
signal sphere_hit_board_element(element_level: int, new_sphere_value: int)
signal sphere_entered_pocket(pocket_id: StringName, sphere_value: int)
signal sphere_lost_off_board(sphere_value: int)
signal pool_sphere_count_changed(count: int)
signal win_bank_changed(total: int)
signal pachinko_session_started()
signal pachinko_session_ended()
signal all_spheres_settled()
signal bonus_game_triggered(pocket_id: StringName)

# --- Devil's Gaze: давление 0–100 и штрафы ---
signal devils_gaze_changed(pressure: float)
signal devils_gaze_reset()
signal devils_gaze_penalty_applied(subtracted_from_bank: int)

# --- Квота раунда (логика выплаты, не путать с game_quota_changed в GameState) ---
signal quota_progress_updated(collected: int, required: int)
signal quota_paid(excess_blood: int)
signal quota_failed()

# --- Магазин между раундами ---
signal shop_opened()
signal shop_closed()
signal shop_item_purchased(item_id: StringName, price_paid: int)
signal shop_purchase_failed(item_id: StringName, reason: StringName)

# --- Инвентарь ---
signal inventory_changed()
signal inventory_item_added(item: Resource, slot_index: int)
signal inventory_item_removed(item: Resource, slot_index: int)
signal inventory_slot_selected(slot_index: int)

# --- Мини-игры ---
signal minigame_offer_presented(minigame_id: StringName)
signal minigame_started(minigame_id: StringName)
signal minigame_finished(minigame_id: StringName, success: bool)
signal minigame_reward_applied(minigame_id: StringName, reward_summary: StringName)

# --- Глобальное состояние (эмитит GameState) ---
signal round_changed(new_round: int)
signal game_quota_changed(new_quota: int)
## Значение совпадает с ординалом GameState.GamePhase (enum как int).
signal game_phase_changed(new_phase: int)
