extends StaticBody2D

var win_height : int
var p_height : int
var charge: float = 0.0
var is_charging: bool = false
const CHARGE_MULTIPLIER: int = 1
const MAX_CHARGE = 2

# Called when the node enters the scene tree for the first time.
func _ready():
	win_height = get_viewport_rect().size.y  #Getting height of the window
	p_height = $ColorRect.get_size().y #Getting height of the colorRect node, a child of the player node which this script is for


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_pressed("ui_up"):
		position.y -= get_parent().PADDLE_SPEED * delta
	elif Input.is_action_pressed("ui_down"):
		position.y += get_parent().PADDLE_SPEED * delta
		
	# Limit Paddle Movement to the window
	position.y = clamp(position.y, p_height / 2, win_height - p_height / 2)
	
	if is_charging:
		if charge < MAX_CHARGE:
			charge += delta * CHARGE_MULTIPLIER  # Adjust the multiplier to control charge speed
		else:
			charge = MAX_CHARGE
	else:
		charge = 0
	
	update_color_rect()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept"):  # Default action for Space
		is_charging = true
	elif event.is_action_released("ui_accept"):
		is_charging = false

func get_charge():
	return charge
	
func update_color_rect() -> void:
	$ColorRect.color = Color.WHITE.lerp(Color.DARK_RED, charge / MAX_CHARGE) #Interoplate between White and red based by on the charge value
