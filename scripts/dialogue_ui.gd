extends CanvasLayer

# Tento signál později oznámí hře, že celý dialog skončil.
signal dialogue_finished

# Počet znaků, které se zobrazí za jednu sekundu.
@export var characters_per_second: float = 35.0

# Odkazy na části dialogového panelu.
@onready var panel: PanelContainer = $DialoguePanel
@onready var speaker_label: Label = $DialoguePanel/MarginContainer/VBoxContainer/SpeakerLabel
@onready var text_label: RichTextLabel = $DialoguePanel/MarginContainer/VBoxContainer/TextLabel
@onready var hint_label: Label = $DialoguePanel/MarginContainer/VBoxContainer/HintLabel

# Seznam všech replik aktuálního dialogu.
var lines: Array = []

# Pořadí právě zobrazené repliky.
var current_line: int = 0

# Desetinné číslo umožní plynule počítat rychlost vypisování.
var character_progress: float = 0.0

# Určuje, jestli právě probíhá dialog.
var is_active: bool = false


func _ready() -> void:
	# Dialog je po spuštění hry schovaný.
	panel.hide()


func _process(delta: float) -> void:
	# Pokud dialog neběží, není potřeba nic vypisovat.
	if not is_active:
		return

	# Zjistíme délku právě zobrazené repliky.
	var total_characters: int = text_label.get_total_character_count()

	# Pokud už je zobrazený celý text, ukážeme nápovědu.
	if text_label.visible_characters >= total_characters:
		hint_label.show()
		return

	# Přidáváme znaky podle rychlosti a času od posledního snímku.
	character_progress += characters_per_second * delta

	# RichTextLabel zobrazí jen určený počet znaků.
	text_label.visible_characters = min(
		int(character_progress),
		total_characters
	)


func start_dialogue(new_lines: Array) -> void:
	# Prázdný dialog nemá smysl spouštět.
	if new_lines.is_empty():
		return

	# Zapamatujeme si přijaté repliky.
	lines = new_lines
	current_line = 0
	is_active = true

	# Zobrazíme panel a připravíme první repliku.
	panel.show()
	show_current_line()


func show_current_line() -> void:
	# Vezmeme jednu repliku ze seznamu.
	var line: Dictionary = lines[current_line]

	# Každá replika bude mít jméno mluvčího a jeho text.
	speaker_label.text = line.get("speaker", "")
	text_label.text = line.get("text", "")

	# Na začátku nezobrazíme žádný znak.
	text_label.visible_characters = 0
	character_progress = 0.0

	# Nápověda se objeví, až se dopíše celý text.
	hint_label.hide()

func _input(event: InputEvent) -> void:
	# Mimo dialog necháme kliknutí zpracovat ostatní části hry.
	if not is_active:
		return

	# Zajímá nás pouze stisk levého tlačítka myši.
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			# Označíme kliknutí jako zpracované.
			# Díky tomu stejné kliknutí zároveň neposune hráče.
			get_viewport().set_input_as_handled()

			advance_dialogue()


func advance_dialogue() -> void:
	var total_characters: int = text_label.get_total_character_count()

	# Pokud se replika ještě vypisuje, první kliknutí ji pouze dopíše.
	if text_label.visible_characters < total_characters:
		text_label.visible_characters = total_characters
		character_progress = float(total_characters)
		hint_label.show()
		return

	# Text už byl celý zobrazený, takže přejdeme na další repliku.
	current_line += 1

	# Za poslední replikou dialog ukončíme.
	if current_line >= lines.size():
		finish_dialogue()
		return

	show_current_line()


func finish_dialogue() -> void:
	# Dialog už nebude zachytávat kliknutí.
	is_active = false

	# Schováme celý spodní panel.
	panel.hide()

	# Oznámíme ostatním částem hry, že dialog skončil.
	dialogue_finished.emit()
