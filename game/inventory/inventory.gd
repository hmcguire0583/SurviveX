extends Resource

class_name Inv

signal update

@export var slots: Array[InvSlot]

func insert(item: InvItem, amount): # enemy drops item or chest drops item, call to insert
	var itemName = item.name
	var addItem = false
	if "arm" in itemName:
		var armorslot = slots.filter(func(slot): return slot.item != null and "arm" in slot.item.name)
		if !armorslot.is_empty():
			armorslot[0].item = item
			addItem = true
	elif "swo" in itemName:
		var axeslot = slots.filter(func(slot): return slot.item != null and "swo" in slot.item.name)
		if !axeslot.is_empty():
			axeslot[0].item = item
			addItem = true
	if not addItem:
		var itemslots = slots.filter(func(slot): return slot.item != null and slot.item.name == item.name)
		if !itemslots.is_empty():
			itemslots[0].amount += amount
		else:
			var emptyslots = slots.filter(func(slot): return slot.item == null)
			emptyslots[0].item = item
			emptyslots[0].amount = amount
	
	update.emit()
	
func remove(item: InvItem, amount): # enemy drops item or chest drops item, call to insert
	var itemslots = slots.filter(func(slot): return slot.item != null and slot.item.name == item.name)
	if !itemslots.is_empty():
		itemslots[0].amount -= amount
		if itemslots[0].amount == 0:
			itemslots[0].item = null
	else:
		var emptyslots = slots.filter(func(slot): return slot.item == null)
		emptyslots[0].item = item
		emptyslots[0].amount = 1
	
	update.emit()
