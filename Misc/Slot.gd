extends Panel

#A slot that contains an item
var default_tex = preload("res://Inventory Slot.png")

#A empty slot
var empty_tex = preload("res://Empty Slot.png")

#Selected slot
var selected_tex = preload("res://hotbar selected slot.png")

var default_style: StyleBoxTexture = null
var empty_style: StyleBoxTexture = null
var selected_style: StyleBoxTexture = null

var ItemClass = preload("res://Item.tscn")
var item = null
var slot_index
var slot_type

enum SlotType {
	HOTBAR = 0,
	INVENTORY,
	SHIRT,
	PANTS,
	SHOES,
}

func _ready():
	#Displays texture of the slots
	default_style = StyleBoxTexture.new()
	empty_style = StyleBoxTexture.new()
	selected_style = StyleBoxTexture.new()
	default_style.texture = default_tex
	empty_style.texture = empty_tex
	selected_style.texture = selected_tex
	
#	if randi() % 2 == 0:
#		item = ItemClass.instance()
#		add_child(item)
	refresh_style()
	
func refresh_style():
	#If we are hovering over a slot in our hotbar
	if SlotType.HOTBAR == slot_type and PlayerInventory.active_item_slot == slot_index:
		set('custom_styles/panel', selected_style)
	
	#If there is no item in a slot
	elif item == null:
		set('custom_styles/panel', empty_style)
	
	#Shows item in a slot
	else:
		set('custom_styles/panel', default_style)
	
func pickFromSlot():
	#Removes item when you click on it
	remove_child(item) 
	var inventoryNode = find_parent("UserInterface")
	inventoryNode.add_child(item)
	item = null
	refresh_style()
	
		
func putIntoSlot(new_item):
	item = new_item
	item.position = Vector2(0, 0)
	var inventoryNode = find_parent("UserInterface")
	inventoryNode.remove_child(item) #Removes item where our mouse is
	add_child(item) #Adds it to the slot
	refresh_style()
	
func initialize_item(item_name, item_quantity):
	if item == null:
		item = ItemClass.instance()
		add_child(item)
		item.set_item(item_name, item_quantity)
	else:
		item.set_item(item_name, item_quantity)
	refresh_style()


