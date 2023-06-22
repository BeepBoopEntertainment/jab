extends CharacterBody2D

const SPEED = 250

func _physics_process(_delta):
	velocity.x = Input.get_axis("ui_left", "ui_right")
	velocity.y = Input.get_axis("ui_up", "ui_down")
	velocity = velocity.normalized() * SPEED
	
	var selected = null
	if Input.is_key_pressed(KEY_UP):
		selected = "forward"
	if Input.is_key_pressed(KEY_DOWN):
		selected = "backward"
	if Input.is_key_pressed(KEY_LEFT):
		selected = "left"
	if Input.is_key_pressed(KEY_RIGHT):
		selected = "right"
		
	if selected == null:
		$AnimatedSprite2D.speed_scale = 0
	else:
		$AnimatedSprite2D.play(selected)
		$AnimatedSprite2D.speed_scale = 1
	
	move_and_slide()
