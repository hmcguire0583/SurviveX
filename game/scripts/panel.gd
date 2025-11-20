extends Panel

func show_equation(eq: String):
	$Label.text = eq
	visible = true
	get_tree().paused = true   # optional: freeze the game
func hide_equation():
	visible = false
	get_tree().paused = false
func create_random_equation() -> String:
	var a = randi() % 10
	var b = randi() % 10
	return "%d + %d = ?" % [a, b]
