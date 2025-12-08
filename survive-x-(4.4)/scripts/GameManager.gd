extends Node

var enemies_defeated := 0
var challenge_active := false   # true when any zombie has engaged the player
var current_island : int = 0
var islands_unlocked : int = 0
var current_day := 1
var time = "day"
var unlocked_islands = {
	0: true
}
