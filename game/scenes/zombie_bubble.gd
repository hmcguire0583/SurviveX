extends Node2D

signal correct_answer
signal wrong_answer

@onready var answer_timer = $Timer
@onready var timer_label = $NinePatchRect/TimerLabel
@onready var question_label = $NinePatchRect/QuestionLabel
@onready var answer_input = $NinePatchRect/AnswerInput
@onready var submit_button = $NinePatchRect/SubmitButton

var a : int
var b : int
var c : int
var solution : int
var time_remaining = 20

func _ready():
	randomize()
	answer_timer.wait_time = 1.0
	answer_timer.one_shot = false
	answer_timer.autostart = false
	answer_timer.timeout.connect(_on_AnswerTimer_timeout)
	visible = false

func start_challenge():
	var variable = get_random_char('m', 'z')
	visible = true
	question_label.text = "GrRR!....\n(Solve for " + variable + ")"
	answer_input.visible = false
	submit_button.visible = false

	await get_tree().create_timer(1.5).timeout

	a = randi_range(1, 9)
	b = randi_range(1, 9)
	var x_val = randi_range(1, 9)
	c = a * x_val + b
	solution = x_val

	# Reset player input here
	answer_input.text = ""

	question_label.text = str(a) + variable + " + " + str(b) + " = " + str(c)
	answer_input.visible = true
	submit_button.visible = true
	time_remaining = max(10, 20 - (GameManager.current_day - 1))
	timer_label.visible = true
	timer_label.text = "Time left: " + str(time_remaining)
	answer_timer.start()

func _on_SubmitButton_pressed():
	timer_label.visible = false
	answer_timer.stop()
	var input = answer_input.text.to_int()
	if input == solution:
		question_label.text = "Correct!"
		print("Correct!")   # Debug check
		emit_signal("correct_answer")
	else:
		question_label.text = "Wrong!"
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

func _on_AnswerTimer_timeout():
	if time_remaining > 0:
		time_remaining -= 1
		timer_label.text = "Time left: " + str(time_remaining)

	if time_remaining <= 0:
		time_remaining = 0
		timer_label.visible = false
		question_label.text = "Time’s up!"
		emit_signal("wrong_answer")
		answer_timer.stop()
		visible = false
