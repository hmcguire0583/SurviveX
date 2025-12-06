func _on_area_body_entered(body):
	if body.is_in_group("player"):
		body.hop_on_boat(self)
