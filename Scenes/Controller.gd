extends Spatial


func _input(event):
	if Input.is_action_pressed("pause") and get_tree().paused == true:
		get_tree().paused = false
