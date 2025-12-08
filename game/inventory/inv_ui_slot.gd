extends Panel


@onready var item_visual: Sprite2D = $CenterContainer/Panel/item_display
@onready var amount_text: Label = $CenterContainer/Panel/Label

func update(slot: InvSlot):
	if !slot.item:
		item_visual.visible = false
		amount_text.visible = false
	else:
		if slot.item.name == "wood":
			item_visual.scale = Vector2(1.0, 1.0)
		elif slot.item.name == "nightvision":
			item_visual.scale = Vector2(0.09, 0.09)
		else:
			item_visual.scale = Vector2(0.37, 0.37)
		item_visual.visible = true
		item_visual.texture = slot.item.texture
		if slot.amount > 1:
			amount_text.visible = true
		amount_text.text = str(slot.amount)
