extends CharacterBody2D

signal life_changed(life: int)
signal died
@export var life: int = 3:
	set(value):
		life = value
		life_changed.emit(life)
		if life <= 0:
			change_state(DEAD)

@export var gravity: float = 750
@export var run_speed: float = 150
@export var jump_speed: float = -300
var can_doublejump = false

enum {IDLE, RUN, JUMP, HURT, DEAD}
var state: int = IDLE
var _dust: CPUParticles2D = null

func get_dust() -> CPUParticles2D:
	if _dust == null:
		_dust = $Dust
	return _dust
func _ready() -> void:
	change_state(IDLE)
	
	
	
func change_state(new_state: int) -> void:
	state = new_state
	match state:
		IDLE:
			$AnimationPlayer.play("idle")
		RUN:
			$AnimationPlayer.play("run")
		JUMP:
			$AnimationPlayer.play("jump_down")
			$Jump.play()
		HURT:
			$AnimationPlayer.play("hurt")
			$Hurt.play()
			velocity.y = -300
			velocity.x = -150 * sign(velocity.x)
			life -= 1
			if life <= 0:
				change_state(DEAD)
				return;
			await get_tree().create_timer(0.5).timeout
			change_state(IDLE)
		DEAD:
			died.emit()
			hide()
	


func get_input() -> void:
	if state == HURT:
		return
			
	var right: bool = Input.is_action_pressed("right")
	var left: bool = Input.is_action_pressed("left")
	var jump: bool = Input.is_action_just_pressed("jump")
	
	# Movement occurs in all states
	velocity.x = 0
	
	if right:
		velocity.x += run_speed
		$Sprite2D.flip_h = false
	if left:
		velocity.x -= run_speed
		$Sprite2D.flip_h = true
	if state == HURT:
		return		
	if jump and is_on_floor():
		change_state(JUMP)  
		velocity.y = jump_speed
		print("jumped")
		can_doublejump = true
	if !is_on_floor() and can_doublejump and Input.is_action_just_pressed("jump"):
		velocity.y = jump_speed
		print("can double jump")
		change_state(JUMP)  
		can_doublejump = false
	if state == IDLE and velocity.x != 0:
		change_state(RUN)
	if state == RUN and velocity.x == 0:
		change_state(IDLE)
	if state in [IDLE, RUN] and !is_on_floor():
		change_state(JUMP)

func _physics_process(delta: float) -> void:
		# Free the node if it falls too far
	if position.y > 900:
		GameState.restart()
	
	velocity.y += gravity * delta
	# Process user input
	get_input()
	# Update the player
	move_and_slide() 
	
	for i in range(get_slide_collision_count()):
		var collision: KinematicCollision2D = get_slide_collision(i)
		var collider: Object = collision.get_collider()
		
		if collider.is_in_group("danger"):
			hurt()	
		if collider.is_in_group("enemies"):
			if position.y < collider.position.y:
				collider.take_damage()
				velocity.y = -200
			else:
				hurt()

	# Detect when a jump ends (move and slide's update to the is_on_floor)
	if state == JUMP and is_on_floor():
		change_state(IDLE)
		get_dust().emitting = true
	# Check if the character is "falling"
	if state == JUMP and velocity.y > 0:
		$AnimationPlayer.play("jump_down")
		
		
func reset(_position: Vector2) -> void:
	position = _position
	show()
	change_state(IDLE)
	life = 3
	
func hurt() -> void:
	if state != HURT:
		change_state(HURT)
