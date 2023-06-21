extends CharacterBody2D

const SPEED = 250

func _physics_process(_delta):
	velocity.x = Input.get_axis("ui_left", "ui_right")
	velocity.y = Input.get_axis("ui_up", "ui_down")
	velocity = velocity.normalized() * SPEED
	move_and_slide()
