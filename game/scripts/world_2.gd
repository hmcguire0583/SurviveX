extends Node2D  # Attach this to your world scene root

@export var enable_day_night_cycle: bool = true

# Node references
@onready var objective_label: Label = $UI/ObjectiveLabel
@onready var day_night: DayNight = $DayNight
@onready var time_label: Label = $UI/TimeLabel   

var current_enemy = null
var correct_answer = 0

var _prev_whole_hour := -1 

func _ready():
	if enable_day_night_cycle:
		_setup_day_night_cycle()
	else:
		day_night.visible = false
		day_night.process_mode = Node.PROCESS_MODE_DISABLED

	GameManager.enemies_defeated = 0

func _setup_day_night_cycle() -> void:
	day_night.time_changed.connect(_on_time_changed)

func _on_time_changed(hour: float, _time_string: String) -> void:
	if not time_label:
		return

	var whole_hour := int(floor(hour)) % 24

	if _prev_whole_hour != -1 and _prev_whole_hour > whole_hour:
		GameManager.current_day += 1

	_prev_whole_hour = whole_hour

	# 12-hour formatting without minutes
	var display_hour := whole_hour % 12
	if display_hour == 0:
		display_hour = 12
	var am_pm = "AM" if whole_hour < 12 else "PM"

	time_label.text = "Day %d: %d %s" % [GameManager.current_day, display_hour, am_pm]
