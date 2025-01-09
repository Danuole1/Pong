extends StaticBody2D

var ball_pos : Vector2
var distance : int
var move_by : int
var win_height : int
var p_height : int

# Called when the node enters the scene tree for the first time.
func _ready():
	win_height = get_viewport_rect().size.y  #Getting height of the window
	p_height = $ColorRect.get_size().y #Getting height of the colorRect node, a child of the CPU node which this script is for


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#Move the paddle towards the ball
	ball_pos = $"../Ball".position
	distance = position.y - ball_pos.y
	
	if abs(distance) > get_parent().PADDLE_SPEED * delta: #Check if distance is greater than the speed the paddle can move (also prevent divide by 0 errors)
		move_by = get_parent().PADDLE_SPEED * delta * (distance / abs(distance)) # the brackets section is there to get the + or - of the distance variable, as abd() means always positive, while keeping it only 1 so the calculation isn't thrown off
	else: #If the paddle is close enough that it does't need it's full movement, just make move_by the distance is needs to go, which could even be 0. This stops jitteryness caused by overshooting the distance
		move_by = distance
		
	position.y -= move_by
	position.y = clamp(position.y, p_height / 2, win_height - p_height / 2)
