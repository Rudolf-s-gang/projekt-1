extends Node2D


# Fyzikální vrstvy jsou uloženy jako jednotlivé bity.
# "1 << 1" znamená druhou fyzikální vrstvu, tedy naši vrstvu Interakce.
const INTERACTION_LAYER: int = 1 << 1

# Stejnou toleranci 5 pixelů používáme také ve skriptu hráče.
# Bod považujeme za pochozí, pokud je nejbližší bod navigace
# vzdálený maximálně o tuto hodnotu.
const WALKABLE_TOLERANCE: float = 5.0


# Odkaz na navigační oblast ve scéně.
# @onready znamená, že se hodnota načte až po vytvoření uzlů scény.
@onready var navigation_region: NavigationRegion2D = $NavigationRegion2D


# Pamatujeme si současný kurzor.
# Díky tomu ho nebudeme zbytečně nastavovat šedesátkrát za sekundu.
var current_cursor := Input.CURSOR_ARROW


func _ready() -> void:
	# Při spuštění hry začneme obyčejnou šipkou.
	set_cursor(Input.CURSOR_ARROW)


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


func is_over_interaction(point: Vector2) -> bool:
	# Vytvoříme popis fyzikálního dotazu.
	# Ptáme se: "Nachází se v tomto bodě nějaká Area2D?"
	var query := PhysicsPointQueryParameters2D.new()

	# Dotaz pracuje s globální pozicí ve světě.
	query.position = point

	# Zajímají nás pouze Area2D, ne pevná fyzikální tělesa.
	query.collide_with_areas = true
	query.collide_with_bodies = false

	# Prohledáváme pouze fyzikální vrstvu 2 – Interakce.
	# Hráčova Area2D na jiné vrstvě se proto nebude počítat.
	query.collision_mask = INTERACTION_LAYER

	# Provedeme dotaz ve fyzikálním světě.
	# Výsledkem je seznam oblastí, které obsahují zadaný bod.
	var results := get_world_2d().direct_space_state.intersect_point(
		query,
		8
	)

	# Pokud seznam není prázdný, pod myší je interaktivní oblast.
	return not results.is_empty()


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
