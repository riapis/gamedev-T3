extends CharacterBody2D


var player_inzone = false

func _physics_process(delta: float) -> void:
	pass

	move_and_slide()

func enemy():
	pass



func _on_area_hit_body_entered(body: Node2D) -> void:
	if body.has_method("player"):
		player_inzone = true


func _on_area_hit_body_exited(body: Node2D) -> void:
	if body.has_method("player"):
		player_inzone = false
