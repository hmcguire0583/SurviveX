extends Node2D

@export var time_limit := 30  # seconds
@onready var level_timer := $LevelTimer
@onready var timer_label := $TimerLabel
@onready var objective_label := $CanvasLayer2/ObjectiveLabel

var current_enemy = null
var correct_answer = 0

func _ready():
	GameManager.enemies_defeated = 0
	if level_timer:
		level_timer.wait_time = time_limit
		level_timer.one_shot = true
		level_timer.start()
		level_timer.timeout.connect(_on_time_out)
		objective_label.text = "Objective: Solve Math Questions to Defeat All Enemies"
	else:
		push_error("LevelTimer node not found!")

	# Initialize the label
	if timer_label:
		timer_label.text = str(time_limit) + "s"

func _process(delta):
	if level_timer:
		timer_label.text = str(ceil(level_timer.time_left)) + "s"

func _on_time_out():
	print("Time's up! Going back to Main Menu!")
	# Optional: update the label
	if timer_label:
		timer_label.text = "GAME OVER"
	# Change scene to Main Menu
	get_tree().paused = false

	get_tree().change_scene_to_file("res://main_menu.tscn")
