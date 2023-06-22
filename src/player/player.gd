extends CharacterBody2D

const SPEED = 250

func _physics_process(_delta):
	velocity.x = Input.get_axis("ui_left", "ui_right")
	velocity.y = Input.get_axis("ui_up", "ui_down")
	velocity = velocity.normalized() * SPEED
	var pressed_key = false
	if Input.is_key_pressed(KEY_UP):
		$AnimatedSprite2D.play("forward")
		$AnimatedSprite2D.speed_scale = 1
		pressed_key = true
	if Input.is_key_pressed(KEY_DOWN):
		$AnimatedSprite2D.play("backward")
		$AnimatedSprite2D.speed_scale = 1
		pressed_key = true
	if Input.is_key_pressed(KEY_LEFT):
		$AnimatedSprite2D.play("left")
		$AnimatedSprite2D.speed_scale = 1
		pressed_key = true
	if Input.is_key_pressed(KEY_RIGHT):
		$AnimatedSprite2D.play("right")
		$AnimatedSprite2D.speed_scale = 1
		pressed_key = true
		
	if !pressed_key:
		$AnimatedSprite2D.speed_scale = 0
	
	move_and_slide()
