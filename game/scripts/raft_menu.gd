extends Control

signal island_selected(island_index: int)

func _ready():
	$Panel/ButtonIsland1.pressed.connect(func(): _on_island_pressed(0))
	$Panel/ButtonIsland2.pressed.connect(func(): _on_island_pressed(1))
	$Panel/ButtonIsland3.pressed.connect(func(): _on_island_pressed(2))

func update_unlocks():
	# Example conditions
	$Panel/ButtonIsland1.disabled = false   # always unlocked
	$Panel/ButtonIsland2.disabled = GameManager.enemies_defeated < 1
	$Panel/ButtonIsland3.disabled = GameManager.enemies_defeated < 5

func _on_island_pressed(index: int):
	emit_signal("island_selected", index)
	visible = false
