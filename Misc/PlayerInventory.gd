extends Node

signal active_item_updated

const SlotClass = preload("res://Slot.gd")
const ItemClass = preload("res://Item.gd")
const NUM_INVENTORY_SLOTS = 80
const NUM_HOTBAR_SLOTS = 10

var inventory = {
	#0: ["Healing Potion", 54], #--> slot_index: [item_name, item_quantity]
	#1: ["Healing Potion", 12],
}

var hotbar = {
	0: ["Iron Sword", 1], #--> slot_index: [item_name, item_quantity]
	1: ["Steel Sword", 1],
	2: ["Healing Potion", 67]
}

var equips = {
#	0: ["Blue Jacket", 1], #--> slot_index: [item_name, item_quantity]
#	1: ["Black Jeans", 1],
#	2: ["Blue Shoes", 1],
}

var active_item_slot = 0 #Index of active item for hotbar

func add_item(item_name, item_quantity):
	for item in inventory:
		if inventory[item][0] == item_name:
			var stack_size = int(JsonData.item_data[item_name]["StackSize"])
			var able_to_add = stack_size - inventory[item][1]
			if able_to_add >= item_quantity:
				inventory[item][1] += item_quantity
				update_slot_visual(item, inventory[item][0], inventory[item][1])
				return
			else:
				inventory[item][1] += able_to_add
				update_slot_visual(item, inventory[item][0], inventory[item][1])
				item_quantity = item_quantity - able_to_add
			
	
	#If item does not exist so it makes an empty slot
	for i in range(NUM_INVENTORY_SLOTS):
		if inventory.has(i) == false:
			inventory[i] = [item_name, item_quantity]
			update_slot_visual(i, inventory[i][0], inventory[i][1])
			return
			
func update_slot_visual(slot_index, item_name,  new_quantity):
	var slot = get_tree().root.get_node("/root/World/UserInterface/Inventory/GridContainer/Slot" + str(slot_index + 1))
	if slot.item != null:
		slot.item.set_item(item_name, new_quantity)
	else:
		slot.initialize_item(item_name, new_quantity)

func remove_item(slot: SlotClass):
	match slot.slot_type:
		SlotClass.SlotType.HOTBAR:
			hotbar.erase(slot.slot_index)
		SlotClass.SlotType.INVENTORY:
			inventory.erase(slot.slot_index)
		SlotClass.SlotType.SHIRT:
			equips.erase(slot.slot_index)
			#If player takes off a shirt
			Globalvars.is_wearing_shirt = false
			Globalvars.is_blue_jacket_equipped = false
			Globalvars.is_black_shirt_equipped = false
			Globalvars.is_red_shirt_equipped = false
		SlotClass.SlotType.PANTS:
			equips.erase(slot.slot_index)
			#If player takes off pants
			Globalvars.is_wearing_pants = false
			Globalvars.is_black_jeans_equipped = false
			Globalvars.is_blue_jeans_equipped = false
		SlotClass.SlotType.SHOES:
			equips.erase(slot.slot_index)
			#If player takes off shoes
			Globalvars.is_wearing_shoes = false
			Globalvars.is_blue_shoes_equipped = false
			Globalvars.is_black_shoes_equipped = false
			Globalvars.is_red_shoes_equipped = false
		_:
			equips.erase(slot.slot_index)
			
func add_item_to_empty_slot(item: ItemClass, slot: SlotClass):
	match slot.slot_type:
		SlotClass.SlotType.HOTBAR:
			hotbar[slot.slot_index] = [item.item_name, item.item_quantity]
		SlotClass.SlotType.INVENTORY:
			inventory[slot.slot_index] = [item.item_name, item.item_quantity]
		SlotClass.SlotType.SHIRT:
			equips[slot.slot_index] = [item.item_name, item.item_quantity]
			#If player puts on a shirt
			Globalvars.is_wearing_shirt = true
			if equips[0] == ["Blue Jacket", 1]:
				Globalvars.is_blue_jacket_equipped = true
			if equips[0] == ["Black Shirt", 1]:
				Globalvars.is_black_shirt_equipped = true
			if equips[0] == ["Red Shirt", 1]:
				Globalvars.is_red_shirt_equipped = true
					
		SlotClass.SlotType.PANTS:
			equips[slot.slot_index] = [item.item_name, item.item_quantity]
			#If player puts on pants	
			Globalvars.is_wearing_pants = true		
			if equips[1] == ["Black Jeans", 1]:
				Globalvars.is_black_jeans_equipped = true
			if equips[1] == ["Blue Jeans", 1]:
				Globalvars.is_blue_jeans_equipped = true
		SlotClass.SlotType.SHOES:
			equips[slot.slot_index] = [item.item_name, item.item_quantity]
			#If player puts on shoes
			Globalvars.is_wearing_shoes = true
			if equips[2] == ["Blue Shoes", 1]:
				Globalvars.is_blue_shoes_equipped = true
			if equips[2] == ["Black Shoes", 1]:
				Globalvars.is_black_shoes_equipped = true
			if equips[2] == ["Red Shoes", 1]:
				Globalvars.is_red_shoes_equipped = true
		_:
			equips[slot.slot_index] = [item.item_name, item.item_quantity]
			
func add_item_quantity(slot: SlotClass, quantity_to_add: int):
	match slot.slot_type:
		SlotClass.SlotType.HOTBAR:
			hotbar[slot.slot_index][1] += quantity_to_add
		SlotClass.SlotType.INVENTORY:
			inventory[slot.slot_index][1] += quantity_to_add
		_:
			equips[slot.slot_index][1] += quantity_to_add
	
#HOTBAR FUNCTIONS
#Scroll through slots	
func active_item_scroll_up():
	if Globalvars.in_inventory == false:
		active_item_slot = (active_item_slot + 1) % NUM_HOTBAR_SLOTS
		emit_signal("active_item_updated")
	
func active_item_scroll_down():
	if Globalvars.in_inventory == false:
		if active_item_slot == 0:
			active_item_slot = NUM_HOTBAR_SLOTS - 1
		else:
			active_item_slot -= 1
		emit_signal("active_item_updated")
		
#So number keys work to go to different slots
func first_slot():
	if Globalvars.in_inventory == false:
		active_item_slot = 0
		emit_signal("active_item_updated")
	
func second_slot():
	if Globalvars.in_inventory == false:
		active_item_slot = 1
		emit_signal("active_item_updated")

func third_slot():
	if Globalvars.in_inventory == false:
		active_item_slot = 2
		emit_signal("active_item_updated")
		
func fourth_slot():
	if Globalvars.in_inventory == false:
		active_item_slot = 3
		emit_signal("active_item_updated")
	
func fifth_slot():
	if Globalvars.in_inventory == false:
		active_item_slot = 4
		emit_signal("active_item_updated")
	
func sixth_slot():
	if Globalvars.in_inventory == false:
		active_item_slot = 5
		emit_signal("active_item_updated")
	
func seventh_slot():
	if Globalvars.in_inventory == false:
		active_item_slot = 6
		emit_signal("active_item_updated")
	
func eighth_slot():
	if Globalvars.in_inventory == false:
		active_item_slot = 7
		emit_signal("active_item_updated")
	
func nineth_slot():
	if Globalvars.in_inventory == false:
		active_item_slot = 8
		emit_signal("active_item_updated")
	
func tenth_slot():
	if Globalvars.in_inventory == false:
		active_item_slot = 9
		emit_signal("active_item_updated")
		
	

