extends Node2D

signal correct_answer(dock_name: String)
signal wrong_answer(dock_name: String)

var a : int
var b : int
var c : int
var solution : float
var target_dock : String = ""

func _ready():
	randomize()
	visible = false
	$NinePatchRect/SubmitButton.pressed.connect(_on_submit_button_pressed)

func start_challenge(dock_name: String):
	target_dock = dock_name
	visible = true

	# Initial message
	$NinePatchRect/QuestionLabel.text = "Solve to unlock " + dock_name
	$NinePatchRect/QuestionLabel.autowrap_mode = TextServer.AUTOWRAP_WORD
	$NinePatchRect/QuestionLabel.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	$NinePatchRect/QuestionLabel.size_flags_vertical = Control.SIZE_EXPAND_FILL

	# Adjust balloon size to fit text
	var needed_size = $NinePatchRect/QuestionLabel.get_minimum_size()
	$NinePatchRect.custom_minimum_size = needed_size + Vector2(40, 80)

	$NinePatchRect/AnswerInput.visible = false
	$NinePatchRect/SubmitButton.visible = false
	await get_tree().create_timer(1.5).timeout
	var question_type = randi() % 3   # 0 = linear equation, 1 = slope, 2 = x-intercept
	
	if question_type == 0:
		# Linear equation: ax + b = c
		var a = randi_range(1, 9)
		var b = randi_range(-9, 9)
		var x_val = randi_range(-9, 9)
		var c = a * x_val + b        # calculate c
		solution = float(x_val)
		$NinePatchRect/QuestionLabel.text = str(a) + "x + " + str(b) + " = " + str(c)
	
	elif question_type == 1:
		# Slope of line through two points
		var x1 = randi_range(1, 9)
		var y1 = randi_range(1, 9)
		var x2 = randi_range(1, 9)
		var y2 = randi_range(1, 9)
		while x1 == x2:   # avoid division by zero
			x2 = randi_range(1, 9)
		solution = float(y2 - y1) / float(x2 - x1)
		$NinePatchRect/QuestionLabel.text = "Find slope of line through (" + str(x1) + "," + str(y1) + ") and (" + str(x2) + "," + str(y2) + ")"
		
	else:
		# X-intercept of ax + b = 0
		var a = randi_range(1, 9)
		var b = randi_range(-9, 9)
		solution = -float(b) / float(a)
		$NinePatchRect/QuestionLabel.text = "Find x-intercept of line: " + str(a) + "x + " + str(b) + " = 0"

	# Show input after question is ready
	$NinePatchRect/AnswerInput.visible = true
	$NinePatchRect/SubmitButton.visible = true
	print("DEBUG: Question =", $NinePatchRect/QuestionLabel.text, " | Solution =", solution)
func _on_submit_button_pressed() -> void:
	var input = parse_input($NinePatchRect/AnswerInput.text)
	if abs(input - solution) < 0.01:
		$NinePatchRect/QuestionLabel.text = "Correct!"
		emit_signal("correct_answer", target_dock)
		visible = false
	else:
		$NinePatchRect/QuestionLabel.text = "Attack by shark! Try again..."
		emit_signal("wrong_answer", target_dock)
		await get_tree().create_timer(1.5).timeout
		start_challenge(target_dock)
		
func parse_input(text: String) -> float:
		# Handle fractions like "25/7"
	if "/" in text:
		var parts = text.split("/")
		if parts.size() == 2:
			var numerator = parts[0].to_float()
			var denominator = parts[1].to_float()
			if denominator != 0:
				return numerator / denominator
	# Fallback: normal float
	return text.to_float()
