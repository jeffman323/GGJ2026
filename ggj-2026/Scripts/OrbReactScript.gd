extends TileMapLayer

@onready var orbRef = $"../../TheORB"
@onready var playerRef = $"../../PlayerCharacter"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if (playerRef.currentOrb!= null):
		RenderingServer.global_shader_parameter_set("orb_position", playerRef.global_position)
	else:
		RenderingServer.global_shader_parameter_set("orb_position", orbRef.global_position)
	pass
