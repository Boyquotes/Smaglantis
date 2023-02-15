extends Control

func _ready():
	$VBoxContainer/StartButton.grab_focus()

func _on_StartButton_pressed():
	$TransitionScreen.transition()
	
func _on_QuitButton_pressed():
	get_tree().quit()

func _on_TransitionScreen_transitioned():
	var data = DataManager.load_game()
	if data == null:
		get_tree().change_scene("res://CharacterCreator.tscn")
	else:
		get_tree().change_scene("res://World.tscn")
	
