tool
extends Path2D

# EXPORTS
export(Array, Color) var colorGrass: Array = [
	Color(.1, .25, .02, 1),
	Color(.09, .18, .05, 1),
	Color(.12, .29, .03, 1),
	Color(.24, .31, .08, 1),
	Color(.34, .46, .09, 1),
]

export(int) var blur_samples: int = 8 # blur sample
export(float, 0, 1) var blur_strength: float = 0 # blur strenght
export(Color) var colorTerrain: Color = Color(0.07, 0.03, 0, 1) # terrain color
export(bool) var generateTerrain = true # generate static terrain with collision?
export(float) var maxHeightTerrain = 500 # generate static terrain with collision?

"""
CAUTION
interval: this parameter if far below 15 can make it slow enough if 'interactive' is active.

For better performance, increase the space between the sheets, 
and together you can limit the number of processes in 'maxProcess'
"""
export(float, 2, 500) var interval = 15 # space between leafs
export(bool) var interactive = true # interacts leafs with objects in the "groupInteractive"
export(int, 1, 100) var maxProcess = 20 # maximum physics processes at the same time for that leaf segment


export(float, 60, 150) var interactiveArea = 100 # total pixels "width" to interactive area with the object
export(bool) var followAngle = true # should the leafs follow the curve of the terrain?
export(float, 0.0 , 1.0) var heightGrass = 1 setget _setHeightGrass # grass height
export(float, -1, 1) var randomGrassMin = -.3 # minimum range to randomize leaf rotation
export(float, -1, 1) var randomGrassMax = .3 # maximum range to randomize leaf rotation
export(float, 0, 1) var windForce = .3 setget _setWindForce # wind force
export(float, -1, 1) var windDirection = .6 setget _setWindDirection # wind direction (-1: left) -> (1: right)
export(float) var grassZIndex = 0
export(float) var grassYOffset = 20
export(float, 0, 90) var maxLeafRotateDegree = 45.0
export(Array, Texture) var grassTextures: Array = [
	preload("res://addons/TBP_GrassPath2D/assets/grass0.png"),
	preload("res://addons/TBP_GrassPath2D/assets/grass1.png"),
	preload("res://addons/TBP_GrassPath2D/assets/grass2.png"),
	preload("res://addons/TBP_GrassPath2D/assets/grass3.png"),
	preload("res://addons/TBP_GrassPath2D/assets/grass4.png"),
	preload("res://addons/TBP_GrassPath2D/assets/grass5.png"),
	preload("res://addons/TBP_GrassPath2D/assets/grass6.png"),
	preload("res://addons/TBP_GrassPath2D/assets/grass7.png"),
	preload("res://addons/TBP_GrassPath2D/assets/grass8.png"),
	preload("res://addons/TBP_GrassPath2D/assets/grass9.png"),
	preload("res://addons/TBP_GrassPath2D/assets/grass10.png"),
	preload("res://addons/TBP_GrassPath2D/assets/grass11.png"),
	preload("res://addons/TBP_GrassPath2D/assets/grass12.png"),
	preload("res://addons/TBP_GrassPath2D/assets/grass13.png"),
	preload("res://addons/TBP_GrassPath2D/assets/grass14.png"),
	preload("res://addons/TBP_GrassPath2D/assets/grass15.png"),
	preload("res://addons/TBP_GrassPath2D/assets/grass16.png"),
	preload("res://addons/TBP_GrassPath2D/assets/grass17.png"),
	preload("res://addons/TBP_GrassPath2D/assets/grass18.png"),
	preload("res://addons/TBP_GrassPath2D/assets/grass19.png"),
]

# group to collide
export(Array, String) var groupInteractive: Array = [
	"interact_grass"
]

# LOCAL
var grassProcess = 0
var grassLoaded = []
var rnd = RandomNumberGenerator.new()

func _setWindDirection(newDirection) -> void:
	windDirection = newDirection
	
	if !Engine.editor_hint:
		for g in grassLoaded:
			g.windDirection = windDirection
			
func _setWindForce(newForce) -> void:
	windForce = newForce
	
	if !Engine.editor_hint:
		for g in grassLoaded:
			g.windForce = windForce

