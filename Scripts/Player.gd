extends KinematicBody
 
const speed = 4
const mouse_sensitivity = 0.25

var weapons = {
	"Pistol" : {
		damage = 33.5
	},
	"Shotgun" : {
		damage = 100
	}
}

var current_weapon_number = 1
var current_weapon = "Pistol"
export var angle_of_freedom = 80

onready var anim_player = $AnimationPlayer
onready var raycast = $RayCast
onready var weapon_sprite = $CanvasLayer/Control/Weapon
onready var camera = $Camera

func recoil():
	var recoil_amount = 1
	var recoil_vector = Vector3(clamp_angle_of_freedom(camera.rotation_degrees.x - recoil_amount), 0, 0)
	var shoot_animation = anim_player.get_animation("Shoot")
	var animation_frames = (shoot_animation.track_get_key_count(0))
	var recoil_duration = (anim_player.current_animation_length / animation_frames)
	$Tween.interpolate_property(camera, "rotation_degrees", camera.rotation_degrees, recoil_vector, recoil_duration, Tween.TRANS_BOUNCE, Tween.EASE_OUT)
	$Tween.start()

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	yield(get_tree(), "idle_frame")
	get_tree().call_group("zombies", "set_player", self)

func _input(event : InputEvent) -> void:
	if Input.is_action_pressed("toggle_fullscreen"):
		OS.window_fullscreen = !OS.window_fullscreen
	if event is InputEventMouseMotion:
		rotate_y(deg2rad(-event.relative.x * mouse_sensitivity));
		camera.rotate_x(deg2rad(-event.relative.y * mouse_sensitivity));
		var cam_rotation = camera.rotation_degrees;
		cam_rotation.x = clamp(cam_rotation.x, -90, 90);
		camera.rotation_degrees = cam_rotation;
	if Input.is_action_pressed("weapon_switch_up") and current_weapon_number <= 1:
		current_weapon_number += 1
	elif Input.is_action_pressed("weapon_switch_down") and current_weapon_number >= 1:
		current_weapon_number -= 1
	print(camera.rotation_degrees.x)

func _process(delta):
	$"HUD/FPS meter".text = str(Engine.get_frames_per_second())
	if Input.is_action_pressed("exit"):
		get_tree().quit()
	if Input.is_action_pressed("restart"):
		kill()
	if current_weapon_number == 1:
		current_weapon = "Pistol"
	if current_weapon_number == 2:
		current_weapon = "Shotgun"

func clamp_angle_of_freedom(angle):
	return clamp(angle, 90 + angle_of_freedom * -1, 90 - angle_of_freedom)
 
func _physics_process(delta):
	var movement = Vector3()
	if Input.is_action_pressed("move_forwards"):
		movement.z -= 1
	if Input.is_action_pressed("move_backwards"):
		movement.z += 1
	if Input.is_action_pressed("move_left"):
		movement.x -= 1
	if Input.is_action_pressed("move_right"):
		movement.x += 1
	movement = movement.normalized()
	movement = movement.rotated(Vector3(0, 1, 0), rotation.y)
	move_and_collide(movement * speed * delta)
 
	if Input.is_action_pressed("shoot") and !anim_player.is_playing():
		var damage = weapons[current_weapon].damage
		anim_player.play("Shoot")
		var coll = raycast.get_collider()
		if raycast.is_colliding() and coll.has_method("kill"):
			coll.health(damage)

func kill():
	get_tree().reload_current_scene()
