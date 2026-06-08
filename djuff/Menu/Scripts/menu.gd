extends Node2D

@onready var animation
var linktree = "https://linktr.ee/VictorianStudio"

func _ready():
    get_tree().paused = false
    $Fade.visible = false
    $Screens/HowToPlay.visible = false
    $Screens/Credits.visible = false
    animation = $AnimationPlayer

func _on_play_pressed(): #começar o jogo
    $Fade.visible = true
    animation.play("start_game")

func _on_how_to_play_pressed(): #ver a tela de 'como jogar'
    animation.play("show_htp")
    $Screens/HowToPlay.visible = !($Screens/HowToPlay.visible)

func _on_credits_pressed(): #ver a tela de 'créditos'
    animation.play("show_credits")
    $Screens/Credits.visible = !($Screens/Credits.visible)

func _on_close_htp_pressed(): #fechar a tela de 'como jogar'
    animation.play("close_htp")

func _on_close_credits_pressed(): #fechar a tela de 'créditos'
    animation.play("close_credits")

func _on_animation_player_animation_finished(anim_name): #configuração das animações
    if anim_name == "close_credits":
        $Screens/Credits.visible = !($Screens/Credits.visible)

    if anim_name == "close_htp":
        $Screens/HowToPlay.visible = !($Screens/HowToPlay.visible)

    if anim_name == "start_game":
        get_tree().change_scene_to_file("res://Game/Scenes/MainGame.tscn")


func _on_texture_button_pressed():
    OS.shell_open(linktree)
