extends Node2D


# Fyzikální vrstvy jsou uloženy jako jednotlivé bity.
# "1 << 1" znamená druhou fyzikální vrstvu, tedy naši vrstvu Interakce.
const INTERACTION_LAYER: int = 1 << 1

# Stejnou toleranci 5 pixelů používáme také ve skriptu hráče.
# Bod považujeme za pochozí, pokud je nejbližší bod navigace
# vzdálený maximálně o tuto hodnotu.
const WALKABLE_TOLERANCE: float = 5.0

# Jedna položka představuje jednu repliku.
# "speaker" je jméno mluvčího a "text" je zobrazovaná věta.
const FAMILY_DIALOGUE = [
	{
		"speaker": "Grunt",
		"text": "Kde je večeře? Už mi kručí v břiše!"
	},
	{
		"speaker": "Trifa",
		"text": "Není z čeho…"
	},
	{
		"speaker": "Dip",
		"text": "Mám hlad :("
	},
	{
		"speaker": "Grunt",
		"text": "Opravdu již nic nezbylo?"
	},
	{
		"speaker": "Trifa",
		"text": "Opravdu ne, poslední kus proviantu jsme snědli včera, musíš dojít…"
	},
	{
		"speaker": "Grunt",
		"text": "Co mi zbyde, půjdu"
	},
	{
		"speaker": "Dip",
		"text": "Tati pozor na zlo…"
	},
	{
		"speaker": "Trifa",
		"text": "Pravda, pravda"
	},
	{
		"speaker": "Grunt",
		"text": "Nebojte se, vrátím se dříve než udeří 6."
	}
]


# Odkaz na navigační oblast ve scéně.
# @onready znamená, že se hodnota načte až po vytvoření uzlů scény.
@onready var navigation_region: NavigationRegion2D = $NavigationRegion2D

# Hlavní scéna bude řídit hráče a dialog.
@onready var player = $Player
@onready var dialogue_ui = $DialogueUI

# Bod, ke kterému hráč přijde před zahájením rodinného dialogu.
@onready var family_interaction_point: Marker2D = $RodinaInterakce/InteractionPoint

# Pamatujeme si současný kurzor.
# Díky tomu ho nebudeme zbytečně nastavovat šedesátkrát za sekundu.
var current_cursor := Input.CURSOR_ARROW

# True znamená, že hráč právě míří k rodině.
var pending_family_dialogue: bool = false


func _ready() -> void:
	# Při spuštění hry začneme obyčejnou šipkou.
	set_cursor(Input.CURSOR_ARROW)

	# Až hráč dokončí cestu, zavolá se naše připravená funkce.
	player.destination_reached.connect(_on_player_destination_reached)

	# Po skončení dialogu se zavolá funkce, která hráče uvolní.
	dialogue_ui.dialogue_finished.connect(_on_dialogue_finished)

func _input(event: InputEvent) -> void:
	# Během rozhovoru kliknutí zpracovává DialogueUI.
	if dialogue_ui.is_active:
		return

	# Pokračujeme pouze při stisknutí levého tlačítka.
	if not event is InputEventMouseButton:
		return

	if event.button_index != MOUSE_BUTTON_LEFT or not event.pressed:
		return

	# Zjistíme, zda se pod myší nachází interaktivní Area2D.
	var clicked_interaction: Area2D = get_interaction_at(
		get_global_mouse_position()
	)

	# Kliknutí mimo interakci znamená obyčejnou chůzi.
	if clicked_interaction == null:
		pending_family_dialogue = false
		return

	# Kliknutí na jinou interakci zruší cestu k rodinnému dialogu.
	pending_family_dialogue = false

	# Zatím zvlášť zpracujeme pouze rodinný dialog.
	if clicked_interaction.is_in_group("family_dialogue"):
		pending_family_dialogue = true

		# Hráč nejde přímo na obrázek postav, ale k připravené značce.
		player.set_destination(family_interaction_point.global_position)

		# Stejné kliknutí už nesmí zpracovat skript hráče.
		get_viewport().set_input_as_handled()


func _physics_process(_delta: float) -> void:
	# Pozice myši v souřadnicích herního světa.
	# Funguje správně i při použití Camera2D.
	var mouse_position := get_global_mouse_position()

	# Nejprve hledáme interaktivní objekt.
	# Ten má přednost, i když zároveň leží na pochozí zemi.
	if is_over_interaction(mouse_position):
		set_cursor(Input.CURSOR_POINTING_HAND)

	# Pokud pod myší není interakce, zkontrolujeme navigační plochu.
	elif is_walkable(mouse_position):
		set_cursor(Input.CURSOR_CROSS)

	# Myš není ani nad interakcí, ani nad pochozí zemí.
	else:
		set_cursor(Input.CURSOR_ARROW)


func get_interaction_at(point: Vector2) -> Area2D:
	# Připravíme fyzikální dotaz na jeden bod.
	var query := PhysicsPointQueryParameters2D.new()
	query.position = point
	query.collide_with_areas = true
	query.collide_with_bodies = false
	query.collision_mask = INTERACTION_LAYER

	# Najdeme Area2D, jejichž kolizní tvar obsahuje tento bod.
	var results := get_world_2d().direct_space_state.intersect_point(
		query,
		8
	)

	# Pod kurzorem není žádná interakce.
	if results.is_empty():
		return null

	# Každý výsledek je Dictionary.
	# Položka "collider" obsahuje nalezenou Area2D.
	return results[0]["collider"] as Area2D


func is_over_interaction(point: Vector2) -> bool:
	# Pro změnu kurzoru stačí vědět, zda byla nějaká Area2D nalezena.
	return get_interaction_at(point) != null


func is_walkable(point: Vector2) -> bool:
	# Získáme mapu, kterou používá NavigationRegion2D.
	var navigation_map := navigation_region.get_navigation_map()

	# Hodnota 0 znamená, že navigace ještě nebyla připravena.
	if NavigationServer2D.map_get_iteration_id(navigation_map) == 0:
		return false

	# Navigace nám vrátí nejbližší bod na pochozí ploše.
	var closest_point := NavigationServer2D.map_get_closest_point(
		navigation_map,
		point
	)

	# Pokud je nejbližší bod téměř stejný jako pozice myši,
	# nachází se kurzor přímo nad pochozí plochou.
	return point.distance_to(closest_point) <= WALKABLE_TOLERANCE


func set_cursor(new_cursor: Input.CursorShape) -> void:
	# Pokud už je nastaven správný kurzor, není co měnit.
	if new_cursor == current_cursor:
		return

	current_cursor = new_cursor
	Input.set_default_cursor_shape(new_cursor)

func _on_player_destination_reached() -> void:
	# Běžné dokončení chůze žádný dialog nespouští.
	if not pending_family_dialogue:
		return

	# Čekající interakci spotřebujeme.
	# Dialog se díky tomu nespustí opakovaně.
	pending_family_dialogue = false

	# Hráč během dialogu nesmí chodit.
	player.set_movement_enabled(false)

	# Předáme připravené repliky dialogovému rozhraní.
	dialogue_ui.start_dialogue(FAMILY_DIALOGUE)


func _on_dialogue_finished() -> void:
	# Po poslední replice znovu povolíme pohyb.
	player.set_movement_enabled(true)
