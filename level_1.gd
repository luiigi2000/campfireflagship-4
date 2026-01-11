extends Node2D

var correct_sequence = ["String","String2","String3","String4","String5","String6"]
var current_sequence = []

func _on_string_pressed() -> void:
	play_string($String/AudioStreamPlayer2D)


func _on_string_2_pressed() -> void:
	play_string($String2/AudioStreamPlayer2D2)


func _on_string_3_pressed() -> void:
	play_string($String3/AudioStreamPlayer2D3)


func _on_string_4_pressed() -> void:
	play_string($String4/AudioStreamPlayer2D4)


func _on_string_5_pressed() -> void:
	play_string($String5/AudioStreamPlayer2D5)
	
func _on_string_6_pressed() -> void:
	play_string($String6/AudioStreamPlayer2D6)

func play_string(guitar_string):
	guitar_string.play()
	current_sequence.push_back(guitar_string.get_parent().name)
	check_sequence()
	
func check_sequence():
	var sequence_correct := true
	for string_index in current_sequence.size():
		if current_sequence[string_index] != correct_sequence[string_index]:
			sequence_correct = false
			current_sequence.clear()
	if current_sequence.size() != correct_sequence.size():
		sequence_correct = false
	if sequence_correct:
		$"../Goal".modulate = Color.GREEN
		current_sequence = []
			
	
	
