@tool
extends TextureRect

@export var coffee : int = 1:
	set(value):
		coffee = value
		size.x = coffee * 16
		visible = coffee > 0
			
