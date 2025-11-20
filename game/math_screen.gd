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
		queue_free()  # Close the math screen
	else:
		$Label.text = "Incorrect. Try again!"
