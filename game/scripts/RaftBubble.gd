extends Node2D

@onready var dock4 = $"Docks/Dock4"
@onready var answer_timer = $Timer
@onready var timer_label = $NinePatchRect/TimerLabel

signal correct_answer(island_index: int)
signal wrong_answer(island_index: int)


var challenge_active = false
var solutions : Array = []
var current_step : int = 0
var target_island : int = -1
var x1 : int
var y1 : int
var x2 : int
var y2 : int
var time_remaining = 25
var base_time := 25

func _ready():
	randomize()
	visible = false
	$NinePatchRect/SubmitButton.pressed.connect(_on_submit_button_pressed)
	answer_timer.wait_time = 1.0
	answer_timer.one_shot = false
	answer_timer.autostart = false
	answer_timer.timeout.connect(_on_AnswerTimer_timeout)


func start_challenge(island_index: int):
	if challenge_active:
		return
	challenge_active = true
	target_island = island_index
	visible = true
	current_step = 0
	solutions.clear()
	$NinePatchRect/QuestionLabel.text = "Solve to unlock island " + str(island_index + 1)
	$NinePatchRect/QuestionLabel.autowrap_mode = TextServer.AUTOWRAP_WORD
	$NinePatchRect/AnswerInput.visible = false
	$NinePatchRect/SubmitButton.visible = false
	await get_tree().create_timer(1.5).timeout
	
	# Example: two-part question (x-intercept then slope)
	var a = randi_range(2, 10)
	var b = randi_range(-15, 15)
	var x_intercept = -float(b) / float(a)
	solutions.append(x_intercept)
	x1 = randi_range(-10, 10)
	y1 = randi_range(-10, 10)
	x2 = randi_range(-10, 10)
	y2 = randi_range(-10, 10)
	while x1 == x2:
		x2 = randi_range(-10, 10)
	var slope = float(y2 - y1) / float(x2 - x1)
	solutions.append(slope)

	# Ask first part
	$NinePatchRect/QuestionLabel.text = "Part 1:"
	await get_tree().create_timer(1.0).timeout
	$NinePatchRect/QuestionLabel.text = "Find x-intercept of line: " + str(a) + "x + " + str(b) + " = 0"
	$NinePatchRect/AnswerInput.visible = true
	$NinePatchRect/SubmitButton.visible = true
	time_remaining = max(10, base_time - (GameManager.current_day - 1))
	$NinePatchRect/TimerLabel.visible = true
	$NinePatchRect/TimerLabel.text = "Time left: " + str(time_remaining)
	answer_timer.start()
func _on_submit_button_pressed() -> void:
	answer_timer.stop()
	var input = parse_input($NinePatchRect/AnswerInput.text)
	if abs(input - solutions[current_step]) < 0.02:
		if current_step == 0:
			# Move to second part
			$NinePatchRect/QuestionLabel.text = "Correct! Now Part 2: "
			await get_tree().create_timer(1.0).timeout
			$NinePatchRect/QuestionLabel.text = "Find slope of line through (" \
			+ str(x1) + "," + str(y1) + ") and (" + str(x2) + "," + str(y2) + ")"
			current_step += 1
			$NinePatchRect/AnswerInput.text = ""  # clear input
			#TIMER
			time_remaining = max(10, base_time - (GameManager.current_day - 1))
			timer_label.text = "Time left: " + str(time_remaining)
			answer_timer.start()
		else:
			# Finished both parts
			$NinePatchRect/QuestionLabel.text = "Correct! Island unlocked!"
			emit_signal("correct_answer", target_island)
			visible = false
			challenge_active = false
	else:
		$NinePatchRect/QuestionLabel.text = "You got coordinates wrong!"
		await get_tree().create_timer(1.5).timeout
		$NinePatchRect/QuestionLabel.text = "Going to the middle of ocean"
		emit_signal("wrong_answer", target_island)
		visible = false
		challenge_active = false
	
func parse_input(text: String) -> float:
		# Handle fractions like "25/7"
	text = text.strip_edges()
	if "/" in text:
		var parts = text.split("/")
		if parts.size() == 2:
			var numerator_str = parts[0].strip_edges()
			var denominator_str = parts[1].strip_edges()
			var numerator = numerator_str.to_float()
			var denominator = denominator_str.to_float()
			if denominator != 0:
				return numerator / denominator
	# Fallback: normal float
	return text.to_float()
func _on_AnswerTimer_timeout():
	if time_remaining > 0:
		time_remaining -= 1
		$NinePatchRect/TimerLabel.text = "Time left: " + str(time_remaining)
	if time_remaining <= 0:
		time_remaining = 0
		$NinePatchRect/QuestionLabel.text = "Time’s up! Take damage and Try Again"
		await get_tree().create_timer(1.0).timeout
		$NinePatchRect/TimerLabel.visible = false
		var player = get_tree().root.get_node("world/Player")
		player.health -= 10
		player.update_health()
		answer_timer.stop()
		challenge_active = false
		await get_tree().create_timer(1.0).timeout
		$NinePatchRect/TimerLabel.visible = false
		start_challenge(target_island)
