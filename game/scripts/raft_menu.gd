extends Control

signal island_selected(dock_name: String)

func _ready():
	$Panel/ButtonIsland1.pressed.connect(func(): _on_island_pressed("Dock"))
	$Panel/ButtonIsland2.pressed.connect(func(): _on_island_pressed("Dock2"))
	$Panel/ButtonIsland3.pressed.connect(func(): _on_island_pressed("Dock3"))

func update_unlocks():
	# Example conditions
	$Panel/ButtonIsland1.disabled = false   # always unlocked
	$Panel/ButtonIsland2.disabled = GameManager.enemies_defeated < 1
	$Panel/ButtonIsland3.disabled = GameManager.enemies_defeated < 5

func _on_island_pressed(dock_name: String):
	emit_signal("island_selected", dock_name)
	visible = false
