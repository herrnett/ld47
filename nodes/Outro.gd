extends Node2D


# Declare member variables here. Examples:
var opening = "And so Ari's journey came to an end. "
var notallanimals = "Some of her friends were left behind, but Ari was sure they'll be fine. Probably. "
var allanimals = "Ari and her friends were finally united. "
var allplants = "But where to put all those cacti? "
var everything = "Doesn't matter. Everything was perfect that day."


# Called when the node enters the scene tree for the first time.
func _ready():
	var message = opening
	
	if Globals.animalscollected >= 3: message = str(opening, allanimals)
	else: message = str(opening, notallanimals)
	
	if Globals.plantscollected >= 8: message = str(message, allplants)
	
	if Globals.animalscollected >= 3 and Globals.plantscollected >= 8: message = str(message, everything)
	
	$RichTextLabel.bbcode_text = str("[center]", message, "[/center]")
	
	$RichTextLabel2.bbcode_text = str("[center]Friends rescued: ", Globals.animalscollected, \
	"/3 - Plants collected: ", Globals.plantscollected, "/8[/center]")

func _input(event):
	if event is InputEventKey:
		Scenechanger.change_scene("res://nodes/Main.tscn", true)
