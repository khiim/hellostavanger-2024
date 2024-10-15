extends GPUParticles2D

@onready var explode_audio_stream_player_2d: AudioStreamPlayer2D = $ExplodeAudioStreamPlayer2D

var _lifetime : float = 0

func _ready() -> void:
	explode_audio_stream_player_2d.play()
	emitting = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	_lifetime += delta
	
	if lifetime > 1:
		print("Freeing explosion")
		queue_free()
