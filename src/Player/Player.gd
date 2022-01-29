extends Control

export(Array, Texture) var PossibleTextures
var currentTexture = 0

func _ready():
	$CharacterControl/CharacterSprite.set_texture(PossibleTextures[currentTexture])
	$CharacterControl/CharacterSprite/AnimationPlayer.play("run")

#Change the sprite sheet used in the player's animations
func _change_sprite(newSprite):
	currentTexture = newSprite
	
	#Ensure the value passed in is not outside the bounds of the possible textures
	if (currentTexture < 0):
		currentTexture = 0
	if (currentTexture >= PossibleTextures.size()):
		currentTexture = PossibleTextures.size() - 1
		
	$CharacterControl/CharacterSprite.set_texture(PossibleTextures[currentTexture])

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
