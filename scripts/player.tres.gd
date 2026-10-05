extends CharacterBody2D
# Oznámí hlavní scéně, že hráč právě dokončil cestu.
signal destination_reached

@export var speed: float = 150

@onready var agent: NavigationAgent2D = $NavigationAgent2D

# Animovaný boční pohled používaný během chůze.
@onready var sprite: AnimatedSprite2D = $"chůze"

# Přední pohled používaný, když hráč stojí.
@onready var front_sprite: Sprite2D = $"postava-zepředu"

var has_target: bool = false
# Během dialogu bude tato hodnota false.
var movement_enabled: bool = true

# Zobrazí stojící postavu čelem k obrazovce.
func show_front_view() -> void:
	# Boční animaci zastavíme a schováme.
	sprite.stop()
	sprite.hide()

	# Zobrazíme přední obrázek.
	front_sprite.show()


# Přepne postavu na boční pohled připravený k chůzi.
func show_side_view() -> void:
	# Přední obrázek už nesmí být vidět.
	front_sprite.hide()

	# Zobrazíme animovaný boční pohled.
	# Samotnou animaci spustíme až při skutečném pohybu.
	sprite.show()


func _ready() -> void:
	motion_mode = CharacterBody2D.MOTION_MODE_FLOATING
	agent.path_desired_distance = 4.0
	agent.target_desired_distance = 4.0

	# Použijeme tvoji existující animaci se šesti snímky.
	sprite.animation = "default"

	# Hra začíná se stojící postavou otočenou čelem.
	show_front_view()


func _unhandled_input(event: InputEvent) -> void:
	# Během dialogu hráč nesmí přijímat nové cíle.
	if not movement_enabled:
		return
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			set_destination(get_global_mouse_position())


func set_destination(clicked_position: Vector2) -> void:
	var navigation_map: RID = agent.get_navigation_map()

	# Po spuštění počkáme, až bude navigační mapa připravená.
	if NavigationServer2D.map_get_iteration_id(navigation_map) == 0:
		return

	var closest_point: Vector2 = NavigationServer2D.map_get_closest_point(
		navigation_map,
		clicked_position
	)

	# Kliknutí mimo navigační plochu ignorujeme.
	# Tolerance 10 pixel řeší drobné nepřesnosti na hranici.
	if clicked_position.distance_to(closest_point) > 10.0:
		return

	agent.target_position = closest_point
	has_target = true
	# Cíl je platný, proto se ještě před zahájením pohybu
	# přepneme z předního na boční pohled.
	show_side_view()

func set_movement_enabled(enabled: bool) -> void:
	# Uložíme nový stav pohybu.
	movement_enabled = enabled

	# Při vypnutí zrušíme i případnou rozehranou cestu.
	if not movement_enabled:
		has_target = false
		velocity = Vector2.ZERO
		update_animation(Vector2.ZERO)


func _physics_process(delta: float) -> void:
	# Pokud je pohyb zakázaný, hráč zůstane stát.
	if not movement_enabled:
		velocity = Vector2.ZERO
		has_target = false
		update_animation(Vector2.ZERO)
		return
	# Bez cíle stojíme a zobrazujeme přední pohled.
	if not has_target:
		velocity = Vector2.ZERO
		update_animation(Vector2.ZERO)
		return

	# Na konci cesty také zastavíme pohyb i animaci.
	if agent.is_navigation_finished():
		velocity = Vector2.ZERO
		has_target = false
		update_animation(Vector2.ZERO)
		# Hlavní scéna se díky tomu dozví, že hráč došel do cíle.
		destination_reached.emit()
		return

	# Navigace nám dá následující bod vypočítané cesty.
	var next_point: Vector2 = agent.get_next_path_position()

	# Rozdíl pozic udává směr a vzdálenost k tomuto bodu.
	var offset: Vector2 = next_point - global_position

	# Nastavíme rychlost směrem k bodu.
	# U blízkého bodu krok zkrátíme, abychom ho nepřejeli.
	velocity = offset.normalized() * minf(
		speed,
		offset.length() / delta
	)

	# Nejdřív skutečně provedeme pohyb včetně kolizí.
	move_and_slide()

	# Potom podle výsledného pohybu nastavíme animaci a otočení.
	update_animation(get_real_velocity())

func update_animation(actual_velocity: Vector2) -> void:
	# length() vrací velikost rychlosti bez ohledu na směr.
	# Pohyb menší než 1 pixel za sekundu bereme jako stání,
	# aby drobné nepřesnosti zbytečně nezapínaly animaci.
	if actual_velocity.length() < 1.0:
		# Postava se nepohybuje, proto zobrazíme přední pohled.
		show_front_view()
		return

	# Postava se pohybuje, proto přehráváme chůzi.
	# Opakované play() stejné animace ji nerestartuje.
	sprite.play("default")

	# V Godotu roste X doprava:
	# záporné X = pohyb doleva, kladné X = pohyb doprava.
	# Při téměř svislé chůzi zachováme poslední otočení.
	if absf(actual_velocity.x) > 1.0:
		# Původní obrázek hledí doleva.
		# Při pohybu doprava (kladné X) ho proto zrcadlíme.
		sprite.flip_h = actual_velocity.x > 0.0
