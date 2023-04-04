extends KinematicBody2D

var run_speed = 150
var jump_speed = -600
var gravity = 2500
var jumpQtd = 0
var jumpQtdMax = 1
export var sleeping = false
var analogPressed = false

var velocity = Vector2()

func get_input():
	if !analogPressed:
		velocity.x = 0
		var right = Input.is_action_pressed('ui_right')
		var left = Input.is_action_pressed('ui_left')

		if right:
			velocity.x += run_speed
		if left:
			velocity.x -= run_speed
		
	if is_on_floor():
		jumpQtd = 0

func _jump():
	if jumpQtd < jumpQtdMax:
		velocity.y = jump_speed
		jumpQtd += 1

func _physics_process(delta):
	if sleeping: return
	velocity.y += gravity * delta
	get_input()
	velocity = move_and_slide(velocity, Vector2(0, -1))

func _on_AnalogController_analogChange(force, pos):
	if pos is String:
		velocity.x = ((force) * (2 * scale) * run_speed).x
	else:
		velocity.x = ((pos * force) * run_speed).x

func _on_AnalogController_analogRelease():
	analogPressed = false
	velocity = Vector2.ZERO

func _input(event):
	if event.is_action_pressed("ui_accept"):
		_jump()
		
	if event is InputEventScreenTouch:
		if event.index == 1:
			_jump()


func _on_AnalogController_analogPressed():
	analogPressed = true
