extends Spatial

func _ready():
	GameInfo.ui = $UI
	GameInfo.main_cam = $MainCam
	GameInfo.test_thing = $TestThing
	GameInfo.test_thing_2 = $TestThing2
	GameInfo.center_cube = $CenterCube

var day_time := 0.2 # 0 - .5 = Day; .5 - 1 = Night
var day_time_speed := 0.001

export var sun_energy := 2.5
export(Curve) var sun_energy_curve: Curve
export var moon_energy := 1.5
export(Curve) var moon_energy_curve: Curve
export(Curve) var background_energy_curve: Curve

func _physics_process(delta):
	day_time += day_time_speed * delta
	if day_time > 1:
		day_time -= 1
	
	$Lights.rotation.z = (day_time*2 - .5) * PI
	$Lights/Sun.light_energy = sun_energy * sun_energy_curve.interpolate_baked(day_time)
	$Lights/Sun.visible = sun_energy_curve.interpolate_baked(day_time) > .01
	$Lights/Moon.light_energy = moon_energy * moon_energy_curve.interpolate_baked(day_time)
	$Lights/Moon.visible = moon_energy_curve.interpolate_baked(day_time) > .01
	$WorldEnvironment.environment.background_energy = background_energy_curve.interpolate_baked(day_time)
