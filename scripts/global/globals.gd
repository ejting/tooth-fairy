extends Node

var in_dialogue : bool

#Suspicion: If suspicion is at 100 and the player triggers [scene transition], then the game will end with a cutscene of the police finding them.
var suspicion : int

#Sanity: Starts at 100. If Sanity is reduced to 0 and the player triggers [scene transition], then the game will end with a cutscene of the player being taken to an asylum.
var sanity : int

#Story's current state. Numbers for story markers below.
#This also can be saved along with other global vars to save the player's progress.
var storyLevel : float
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
