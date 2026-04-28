class_name HighScoreStore extends RefCounted

const SAVE_PATH := "user://high_score.cfg"
const SECTION := "score"
const HIGH_SCORE_KEY := "high_score"

static func load_high_score() -> int:
	var config := ConfigFile.new()
	var error := config.load(SAVE_PATH)
	if error != OK:
		return 0

	return int(config.get_value(SECTION, HIGH_SCORE_KEY, 0))

static func save_high_score(score: int) -> bool:
	var high_score := load_high_score()
	if score <= high_score:
		return false

	var config := ConfigFile.new()
	config.set_value(SECTION, HIGH_SCORE_KEY, score)
	var error := config.save(SAVE_PATH)
	return error == OK
