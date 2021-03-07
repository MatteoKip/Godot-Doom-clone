extends KinematicBody
 
const MOVE_SPEED = 3
 
onready var raycast = $RayCast
onready var anim_player = $AnimationPlayer
 
var player = null
var dead = false
var velocity = Vector3()
var gravity = -100
var current_health = 100
 
func _ready():
	anim_player.play("Walk")
	add_to_group("zombies")
 
func _physics_process(delta):
	if dead:
		return
	if player == null:
		return
 
	var vec_to_player = player.translation - translation
	vec_to_player = vec_to_player.normalized()
	raycast.cast_to = vec_to_player * 1.5
	velocity.y += gravity *delta
	velocity = move_and_slide(velocity, Vector3.UP)
	move_and_collide(vec_to_player * MOVE_SPEED * delta)
 
	if raycast.is_colliding():
		var coll = raycast.get_collider()
		if coll != null and coll.name == "Player":
			coll.kill()

func health(health):
	print(current_health)
	current_health = current_health - health
	if current_health < 1:
		kill()

func kill():
	dead = true
	$CollisionShape.disabled = true
	anim_player.play("Die")
 
func set_player(p):
	player = p
