extends Node2D

signal correct_answer
signal wrong_answer


var a : int
var b : int
var c : int
var solution : int

func _ready():
	randomize()

func start_challenge():
	var variable = get_random_char('m', 'z')
	visible = true
	$NinePatchRect/QuestionLabel.text = "GrRR!....\n(Solve for " + variable + ")"
	$NinePatchRect/AnswerInput.visible = false
	$NinePatchRect/SubmitButton.visible = false

	await get_tree().create_timer(1.5).timeout

	a = randi_range(1, 9)
	b = randi_range(1, 9)
	var x_val = randi_range(1, 9)
	c = a * x_val + b
	solution = x_val

	$NinePatchRect/QuestionLabel.text = str(a) + variable + " + " + str(b) + " = " + str(c)
	$NinePatchRect/AnswerInput.visible = true
	$NinePatchRect/SubmitButton.visible = true

func _on_SubmitButton_pressed():
	var input = $NinePatchRect/AnswerInput.text.to_int()
	if input == solution:
		$NinePatchRect/QuestionLabel.text = "Correct!"
		print("Correct!")   # Debug check
		emit_signal("correct_answer")
	else:
		$NinePatchRect/QuestionLabel.text = "Wrong!"
		print("Wrong!")     # Debug check
		emit_signal("wrong_answer")
		
func get_random_char(start_char: String, end_char: String) -> String:
	# Validate input
	if start_char.length() != 1 or end_char.length() != 1:
		push_error("Both inputs must be single characters.")
		return ""
	
	var start_code = start_char.unicode_at(0)
	var end_code = end_char.unicode_at(0)

	# Ensure start <= end
	if start_code > end_code:
		var temp = start_code
		start_code = end_code
		end_code = temp

	var random_code = randi_range(start_code, end_code)
	return String.chr(random_code)
