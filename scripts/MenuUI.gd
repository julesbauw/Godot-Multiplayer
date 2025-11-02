extends Control



func _on_server_pressed():
    NetworkHandler.start_server()

func _on_client_pressed():
    NetworkHandler.start_client()
