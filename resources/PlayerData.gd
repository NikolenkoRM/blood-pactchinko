class_name PlayerData
extends Resource
## Сериализуемые данные игрока: здоровье, кровь-сферы, золото и предметы.

@export var hp: int = 20 ## Текущее HP; расходуется при жертвах и получении урона.
@export var max_hp: int = 20 ## Верхняя граница HP для лечения и отображения.
@export var blood_spheres: int = 50 ## Сферы крови для пула пачинко и выплат.
@export var gold: int = 0 ## Валюта магазина между раундами.
@export var inventory: Array[Resource] = [] ## Стек предметов/апгрейдов (конкретные типы задаются отдельными Resource-классами).
