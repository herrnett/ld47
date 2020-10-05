extends KinematicBody2D


var ghostdata = []
var ghostindex = 0
var ghostsize = 0
var currentghost = []


func _ready():
	self.visible = false
	if !Globals.ghost: $CollisionShape2D.disabled = true


func _physics_process(_delta):
	if Globals.ghost:
		self.visible = true
		if ghostindex == 0:
			ghostdata = Globals.ghostdata
			ghostsize = Globals.ghostdata.size()
			$Timer.start(0.5)
			
		if ghostindex < ghostsize:
			currentghost = ghostdata[ghostindex]
			reposition()
			ghostindex += 1
		else: 
			ghostindex = 0
			$CollisionShape2D.disabled = true
			reposition()
			
	if Input.is_action_just_pressed("ui_accept"):
		ghostindex = 0
	
	# save position of next ghost based on current ghost while piggybacking to prevent stuttering
	if $Ontop.visible:
		Globals.tempghostdata.append([Vector2(self.position.x, self.position.y-14), $Ontop.animation, $AnimatedSprite.frame, $AnimatedSprite.flip_h])


func reposition():
	self.position = currentghost[0]
	$AnimatedSprite.animation = currentghost[1]
	$AnimatedSprite.frame = currentghost[2]
	$AnimatedSprite.flip_h = currentghost[3]


func _on_Timer_timeout():
	$CollisionShape2D.disabled = false

# Redundant. Ghostindex is now set to zero in Player.gd/loop().
# TODO: More elegant solution would be adding a reset-function here and calling it in Player.gd
#func _on_Killplane_body_entered(_body):
#	ghostindex = 0

