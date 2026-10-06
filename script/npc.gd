extends CharacterBody3D

const speed = 30.0
var current_state = IDLE

var dir = Vector2.RIGHT
var start_pos

var is_roaming = true
var is_chatting = false

var player
var player_in_chat_zone = false

enum {
	IDLE,
	NEW_DIR,
	MOVE
	
}


func _ready():
	randomize()
	start_pos = position
func _process(delta):
	if current_state == 0 or current_state == 1:
		$AnimatedSprite3D.play("default")
	elif current_state == 2 and !is_chatting:
		if dir.x == -1:
			$AnimatedSprite3D.play("default")
		if dir.x == 1:
			$AnimatedSprite3D.play("default")
		if dir.y == -1:
			$AnimatedSprite3D.play("default")
		if dir.y == 1:
			$AnimatedSprite3D.play("default")
	
	if is_roaming:
		match current_state:
			IDLE:
				pass
			NEW_DIR:
				dir = choose([Vector2.RIGHT, Vector2.UP, Vector2.LEFT, Vector2.DOWN])
			MOVE:
				move(delta)
	if Input.is_action_just_pressed("chat"):
		print("chatting with npc")
		$Dialogue.start()
		is_roaming = false
		is_chatting = true
		$AnimatedSprite3D.play("default")

func choose(array):
	array.suffle()
	return array.front()

func move(delta):
	if !is_chatting:
		position += dir * speed * delta


func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	move_and_slide()

func _on_area_3d_body_entered(body):
	if body.has_method("player"):
		player = body
		player_in_chat_zone = true

func _on_area_3d_body_exited(body ):
	if body.has_method("player"):
		player_in_chat_zone = false
		

func _on_timer_timeout():
	$Timer.wait_time = choose([1.5, 1, 2.5])
	current_state = choose([IDLE, NEW_DIR, MOVE])

func _on_dialogue_dialogue_finished():
	is_chatting = false
	is_roaming = true 
