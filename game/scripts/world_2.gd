extends Node2D

@export var time_limit := 2400  # seconds
@onready var level_timer := $LevelTimer
@onready var timer_label := $TimerLabel
@onready var objective_label := $CanvasLayer2/ObjectiveLabel
@onready var day_night : DayNight = $DayNight
@onready var time_label: Label = $TimeLabel
@export var enable_day_night_cycle: bool = true

var current_enemy = null
var correct_answer = 0

func _ready():
	if enable_day_night_cycle:
		_setup_day_night_cycle()
	else:
		day_night.visible = false
		day_night.process_mode = Node.PROCESS_MODE_DISABLED
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
func _setup_day_night_cycle() -> void:
	day_night.time_changed.connect(_on_time_changed)

func _on_time_changed(_hour: float, time_string: String) -> void:
	if time_label:
		time_label.text = time_string
		
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

	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
