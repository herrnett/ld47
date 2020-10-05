extends KinematicBody2D


# movement-related variables
const SPEED = 120
const JUMPPOWER = 220
const GRAVITY = 12
onready var velocity:Vector2 = Vector2.ZERO
onready var startposition = self.position
var jumpcount = 0

# position and orientation of ghost for piggybacking
var ghostposition
var ghostorientation


func _ready():
	var _err
	if get_parent().get_node_or_null("Plant") != null: 
		_err = get_parent().get_node("Plant").connect("body_entered", self, "_on_Sign_body_exited")
		
	if get_parent().get_node_or_null("Sign") != null:
		_err = get_parent().get_node("Sign").connect("body_entered", self, "_on_Sign_body_entered")
		_err = get_parent().get_node("Sign").connect("body_exited", self, "_on_Sign_body_exited")
	


func _physics_process(_delta):
	### MOVEMENT ###
	# When on floor, reset falling velocity and jumping ability. 
	# When mid-air, add gravity.
	if is_on_floor(): 
		velocity.y = 0
		jumpcount = 0
	else: 
		if velocity.y < 450: velocity.y += GRAVITY
		else: velocity.y = 450
	
	# Walking/standing plus respective animations.
	if Input.is_action_pressed("ui_right"):
		velocity.x = SPEED
		$AnimatedSprite.flip_h = false
		if is_on_floor():
			if Globals.gothat: $AnimatedSprite.animation = "hatwalk"
			else: $AnimatedSprite.animation = "walk"
	elif Input.is_action_pressed("ui_left"):
		velocity.x = -SPEED
		$AnimatedSprite.flip_h = true
		if is_on_floor():
			if Globals.gothat: $AnimatedSprite.animation = "hatwalkleft"
			else: $AnimatedSprite.animation = "walkleft"
	else:
		velocity.x = 0
		if is_on_floor(): 
			if !$AnimatedSprite.flip_h: 
				if Globals.gothat: $AnimatedSprite.animation = "hatstand"
				else: $AnimatedSprite.animation = "stand"
			else: 
				if Globals.gothat: $AnimatedSprite.animation = "hatstandleft"
				else: $AnimatedSprite.animation = "standleft"
	
	# Jumping plus animation. Check jumpcount to see if still able to doublejump.
	if Input.is_action_just_pressed("ui_up"):
		if jumpcount < Globals.maxjumps:
			velocity.y = -JUMPPOWER
			if !$AnimatedSprite.flip_h: 
				if Globals.gothat: $AnimatedSprite.animation = "hatjump"
				else: $AnimatedSprite.animation = "jump"
			else:
				if Globals.gothat: $AnimatedSprite.animation = "hatjumpleft"
				else: $AnimatedSprite.animation = "jumpleft"
			
			jumpcount += 1
	
	# Grab the ghost
	if Input.is_action_pressed("ui_down"):
		ghostposition = get_parent().get_node("Ghost").position
		ghostorientation = get_parent().get_node("Ghost/AnimatedSprite").flip_h
		if (ghostposition.x < self.position.x+7) \
		and (ghostposition.x > self.position.x-7) \
		and (((ghostposition.y-14) - self.position.y) <= 5) \
		and (((ghostposition.y-14) - self.position.y) >= -10) \
		and Globals.ghost:
			self.visible = false
			get_parent().get_node("Ghost/Ontop").visible = true
			get_parent().get_node("Ghost/Ontop").flip_h = ghostorientation
			if ghostorientation: 
				get_parent().get_node("Ghost/Ontop").animation = "hatcrouchleft"
				$AnimatedSprite.flip_h = ghostorientation
				$AnimatedSprite.animation = "hatcrouchleft"
			else: 
				get_parent().get_node("Ghost/Ontop").animation = "hatcrouch"
				$AnimatedSprite.flip_h = ghostorientation
				$AnimatedSprite.animation = "hatcrouch"
			self.position.x = ghostposition.x
			self.position.y = ghostposition.y-14
		else: 
			self.visible = true
			get_parent().get_node("Ghost/Ontop").visible = false
			
	if Input.is_action_just_released("ui_down"):
		$AnimatedSprite.flip_h = ghostorientation
		get_parent().get_node("Ghost/Ontop").visible = false
		self.visible = true
		
		
	
	# Reset position on accept
	if Input.is_action_just_pressed("ui_accept"):
		loop()
	
	# Execute movement
	velocity = move_and_slide(velocity, Vector2.UP, true)
	
	# Save new position to tempghostdata if already got hat and not piggybacking (Ghost will take over!)
	if Globals.gothat and self.visible:
		Globals.tempghostdata.append([self.position, $AnimatedSprite.animation, $AnimatedSprite.frame, $AnimatedSprite.flip_h])

func loop():
	# Write ghost-related data to globals if already got hat
	if Globals.gothat:
		Globals.ghostdata = Globals.tempghostdata
		Globals.ghost = true
		get_parent().get_node("Ghost").ghostindex = 0
	
	# Reset flowers and animals if needed
	if Globals.gotcurrentplant:
		Globals.plantscollected -=1
		Globals.gotcurrentplant = false
		get_parent().get_node("Plant/AnimatedSprite").visible = true
	if Globals.gotcurrentanimal:
		Globals.animalscollected -=1
		Globals.gotcurrentanimal = false
		if get_parent().get_node_or_null("Cat/AnimatedSprite") != null:
			get_parent().get_node("Cat/AnimatedSprite").visible = true
		if get_parent().get_node_or_null("Chicken/AnimatedSprite") != null:
			get_parent().get_node("Chicken/AnimatedSprite").visible = true
		if get_parent().get_node_or_null("Frog/AnimatedSprite") != null:
			get_parent().get_node("Frog/AnimatedSprite").visible = true
	
	# Start over
	Globals.tempghostdata = []
	self.position = startposition


func _on_Killplane_body_entered(body):
	if body == self:
		loop()


func _on_Area2D_body_entered(body):
	if body == self:
		loop()


func _on_Hat_body_entered(body):
	if body == self and get_parent().get_node("Hat/AnimatedSprite").visible:
		get_parent().get_node("Hat/RichTextLabel/AnimationPlayer").play("longfade")
		get_parent().get_node("Hat/AnimatedSprite").visible = false
		Globals.gothat = true


func _on_Shoes_body_entered(body):
	if body == self and get_parent().get_node("Shoes/AnimatedSprite").visible:
		get_parent().get_node("Shoes/RichTextLabel/AnimationPlayer").play("longfade")
		get_parent().get_node("Shoes/AnimatedSprite").visible = false
		Globals.gotshoes = true
		Globals.maxjumps = 2


func _on_Plant_body_entered(body):
	Globals.addplant(body, self, get_parent().get_node("Plant"))


func _on_Sign_body_entered(body):
	if body == self: get_parent().get_node("RichTextLabel").visible = true


func _on_Sign_body_exited(body):
	if body == self: get_parent().get_node("RichTextLabel").visible = false


func _on_Frog_body_entered(body):
	Globals.addanimal(body, self, get_parent().get_node("Frog"))


func _on_Cat_body_entered(body):
	Globals.addanimal(body, self, get_parent().get_node("Cat"))

func _on_Chicken_body_entered(body):
	Globals.addanimal(body, self, get_parent().get_node("Chicken"))
	Scenechanger.change_scene("res://nodes/Outro.tscn", true)
