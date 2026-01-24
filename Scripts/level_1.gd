extends Node2D

var current_sequence = []
var all_notes = [preload("res://Audio/Scene1/a.wav"),preload("res://Audio/Scene1/b.wav"),preload("res://Audio/Scene1/c.wav"),preload("res://Audio/Scene1/d.wav"),preload("res://Audio/Scene1/d#.mp3"),preload("res://Audio/Scene1/e.mp3")]
var correct_sequence = [all_notes[5],all_notes[4],all_notes[5],all_notes[4],all_notes[5],all_notes[1],all_notes[3],all_notes[2],all_notes[0]] 
var all_same_notes = [all_notes[5],all_notes[5],all_notes[5],all_notes[5],all_notes[5],all_notes[5]]
var all_same_notes_debounce = false

func _ready() -> void:
	hover_to_functions()
	assign_note_sequence()
	
func hover_to_functions():
	for button in get_tree().get_nodes_in_group("Buttons"):
		button.connect("mouse_entered", Callable(self, "_on_button_hover"))
		button.connect("mouse_exited", Callable(self, "_on_button_exit"))

func _on_string_pressed() -> void:
	play_key($PianoKeys/Key/KeyAudio)


func _on_string_2_pressed() -> void:
	play_key($PianoKeys/Key2/Key2Audio)


func _on_string_3_pressed() -> void:
	play_key($PianoKeys/Key3/Key3Audio)


func _on_string_4_pressed() -> void:
	play_key($PianoKeys/Key4/Key4Audio)


func _on_string_5_pressed() -> void:
	play_key($PianoKeys/Key5/Key5Audio)
	
func _on_string_6_pressed() -> void:
	play_key($PianoKeys/Key6/Key6Audio)

func play_key(piano_key):
	piano_key.play()
	check_sequence(piano_key)
	
func assign_note_sequence():
	var index = 0
	var randomized_keys = []
	for key in $PianoKeys.get_children():
		randomized_keys.append(key)
	randomized_keys.shuffle()
	for key in randomized_keys:
		key.get_node(key.name+"Audio").stream = all_notes[index]
		index += 1
var count = 0
func check_sequence(piano_note):
	if all_same_notes_debounce:
		correct_sequence = all_same_notes
	var sequence_correct := true
	current_sequence.push_back(piano_note.stream)
	for note_index in current_sequence.size():
		if current_sequence[note_index] != correct_sequence[note_index]:
			sequence_correct = false
			current_sequence = []
			
	if sequence_correct and all_same_notes_debounce:
		count+=1
		print(count)
	if current_sequence.size() != correct_sequence.size():
		sequence_correct = false
	if sequence_correct:
		current_sequence = []
		Global.level_cleared()
		
func _on_button_hover():
	# button is the one hovered
	Input.set_custom_mouse_cursor(preload("res://Mouse/whitehandhover.png"))

func _on_button_exit():
	Input.set_custom_mouse_cursor(preload("res://Mouse/whitehandmove.png"))
