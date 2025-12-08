extends Node2D

signal correct_answer(dock_name: String)
signal wrong_answer(dock_name: String)

var a : int
var b : int
var c : int
var solution : int
var target_dock : String = ""

func _ready():
	randomize()
	visible = false
	$NinePatchRect/SubmitButton.pressed.connect(_on_submit_button_pressed)

func start_challenge(dock_name: String):
	target_dock = dock_name
	visible = true
	$NinePatchRect/QuestionLabel.text = "Solve to unlock " + dock_name
	$NinePatchRect/AnswerInput.visible = false
	$NinePatchRect/SubmitButton.visible = false

	await get_tree().create_timer(1.5).timeout

	a = randi_range(1, 9)
	b = randi_range(1, 9)
	var x_val = randi_range(1, 9)
	c = a * x_val + b
	solution = x_val

	$NinePatchRect/QuestionLabel.text = str(a) + "x + " + str(b) + " = " + str(c)
	$NinePatchRect/AnswerInput.visible = true
	$NinePatchRect/SubmitButton.visible = true

func _on_submit_button_pressed() -> void:
	var input = $NinePatchRect/AnswerInput.text.to_int()
	if input == solution:
		$NinePatchRect/QuestionLabel.text = "Correct!"
		emit_signal("correct_answer", target_dock)
	else:
		$NinePatchRect/QuestionLabel.text = "Wrong!"
		emit_signal("wrong_answer", target_dock)
	visible = false
