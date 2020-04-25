extends Node2D

const TIMER_LIMIT = .02

export(bool) var interactive = false
export(float) var windForce = 0
export(float) var windDirection = 0
export(float) var followAngle = 0
export(float) var heightGrass = 1 setget _setHeightGrass
export(float) var grassYOffset = 20
export(float, 60, 150) var interactiveArea = 90
export(float) var maxRotate = 45.0
export(int, 1, 100) var maxProcess = 50
export(ShaderMaterial) var leafMaterial
export(Vector2) var randomGrass = Vector2.ZERO
export(Array) var groupInteractive:Array = ["interact_grass"]

var timerDelta:float = 0.0
var direction:float = 1
var dirWind:float = 1
var rotWindMin:float = 0
var rotWindMax:float = 0
var interact_object
var speed:float = 0.08
var texture: Texture
var windTime = 0
var timer
var flag = 'MIN'
var rnd = RandomNumberGenerator.new()

func _ready() -> void:
	# Add the leaf to group
	add_to_group("TBP_GrassLeaf")
	
	rnd.randomize()
	
	# Create a sprite to texture
	var sprite = Sprite.new()
	sprite.name = "Sprite"
	sprite.texture = texture
	sprite.material = leafMaterial
	sprite.centered = false
	var s = sprite.texture.get_size()
	var h = s.y

	# Create a control to crop de sprite
	var g = Control.new()
	g.name = "Control"
	g.rect_min_size = s
	g.rect_size = s
	g.rect_position.x = -s.x / 2
	g.rect_position.y = -s.y + grassYOffset
	g.rect_pivot_offset.x = s.x / 2
	g.rect_pivot_offset.y = s.y + grassYOffset
	g.rect_clip_content = true
	
	# adjust the heighGrass
	sprite.offset.y = (1.0 - heightGrass) * h
	
	# settings the wind rotations and wind direction
	_configure(g)
	
	# If interactive
	if interactive:
		# create Area with collision to contact
		var area = Area2D.new()
		var collision = CollisionShape2D.new()
		var cshape = RectangleShape2D.new()
		
		# connect signals
		area.connect("body_entered", self, "_on_area_body_entered")
		area.connect("body_exited", self, "_on_area_body_exited")
		
		# setting the shape and collision
		cshape.extents.x = interactiveArea
		cshape.extents.y = (heightGrass * h) - grassYOffset
		collision.shape = cshape
		collision.position.y = -(heightGrass * h) - grassYOffset
		collision.rotation = followAngle
		call_deferred("add_child", area)
		area.call_deferred("add_child", collision)
	
	g.call_deferred("add_child", sprite)
	call_deferred("add_child", g)
	
	# set physics off
	set_physics_process(false)
	
	# if exists wind force
	if windForce != 0:
		windTime = g.rect_rotation
		
		# create a timer
		timer = Timer.new()
		timer.wait_time = .01
		timer.autostart = true
		timer.one_shot = false
		timer.connect("timeout", self, "_on_timer_wind")
		add_child(timer)

func _physics_process(delta) -> void:
	if !interactive: return
	
	# limite the physics process to increase fps
	timerDelta += delta
	if timerDelta > TIMER_LIMIT:
		timerDelta = 0.0

		var per = 0
		if interact_object != null:
			if weakref(interact_object).get_ref():
				# calculates the collision percentage
				var percent = interactiveArea
				var s = self.global_position.distance_to(interact_object.global_position)
				per = 1.0 - clamp(s * 100.0 / percent, 0, 100.0) / 100.0
			
		# rotates the leaf according to the object that collided
		rotation = lerp(rotation, clamp(per, 0, deg2rad(maxRotate)) * direction, speed)

func _configure(control)->void:
	# settings the wind rotations and wind direction
	rotWindMin = rnd.randf_range(deg2rad(maxRotate) * randomGrass.x, deg2rad(maxRotate) * randomGrass.y)
	rotWindMax = deg2rad(maxRotate)
	
	control.rect_rotation = rad2deg(rotWindMin + followAngle)

	if windForce > 0:
		rotWindMin *= windDirection
		rotWindMax *= windDirection
		control.rect_rotation = (rad2deg(abs(rotWindMax - rotWindMin)) * (windForce)) - 0
		
	if windForce != 0:
		windTime = control.rect_rotation

func _on_area_body_entered(body) -> void:
	# if the collided object is in the group
	if _checkGroup(body) and interactive:
		interact_object = body
		# get the direction of the collision
		direction = -sign(interact_object.global_position.x - self.global_position.x)
		# checks how many physics are being precessed for the leafs, and validates that it is within the limit
		if get_parent().grassProcess < maxProcess:
			get_parent().grassProcess += 1
			set_physics_process(true)

func _on_area_body_exited(body) -> void:
	if _checkGroup(body):
		interact_object = null
		
		yield(get_tree().create_timer(.2), "timeout")
		set_physics_process(false)
			
		if get_parent().grassProcess > 0:
			get_parent().grassProcess -= 1

func _on_timer_wind() -> void:
	# moves the leafs according to the wind
	var minn = (rad2deg(abs(rotWindMax-rotWindMin)) * (windForce)) - 0
	var total = rad2deg(abs(rotWindMax-rotWindMin))
	
	if windTime <= total and flag == 'MIN':
		windTime += rnd.randf() * windForce
		if windTime > total:
			flag = 'MAX'

	if windTime >= minn and flag == 'MAX':
		windTime -= rnd.randf() * windForce
		if windTime < minn:
			flag = 'MIN'

	$Control.rect_rotation = lerp($Control.rect_rotation, windTime * windDirection, .1 * windForce) 

# validates the group and if the object has global_position
func _checkGroup(body) -> bool:
	for g in groupInteractive:
		if body.is_in_group(g) and body.get("global_position") != null:
			return true
			break
	return false

# setget to change heighGrass
func _setHeightGrass(newHeight) -> void:
	heightGrass = newHeight

	if Engine.editor_hint: return
	var sprite = $Control/Sprite
	if sprite == null: return
	if weakref(sprite).get_ref():
		var h = sprite.texture.get_size().y
		sprite.offset.y = ((1.0 - heightGrass) * h)
