extends CanvasLayer

# Tyto signály později použijeme k zastavení a uvolnění hráče.
signal inventory_opened
signal inventory_closed

# Celé pozadí inventáře včetně obrázku a budoucích předmětů.
@onready var inventory_background: PanelContainer = $InventoryBackground
@onready var inventory_button: Button = $"inventář-tlačítko"

# Pamatujeme si, zda je inventář právě otevřený.
var is_open: bool = false


func _ready() -> void:
	# Po spuštění hry má být vidět pouze tlačítko.
	inventory_background.hide()

	# Po stisknutí tlačítka zavoláme toggle_inventory().
	inventory_button.pressed.connect(toggle_inventory)


func toggle_inventory() -> void:
	# Obrátíme současný stav:
	# false se změní na true a true se změní na false.
	is_open = not is_open

	# Viditelnost panelu bude odpovídat novému stavu.
	inventory_background.visible = is_open

	if is_open:
		inventory_button.text = "Close"
		inventory_opened.emit()
	else:
		inventory_button.text = "Inventory"
		inventory_closed.emit()
