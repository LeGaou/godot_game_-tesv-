extends CharacterBody3D

@export var move_speed = 5.0
@export var gravity = 20.0
@export var jump_velocity = 8.0
@export var mouse_sensitivity = 0.005

@onready var pivot = $Pivot
@onready var camera = $Pivot/Camera3D

var inventory: Dictionary = {}
var stats = {
	"level": 1,
	"exp": 0,
	"exp_to_next": 100,
	"hp": 100,
	"mp": 50,
	"attack": 10,
	"defense": 5
}

var yaw = 0.0  # Horizontal camera rotation

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _unhandled_input(event):
	if event is InputEventMouseMotion:
		yaw -= event.relative.x * mouse_sensitivity
		pivot.rotation.y = yaw  # rotate camera pivot
		rotation.y = yaw        # rotate player to face same direction

func _physics_process(delta):
	var direction = Vector3.ZERO

	if Input.is_action_pressed("ui_up"):
		direction.z -= 1
	if Input.is_action_pressed("ui_down"):
		direction.z += 1
	if Input.is_action_pressed("ui_left"):
		direction.x -= 1
	if Input.is_action_pressed("ui_right"):
		direction.x += 1

	direction = direction.normalized()

	# Rotate input to follow camera direction
	direction = pivot.global_transform.basis * direction
	direction.y = 0
	direction = direction.normalized()

	# Horizontal velocity
	var horizontal_velocity = direction * move_speed
	velocity.x = horizontal_velocity.x
	velocity.z = horizontal_velocity.z

	# Gravity
	if not is_on_floor():
		velocity.y -= gravity * delta
	else:
		if Input.is_action_just_pressed("ui_accept"):
			velocity.y = jump_velocity

	move_and_slide()

# Optional: ESC to release mouse
func _input(event):
	if event.is_action_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
