extends TextureRect
class_name InventorySlot

# Každý slot má jednu ze tří úloh.
enum SlotType {
	STORAGE,
	COMBINATION,
	RESULT
}

# V Inspectoru se objeví nabídka Storage, Combination a Result.
@export var slot_type: SlotType = SlotType.STORAGE

# Tento signál oznámí inventáři, že se obsah slotu změnil.
signal item_changed

# Prázdný text znamená, že slot neobsahuje žádný předmět.
var item_id: String = ""


# Vrátí true, pokud je ve slotu nějaký předmět.
func has_item() -> bool:
	return item_id != ""


# Vloží předmět do slotu.
func set_item(new_item_id: String, new_texture: Texture2D) -> void:
	item_id = new_item_id
	texture = new_texture
	item_changed.emit()


# Vyprázdní slot.
func clear_item() -> void:
	item_id = ""
	texture = null
	item_changed.emit()
