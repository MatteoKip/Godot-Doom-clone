extends Spatial

func _input(event):
	if Input.is_action_pressed("pause"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		get_tree().set_pause(true)
		get_node("Pause menu").show()

func _on_Resume_button_up():
	print("Resume")
	get_tree().set_pause(false)
	get_node("Pause menu").hide()
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
