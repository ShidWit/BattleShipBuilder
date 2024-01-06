# UI.gd
extends Control

signal add_block
signal remove_block
signal switch_to_test_mode

func _ready():
	# Connect your buttons to their respective signals
	get_node("AddButton").connect("pressed", self, "on_AddButton_pressed")
	get_node("RemoveButton").connect("pressed", self, "on_RemoveButton_pressed")
	get_node("TestButton").connect("pressed", self, "on_TestButton_pressed")

func on_AddButton_pressed():
	emit_signal("add_block")

func on_RemoveButton_pressed():
	emit_signal("remove_block")

func on_TestButton_pressed():
	emit_signal("switch_to_test_mode")
