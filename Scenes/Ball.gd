extends CharacterBody2D

var win_size : Vector2
const START_SPEED : int = 500
var ACCELERATION : int = 50
const MAX_Y_DIRECTION_VECTOR : float = 0.6
var speed : int
var direction : Vector2

func _ready():
	win_size = get_viewport_rect().size

func new_ball():
	#randomise new ball location
	position.x = win_size.x /2
	position.y = randi_range(200, win_size.y - 200)
	speed = START_SPEED
	direction = randomdirection()
	
func _physics_process(delta):
	var collision = move_and_collide(direction * speed * delta)
	var collider
	
	if collision: #will be null when not colliding
		collider = collision.get_collider() #returns the object the ball collided with
		
		#If the balls hits a paddle
		if collider == $"../Player":
			var charge : float = $"../Player".get_charge()
			var effect = (charge * ACCELERATION) - 60
			
			
			if Input.is_action_pressed("ui_accept"):
				print("effect: ", effect)
				speed = speed + effect
				
				print(speed)
			else:
				speed += ACCELERATION
			direction = new_direction(collider)
			
		elif collider == $"../CPU":
			speed += ACCELERATION
			direction = new_direction(collider)
		else:
			direction = direction.bounce(collision.get_normal())

# Makes a random direction for a new ball to travel
func randomdirection():
	var new_direction := Vector2()
	new_direction.x = [1,-1].pick_random()
	new_direction.y = randf_range(-1,1)
	return new_direction.normalized()

#makes a new direction of travel based on the location of the collision relative to the location of the paddle
func new_direction(collider):
	var ball_y = position.y
	var pad_y = collider.position.y
	var distance = ball_y - pad_y
	var new_direction := Vector2()
	
	#flip the horizontal direction
	if direction.x > 0:
		new_direction.x = -1
	else:
		new_direction.x = 1
	new_direction.y = (distance / (collider.p_height /2) * MAX_Y_DIRECTION_VECTOR)
	return new_direction.normalized()
