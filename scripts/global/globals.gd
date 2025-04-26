extends Node

var in_dialogue : bool

#Suspicion: If suspicion is at 100 and the player triggers [scene transition], then the game will end with a cutscene of the police finding them.
var suspicion : int

#Sanity: Starts at 100. If Sanity is reduced to 0 and the player triggers [scene transition], then the game will end with a cutscene of the player being taken to an asylum.
var sanity : int

#To change scenes using a loading screen:
# 1. if you have already called load_threaded_request on the scene, set Globals.load_requested to true.
# 2. set target_scene_path to the file path of your desired scene
# 3. do get_tree().change_scene_to_file("res://scenes/menu_scenes/loading_screen.tscn")

#If the player is in a loading screen or the main menu, this is the scene that is loading in.
#If the player is not in a loading screen, this is the scene they are currently in.
var target_scene_path: String = "res://scenes/dentist_building_scene.tscn"

#true if the target scene has already started loading (such as in the main menu)
var load_requested: bool

#Story's current state. Numbers for story markers below.
#This also can be saved along with other global vars to save the player's progress.
var story_level : float = 0
# 0: Prologue
# 1: Beginning of chapter 1
# 1.1: Mr. Cho has been sedated
# 1.2: Mr. Cho's teeth have been extracted
# 1.3: Teeth have been placed into the gum model at home
# 2: Beginning of chapter 2
# 2.1: Called teacher
# 2.2: Teacher has been sedated
# 2.3: Teeth extracted
# 2.4: Teeth placed into the gum model
# 3: Called the principal
# 3.1: Brought the principal in, either by convincing, or by force.
# 3.2: Principal sedated
# 3.3: Teeth extracted
# 3.4: Teeth placed into the gum model
# 4: Ending
