# PauseMenu.gd
extends CanvasLayer

@onready var resume_button = $Control/Resume
@onready var settings_button = $Control/Settings
@onready var mainmenu_button = $Control/MainMenu
@onready var load_button = $Control/Load
@onready var save_button = $Control/Save

func _ready():
	# Connect button signals
	resume_button.pressed.connect(_on_resume_pressed)
	settings_button.pressed.connect(_on_settings_pressed)
	mainmenu_button.pressed.connect(_on_mainmenu_pressed)
	load_button.pressed.connect(_on_load_pressed)
	save_button.pressed.connect(_on_save_pressed)

	visible = false  # Start hidden

func toggle_pause():
	get_tree().paused = not get_tree().paused
	visible = get_tree().paused

func _on_resume_pressed():
	toggle_pause()

func _on_settings_pressed():
	print("Settings menu not implemented yet.")

func _on_mainmenu_pressed():
	print("Go to main menu (not implemented yet).")
	# Example: get_tree().change_scene_to_file("res://scenes/MainMenu.tscn")

func _on_load_pressed():
	if SaveManager.load_game():
		get_tree().reload_current_scene()

func _on_save_pressed():
	var player = get_node("/root/Game/MeshInstance3D")  # Update path if needed
	SaveManager.save_game(player.global_position, player.inventory, player.stats)
	print("Game saved.")
