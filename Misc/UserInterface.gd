extends CanvasLayer

var holding_item = null

func _input(event):
	if PlayerStats.health > 0:
		if event.is_action_pressed("Inventory"):
			#Player can't move while in inventory
			Globalvars.in_inventory = true
			$Inventory.visible = !$Inventory.visible
			
			#Player can move if they exit inventory
			if !$Inventory.visible:
				Globalvars.in_inventory = false
			
			#Updates inventory
			$Inventory.initialize_inventory()
			
		#Hotbar functions
		if event.is_action_pressed("scroll_up"):
			PlayerInventory.active_item_scroll_up()
			
		elif event.is_action_pressed("scroll_down"):
			PlayerInventory.active_item_scroll_down()
		
		elif event.is_action_pressed("first_slot"):
			PlayerInventory.first_slot()
			
		elif event.is_action_pressed("second_slot"):
			PlayerInventory.second_slot()
			
		elif event.is_action_pressed("third_slot"):
			PlayerInventory.third_slot()
		
		elif event.is_action_pressed("fourth_slot"):
			PlayerInventory.fourth_slot()
			
		elif event.is_action_pressed("fifth_slot"):
			PlayerInventory.fifth_slot()
			
		elif event.is_action_pressed("sixth_slot"):
			PlayerInventory.sixth_slot()
			
		elif event.is_action_pressed("seventh_slot"):
			PlayerInventory.seventh_slot()
			
		elif event.is_action_pressed("eighth_slot"):
			PlayerInventory.eighth_slot()
			
		elif event.is_action_pressed("nineth_slot"):
			PlayerInventory.nineth_slot()
			
		elif event.is_action_pressed("tenth_slot"):
			PlayerInventory.tenth_slot()
			
		#PlayerStats.connect("no_health",self,"queue_free")

func _physics_process(_delta):
	#So stamina gains stamina while they are in the inventory
	if Globalvars.in_inventory == true:
		PlayerStats.stamina += 0.2
	#Hides hotbar and inventory if you die
	if PlayerStats.health <= 0:
		self.queue_free()
		$Hotbar/HotbarSlots.hide()

		


	
