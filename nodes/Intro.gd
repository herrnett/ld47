extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


func _input(event):
	if event is InputEventKey:
		Scenechanger.change_scene("res://nodes/Stage00.tscn", true)