func _setHeightGrass(newHeight) -> void:
	heightGrass = newHeight
	
	if !Engine.editor_hint:
		for g in grassLoaded:
			g.heightGrass = heightGrass

func _ready() -> void:
	if curve.get_baked_points().size() <= 0:
		var screenSize = get_viewport_rect().size
		curve.add_point(Vector2.ZERO + Vector2(0,screenSize.y - 50))
		curve.add_point(Vector2.ZERO + Vector2(screenSize.x,screenSize.y - 50))
	
	if Engine.editor_hint: return
	if curve == null: return # if no curve
	if curve.get_baked_points().size() <= 0: return # if no curve drawn
	
	self.curve.bake_interval = interval
	_generateGrass()
	
	if generateTerrain:
		_generateTerrain()

func _generateGrass() -> void:
	if Engine.editor_hint: return
	if grassTextures.size() <= 0: return # if no textures selected
	
	# if no color grass selected, append a green color
	if colorGrass.size() <= 0:
		colorGrass.append(Color(.1, .25, .02, 1))
	
	# local randomize
	rnd.randomize()
	
	# load the noise texture to blur shader
	var img = Image.new()
	img.load("res://addons/TBP_GrassPath2D/noise.png")
	
	var tx = ImageTexture.new()
	tx.create_from_image(img, 0)

	# load the blur shader
	var smat = ShaderMaterial.new()
	smat.shader = preload("res://addons/TBP_GrassPath2D/blur.shader")
	smat.set_shader_param("angle_degrees", maxLeafRotateDegree)
	smat.set_shader_param("samples", blur_samples)
	smat.set_shader_param("strength", blur_strength)
	smat.set_shader_param("noise", tx)
	
	var idx = 0
	var total = curve.get_baked_points().size()
	for x in curve.get_baked_points():
		if idx == total: return
		
		var ang = 0
		if followAngle:
			if idx < ( total - 1 ):
				# obtains the angle between the points of the curve
				var current_point = curve.get_baked_points()[idx]
				var next_point = curve.get_baked_points()[idx + 1]
				ang = current_point.angle_to_point(next_point)
				ang += PI
				
				if windForce > 0:
					followAngle = false
		idx+=1
		
		# create the leaf
		var grass = load("res://addons/TBP_GrassPath2D/TBP_GrassLeaf.gd").new()
		grass.interactive = interactive
		grass.groupInteractive = groupInteractive
		grass.maxProcess = maxProcess
		grass.interactiveArea = interactiveArea
		grass.randomGrass = Vector2(randomGrassMin, randomGrassMax)
		grass.maxRotate = maxLeafRotateDegree
		grass.windForce = windForce
		grass.windDirection = windDirection
		grass.heightGrass = heightGrass
		grass.grassYOffset = grassYOffset
		grass.leafMaterial = smat
		grass.texture = grassTextures[rnd.randi() % grassTextures.size()]
		grass.global_position = x
		grass.modulate = colorGrass[rnd.randi() % colorGrass.size()]
		grass.followAngle = ang
		grass.z_index = grassZIndex
		grassLoaded.append(grass)
		call_deferred("add_child", grass)

func _generateTerrain() -> void:
	if Engine.editor_hint: return
	var arr: PoolVector2Array = []
	var f = null
	var l = null
	
	# get the curve points
	if curve and curve.get_baked_points().size() > 0:
		for x in curve.get_baked_points():
			if f == null:
				f = x
				arr.append(x)
			else:
				arr.append(x)
			l = x
		
		# connect end to start
		arr.append(l + Vector2(0, maxHeightTerrain))
		arr.append(f + Vector2(0, maxHeightTerrain))
		
		# create the polygon
		var poly = Polygon2D.new()
		poly.polygon = arr
		poly.color = colorTerrain
		
		# create the collision polygon
		var staticCollision = CollisionPolygon2D.new()
		staticCollision.polygon = arr

		# create the static body
		var staticBody = StaticBody2D.new()
		staticBody.call_deferred("add_child", staticCollision)

		call_deferred("add_child", staticBody)
		call_deferred("add_child", poly)

# TODO: preview in editor
#func _draw():
#	if Engine.editor_hint:
#		prints(1)
