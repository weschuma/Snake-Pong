extends CharacterBody2D


const speed :=5

func _ready() -> void:
	velocity = Vector2(-speed, 0) * collision_count if collision_count > 0 else Vector2(-speed, 0)

var collision_count = 0

func _physics_process(delta: float) -> void:
	var col := move_and_collide(velocity)
	if col:
		var normal := col.get_normal()
		velocity = velocity.bounce(normal)
		collision_count + 1
		
	
