extends Node2D

var unlocked_docks = {
	"Dock": true,   # starting island always unlocked
	"Dock2": false,
	"Dock3": false
}

func unlock_dock(name: String):
	if unlocked_docks.has(name):
		unlocked_docks[name] = true

func is_unlocked(name: String) -> bool:
	return unlocked_docks.get(name, false)
