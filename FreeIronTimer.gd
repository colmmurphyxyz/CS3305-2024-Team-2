extends Timer

## How much iron to give the player after every timer timeout
const IRON_AMOUNT_PER_TIMEOUT: int = 20

func _on_timeout():
	GameManager.iron += IRON_AMOUNT_PER_TIMEOUT
