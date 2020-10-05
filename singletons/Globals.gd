extends Node

var gothat = false
var gotshoes = false # TODO: Implement shoe-sprites in Player.gd
var ghost = false
var ghostdata = []
var tempghostdata =[]
var maxjumps = 1

var gotcurrentplant = false
var plantscollected = 0

var gotcurrentanimal = false
var animalscollected = 0



func addplant(body, player, plant):
	if body == player and plant.get_node("AnimatedSprite").visible:
		plant.get_node("Gotplant/AnimationPlayer").play("gotplant")
		plant.get_node("AnimatedSprite").visible = false
		gotcurrentplant = true
		plantscollected += 1

func addanimal(body, player, animal):
	if body == player and animal.get_node("AnimatedSprite").visible:
		animal.get_node("Gotanimal/AnimationPlayer").play("gotanimal")
		animal.get_node("AnimatedSprite").visible = false
		gotcurrentanimal = true
		animalscollected += 1
