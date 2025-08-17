extends Control

@onready var new_game_button = $VBoxContainer/NewGame
@onready var load_game_button = $VBoxContainer/LoadGame
@onready var quit_button = $VBoxContainer/Quit

func _ready():
	# Disable "Load Game" if there's no save file
	load_game_button.disabled = !SaveManager.has_save()

	# Connect buttons to functions
	new_game_button.pressed.connect(_on_new_game_pressed)
	load_game_button.pressed.connect(_on_load_game_pressed)
	quit_button.pressed.connect(_on_quit_pressed)

func _on_new_game_pressed():
	# Start a new game (resets save data)
	SaveManager.save_data = {}
	get_tree().change_scene_to_file("res://scenes/Game.tscn")

func _on_load_game_pressed():
	# Load the saved data and go to the game scene
	if SaveManager.load_game():
		get_tree().change_scene_to_file("res://scenes/Game.tscn")

func _on_quit_pressed():
	# Close the game
	get_tree().quit()
