extends Node2D

func _ready():
    $Screens/HowToPlay.visible = false
    $Screens/Credits.visible = false

func _on_play_pressed():
    pass # Replace with function body.

func _on_how_to_play_pressed():
    $Screens/HowToPlay.visible = !($Screens/HowToPlay.visible)

func _on_credits_pressed():
    $Screens/Credits.visible = !($Screens/Credits.visible)

func _on_close_htp_pressed():
    $Screens/HowToPlay.visible = !($Screens/HowToPlay.visible)

func _on_close_credits_pressed():
    $Screens/Credits.visible = !($Screens/Credits.visible)