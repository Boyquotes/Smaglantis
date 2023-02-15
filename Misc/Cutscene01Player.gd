extends AnimationPlayer

func _ready():
	self.play("Cutscene01")
	Globalvars.inCutscene = true
	
func end_cutscene():
	Globalvars.inCutscene = false
