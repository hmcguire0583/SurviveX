extends CanvasLayer
signal correct_answer

var current_answer = 0

func _ready():
	randomize()
	generate_question()

func generate_question():
	var a = randi() % 10 + 1
	var b = randi() % 10 + 1
	current_answer = a + b
	$Label.text = "What is %d + %d?" % [a, b]

func _on_button_pressed() -> void:
	var input = $LineEdit.text.to_int()
	if input == current_answer:
		emit_signal("correct_answer")
		queue_free()
	else:
		$Label.text = "Incorrect...You lose. Game Over!"
		await get_tree().create_timer(2.0).timeout
		get_tree().paused = false
		get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
