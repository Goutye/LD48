extends Node2D

var drag_item
var is_displaying_popup = false
var player
var camera
var UIPopupVbox
var SkillUI = load("res://Scenes/SkillUI.tscn")

func _ready():
	UIPopupVbox = $Popup/PanelContainer/VBoxContainer
	$Popup.visible = false

func initialize(camera, player : Player):
	self.player = player
	self.camera = camera

func _process(delta):
	$Stats/PanelContainer/VBoxContainer/HP/StatValue.text = "%d/%d" % [player.HP, player.MaxHP]
	if is_displaying_popup:
		var mouse_position = (get_viewport().get_mouse_position() + camera.offset) / 4
	
func generate_popup(item):
	UIPopupVbox.get_node("Name").text = item.name
	if item.HP > 0:
		add_skill("HP", item.HP)
	if item.defence > 0:
		add_skill("Defence", item.defence)
	if item.attack > 0:
		add_skill("Attack", item.attack)
	if item.attack_speed > 0.0:
		add_skill("Atk Speed", item.attack_speed)
	if item.piercing > 0:
		add_skill("Piercing", item.piercing)
	if item.vampirism > 0.0:
		add_skill("Vampirism", item.vampirism)
	if item.dodge > 0.0:
		add_skill("Dodge", item.dodge)
	$Popup.visible = true
			
func add_skill(name, value):
	var skill = SkillUI.instance()
	skill.get_node("StatName").text = name
	if value is int:
		skill.get_node("StatValue").text = "+%d" % value
	else:
		skill.get_node("StatValue").text = "+%1.0f%%" % (value * 100)
	UIPopupVbox.add_child(skill)

func reset_popup():
	$Popup.visible = false
	for child in UIPopupVbox.get_children():
		if not child is Label:
			UIPopupVbox.remove_child(child)

func update_stats_ui():
	$Stats/PanelContainer/VBoxContainer/Attack/StatValue.text = "+%d" % player.attack
	$Stats/PanelContainer/VBoxContainer/Defence/StatValue.text = "+%d" % player.defence
	$Stats/PanelContainer/VBoxContainer/AtkSpd/StatValue.text = "+%1.0f%%" % (player.attack_speed * 100)
	$Stats/PanelContainer/VBoxContainer/Piercing/StatValue.text = "+%d" % player.piercing
	$Stats/PanelContainer/VBoxContainer/Vamp/StatValue.text = "+%1.0f%%" % (player.vampirism * 100)
	$Stats/PanelContainer/VBoxContainer/Dodge/StatValue.text = "+%1.0f%%" % (player.dodge * 100)

func _on_Ability_mouse_entered():
	pass


func _on_Ability_mouse_exited():
	pass # Replace with function body.


func _on_Profession_mouse_entered():
	pass # Replace with function body.


func _on_Profession_mouse_exited():
	pass # Replace with function body.


func _on_Spell_mouse_entered():
	pass # Replace with function body.


func _on_Spell_mouse_exited():
	pass # Replace with function body.

func _on_Helmet_mouse_entered():
	generate_popup(player.helmet)

func _on_Helmet_mouse_exited():
	reset_popup()
	
func _on_Armor_mouse_entered():
	generate_popup(player.armor)


func _on_Armor_mouse_exited():
	reset_popup()


func _on_Weapon_mouse_entered():
	generate_popup(player.weapon)


func _on_Weapon_mouse_exited():
	reset_popup()
