extends Node2D  # Attach this to your world scene root

@export var enable_day_night_cycle: bool = true

# Node references
@onready var objective_label: Label = $UI/ObjectiveLabel
@onready var day_night: DayNight = $DayNight
@onready var time_label: Label = $UI/TimeLabel   # directly under UI

var current_enemy = null
var correct_answer = 0

func _ready():
	if enable_day_night_cycle:
		_setup_day_night_cycle()
	else:
		day_night.visible = false
		day_night.process_mode = Node.PROCESS_MODE_DISABLED

	GameManager.enemies_defeated = 0

func _setup_day_night_cycle() -> void:
	day_night.time_changed.connect(_on_time_changed)

func _on_time_changed(_hour: float, time_string: String) -> void:
	if time_label:
		time_label.text = time_string
