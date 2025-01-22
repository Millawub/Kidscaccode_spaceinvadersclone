extends Area2D

@export var speed = 150

@export var cooldown = 0.25
@export var bullet_scene : PackedScene
var can_shoot = true

@onready var screensize = get_viewport_rect().size

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	start()
	
func start():
	position = Vector2(screensize.x/2,screensize.y - 64)
	$GunCooldown.wait_time = cooldown


func shoot():
	if not can_shoot:
		return
	can_shoot = false
	$GunCooldown.start()
	var b = bullet_scene.instantiate()
	get_tree().root.add_child(b)
	b.start(position + Vector2(0,-8))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var input = Input.get_vector("left","right","up","down")
	
	if input.x > 0:
		$Ship.frame = 2
		$Ship/Boosters.animation = "right"
	elif input.x < 0:
		$Ship.frame = 0
		$Ship/Boosters.animation = "left"
	else:
		$Ship.frame = 1
		$Ship/Boosters.animation = "forward"
		
	
	position += input * speed * delta
	position = position.clamp(Vector2(8,8), screensize - Vector2(8,8))
	
	if Input.is_action_pressed("shoot"):
		shoot()


func _on_gun_cooldown_timeout() -> void:
	can_shoot = true
