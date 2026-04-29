extends CanvasLayer

@onready var details: MarginContainer = $Details
@onready var score: Label = $Details/Scores/Score
@onready var high_score: Label = $Details/Scores/HighScore
@onready var game_over_screen: Control = $GameOverScreen
@onready var game_over: Label = $GameOverScreen/GameOver
@onready var level_achieved: Label = $GameOverScreen/LevelAchieved
@onready var high_score_result: Label = $GameOverScreen/HighScoreResult
@onready var retry_button: Button = $GameOverScreen/Buttons/RetryButton
@onready var main_menu_button: Button = $GameOverScreen/Buttons/MainMenuButton

var saved_high_score := 0

func _ready() -> void:
	saved_high_score = HighScoreStore.load_high_score()
	_update_score_text(0)
	retry_button.pressed.connect(_on_retry_button_pressed)
	main_menu_button.pressed.connect(_on_main_menu_button_pressed)

func _on_room_manager_level_cleared(new_level: int) -> void:
	_update_score_text(new_level)


func _on_game_game_started() -> void:
	details.visible = true


func _on_game_game_over(cur_level: int) -> void:
	var is_new_high_score := cur_level > saved_high_score
	if is_new_high_score:
		saved_high_score = cur_level

	level_achieved.text = "You have reached level " + str(cur_level) + "!"
	high_score_result.text = "NEW HIGH SCORE: " + str(saved_high_score) if is_new_high_score else "HIGH SCORE: " + str(saved_high_score)

	details.visible = false
	game_over_screen.visible = true

func _update_score_text(cur_level: int) -> void:
	score.text = "Level No.: " + str(cur_level)
	high_score.text = "High Score: " + str(saved_high_score)

func _on_retry_button_pressed() -> void:
	StageManager.change_stage(StageManager.GAME_STAGE)

func _on_main_menu_button_pressed() -> void:
	StageManager.change_stage(StageManager.MAIN_MENU_STAGE)
