extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


func _input(event):
	if event is InputEventKey:
		# speedrun mode
		#if event.is_action_pressed("ui_down"): 
		#	Scenechanger.change_scene("res://nodes/Stage00.tscn", true)
		
		if event.pressed:
			Scenechanger.change_scene("res://nodes/Intro.tscn", true)
