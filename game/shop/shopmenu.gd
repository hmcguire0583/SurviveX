extends StaticBody2D

@export var items: Array[InvItem]

var item = 0
var animNames = ["armor1", "armor2", "armor3", "sword2", "sword3", "nightvision"]
var prices = {
	"armor1": {"wood": 20, "scrap": 5},
	"armor2": {"wood": 40, "scrap": 15},
	"armor3": {"wood": 70, "scrap": 30},
	"sword2": {"wood": 25, "scrap": 10},
	"sword3": {"wood": 50, "scrap": 30},
	"nightvision": {"wood": 25, "scrap": 25}
}

var price = prices["armor1"]
var itemsBought: Array[String] = []
var player = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$icon.play(animNames[item])
	item = 0
	
func _physics_process(delta: float) -> void:
	if self.visible == true:
		if animNames[item] == "nightvision":
			$icon.scale = Vector2(0.6, 0.6)
		else:
			$icon.scale = Vector2(2.194, 2.188)
		$icon.play(animNames[item])
		var itemName = animNames[item]
		$woodpricelabel.text = str(prices[itemName]["wood"])
		$scrappricelabel.text = str(prices[itemName]["scrap"])
		
		if player != null:
			var inv = player.getInventory().slots
			for i in inv:
				if i.item != null:
					print(i.item.name)
			var wood = inv.filter(func(slot): slot.item != null and slot.item.name == "wood")
			var scrap = inv.filter(func(slot): slot.item != null and slot.item.name == "scrap")
			
			if wood.is_empty() or scrap.is_empty():
				print("no wood or no scrap")
				$buybuttoncolor.color = "6e0012"
			elif wood[0] >= price["wood"] and scrap[0] >= price["scrap"]:
				print("wood: ", wood[0], " | scrap: ", scrap[0])
				$buybuttoncolor.color = "456d33"
			else:
				$buybuttoncolor.color = "6e0012"		


func _on_buttonleft_pressed() -> void:
	swap_item_back()
func _on_buttonright_pressed() -> void:
	swap_item_forward()
func _on_buybutton_pressed() -> void:	
	var inv = player.getInventory().slots
	var wood = inv.filter(func(slot): slot.item != null and slot.item.name == "wood")
	var scrap = inv.filter(func(slot): slot.item != null and slot.item.name == "scrap")
	
	if not(wood.is_empty() or scrap.is_empty()):
		if wood[0] >= price["wood"] and scrap[0] >= price["scrap"]:
			buy()
	
func swap_item_back():
	if item == 0:
		item = animNames.size() - 1
	else:
		item -= 1
	price = prices[animNames[item]]
		
func swap_item_forward():
	item = (item + 1) % animNames.size()
	price = prices[animNames[item]]


func buy():
	var itemBought = items.filter(func(i): return i != null and i.name == animNames[item])
	print("bought: ", animNames[item])
	player.collect(itemBought[0])


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.has_method("player_shop_method"):
		player = body
		print("player entered")
		
		var wood = items.filter(func(i): return i != null and i.name == "wood")
		var scrap = items.filter(func(i): return i != null and i.name == "scrap")
		for i in range(200):
			player.collect(wood[0])
			player.collect(scrap[0])
