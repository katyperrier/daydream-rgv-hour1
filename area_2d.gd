extends Area2D
@export var landing_zone : Area2D
@onready var marker_2d: Marker2D = %Marker2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_body_entered(body: Node2D) -> void:
	print("test", body)
	var tp_point = marker_2d.global_position
	body.global_position = tp_point 
