extends CharacterBody2D


const normal_speed = 200.0
const JUMP_VELOCITY = -400.0
const dash_speed = 800.0
const dash_length = 0.2

var SPEED
var jump_count = 0
var is_crouch = false

var standing_cshape = preload("res://resources/stand_cshape.tres")
var crouching_cshape = preload("res://resources/crouch_cshape.tres")

@onready var sprite = $AnimatedSprite2D
@onready var dash_timer = $Timer
@onready var cshape = $CollisionShape2D

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	else:
		jump_count = 0

	# Handle jump.
	if Input.is_action_just_pressed("jump") and jump_count < 2:
		jump_count += 1
		velocity.y = JUMP_VELOCITY

	# Handle dash
	if Input.is_action_just_pressed("dash"):
		start_dash(dash_length)
	
	SPEED = dash_speed if dash() else normal_speed
	
	#Handle crouch
	if Input.is_action_just_pressed("crouch"):
		crouch()
	elif Input.is_action_just_released("crouch"):
		stand()

	# Set movement horizontally
	var direction_x := Input.get_axis("move_left", "move_right")
	
	if direction_x < 0:
		sprite.flip_h = true
	elif direction_x > 0:
		sprite.flip_h = false
	
	# Move left or right
	if direction_x:
		velocity.x = direction_x * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
	
	animation(direction_x)
	
func animation(direction_x):
	if is_on_floor():
		if direction_x == 0:
			if is_crouch:
				sprite.play("crouch")
			else:
				sprite.play("idle")
		else:
			if SPEED == dash_speed:
				sprite.play("dash")
			else: 
				sprite.play("walk")
	else:
		if velocity.y < 0:
			sprite.play("jump")
		elif velocity.y > 0:
			sprite.play("fall")

func start_dash(dur):
	dash_timer.wait_time = dur
	dash_timer.start()

func dash():
	return !dash_timer.is_stopped()

func crouch():
	if is_crouch:
		return
	is_crouch = true
	cshape.shape = crouching_cshape
	cshape.position.y = 21

func stand():
	if is_crouch == false:
		return
	is_crouch = false
	cshape.shape = standing_cshape
	cshape.position.y = 16
