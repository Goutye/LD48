extends Node2D


var items = []
var LootScene = load("res://Scenes/Loot.tscn")
var LootsHBox
var callback_click = ["on_first_item_click", "on_second_item_click", "on_third_item_click"]
var callback_hover = ["on_first_item_hovered", "on_second_item_hovered", "on_third_item_hovered"]
var PopUpVBox
var SkillUI = load("res://Scenes/SkillUI.tscn")

func _ready():
	$PopUp.visible = false
	LootsHBox = $Control/PanelContainer/VBoxContainer/Loots/HBoxContainer
	PopUpVBox = $PopUp/PanelContainer/VBoxContainer
	
	
func initialize(portion_id, rarity):
	var nb_items = clamp(randi() % 3 + rarity, 1, 3)
	for i in range(nb_items):
		var item = Item.new()
		item.initialize(portion_id, rarity)
		items.append(item)
		var loot = LootScene.instance()
		loot.initialize(item.type)
		LootsHBox.add_child(loot)
		loot.connect("gui_input", self, callback_click[i])
		loot.connect("mouse_entered", self, callback_hover[i])
		loot.connect("mouse_exited", self, "on_item_unhovered")

func _process(delta):
	pass

func on_item_click(item):
	pass

func on_item_hovered(item):
	PopUpVBox.get_node("Name").text = item.name
	if item.HP > 0:
		add_skill("HP", item.HP)
	elif item.defence > 0:
		add_skill("Defence", item.defence)
	elif item.attack > 0:
		add_skill("Attack", item.attack)
	
	$PopUp.visible = true

func on_item_unhovered():
	$PopUp.visible = false
	for child in PopUpVBox.get_children():
		if not child is Label:
			PopUpVBox.remove_child(child)

func add_skill(name, value):
	var skill = SkillUI.instance()
	skill.get_node("StatName").text = name
	skill.get_node("StatValue").text = "+ %2.2f" % value
	PopUpVBox.add_child(skill)

func on_first_item_click(event):
	on_item_click(items[0])
	
func on_second_item_click(event):
	on_item_click(items[1])
	
func on_third_item_click(event):
	on_item_click(items[2])

func on_first_item_hovered():
	on_item_hovered(items[0])
	
func on_second_item_hovered():
	on_item_hovered(items[1])
	
func on_third_item_hovered():
	on_item_hovered(items[2])